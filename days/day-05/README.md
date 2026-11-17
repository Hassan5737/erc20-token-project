# Testing ERC-20 Allowances, Delegated Transfers, and Ownership

## Overview

This day extends the automated testing suite of the `Hassan (HSN)` ERC-20 token using Foundry.

After testing the constructor, owner-restricted minting, and direct token transfers, the focus moves to two important areas of smart contract behavior:

- ERC-20 approval and delegated token transfers.
- Ownership management and access control.

The goal is to verify not only that authorized operations work correctly, but also that unauthorized or invalid operations are rejected.

The testing suite covers four main areas:

1. Testing `approve()` and `allowance()`.
2. Testing `transferFrom()`.
3. Testing ownership transfer.
4. Testing ownership renunciation.

## Project Context

The Hassan token is built using Solidity and OpenZeppelin Contracts.

Its ERC-20 functionality is inherited from OpenZeppelin's implementation, while ownership management is provided by OpenZeppelin's `Ownable` contract.

The custom contract exposes an owner-restricted `mint()` function.

| Property | Value |
|---|---|
| Project | Hassan ERC-20 Token |
| Token Name | Hassan |
| Token Symbol | HSN |
| Token Standard | ERC-20 |
| Language | Solidity |
| Framework | Foundry |
| Contract Library | OpenZeppelin Contracts |
| Testing File | `test/Hassan.t.sol` |

## 1. Understanding ERC-20 Approvals and Allowances

ERC-20 supports delegated token spending.

This means a token holder can authorize another address to spend a specific amount of tokens on their behalf without transferring those tokens immediately.

Two important functions make this possible:

- `approve()`
- `allowance()`

### 1.1 What Is approve()?

The `approve()` function allows a token owner to authorize a spender to use a specified amount of their tokens.

Its interface is:

```solidity
approve(address spender, uint256 value)
```

For example, Alice owns 1,000 HSN and wants to allow Bob to spend up to 500 HSN.

She can call:

```solidity
token.approve(bob, 500 ether);
```

This does not transfer tokens to Bob.

Instead, it records an allowance that Bob can later use through `transferFrom()`.

### 1.2 What Is allowance()?

The `allowance()` function returns the remaining amount that a spender is authorized to spend on behalf of an owner.

Its interface is:

```solidity
allowance(address owner, address spender)
```

For example:

```solidity
token.allowance(alice, bob);
```

If Alice approved Bob to spend 500 HSN and Bob has not spent any of it, the allowance is 500 HSN.

### Understanding the Approval Flow

| Step | Operation | Result |
|---|---|---|
| 1 | Alice owns 1,000 HSN | Alice has 1,000 HSN |
| 2 | Alice approves Bob for 500 HSN | Allowance becomes 500 HSN |
| 3 | Bob spends 300 HSN | Alice's balance decreases by 300 HSN |
| 4 | Remaining allowance | 200 HSN |

The important distinction is that approval changes spending permissions, not token balances.

## 2. Testing Approve and Allowances

The first group of tests verifies the behavior of approvals and allowance tracking.

### 2.1 Testing Successful Approval

```solidity
function test_approve_success() public {
    vm.prank(alice);

    bool ok = token.approve(bob, 500e18);

    assertTrue(ok);
    assertEq(token.allowance(alice, bob), 500e18);
}
```

This test verifies that Alice can successfully approve Bob to spend 500 HSN.

**What happens?**

1. `vm.prank(alice)` makes Alice the caller of the next external call.
2. Alice approves Bob for 500 HSN.
3. The test verifies that `approve()` returns `true`.
4. The test checks that the allowance between Alice and Bob is exactly 500 HSN.

This confirms that the approval is recorded correctly.

### 2.2 Testing Approval Overwrite

```solidity
function test_approve_overwrite() public {
    vm.prank(alice);
    token.approve(bob, 500e18);

    vm.prank(alice);
    token.approve(bob, 200e18);

    assertEq(token.allowance(alice, bob), 200e18);
}
```

This test verifies what happens when an owner approves the same spender more than once.

Alice first approves Bob for 500 HSN, then changes the allowance to 200 HSN.

The resulting allowance is 200 HSN, not 700 HSN.

A new approval value replaces the previous allowance for that owner-spender pair.

### 2.3 Testing Approval to the Zero Address

```solidity
function test_approve_revertSpenderZero() public {
    vm.prank(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            IERC20Errors.ERC20InvalidSpender.selector,
            address(0)
        )
    );

    token.approve(address(0), 100e18);
}
```

This test verifies that approving the zero address as a spender is rejected.

OpenZeppelin's ERC-20 implementation uses the custom error:

```solidity
ERC20InvalidSpender(address spender)
```

The test uses `vm.expectRevert()` to verify that the expected error is returned when the invalid approval is attempted.

### 2.4 Testing the Approval Event

```solidity
function test_approve_emitsEvent() public {
    vm.prank(alice);

    vm.expectEmit(true, true, false, true);

    emit IERC20.Approval(alice, bob, 300e18);

    token.approve(bob, 300e18);
}
```

ERC-20 defines the `Approval` event:

```solidity
event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
);
```

This test verifies that approving Bob for 300 HSN emits the expected event.

The event contains:

- The token owner.
- The authorized spender.
- The approved amount.

Events are important because external applications and blockchain explorers can use them to observe approval activity.

## 3. Testing transferFrom()

The `transferFrom()` function allows an approved spender to transfer tokens from another account.

Its interface is:

```solidity
transferFrom(
    address from,
    address to,
    uint256 value
)
```

Unlike `transfer()`, which is normally called by the token holder to transfer their own tokens, `transferFrom()` supports delegated transfers.

### 3.1 Testing a Successful Delegated Transfer

```solidity
function test_transferFrom_success() public {
    token.mint(alice, 1000e18);

    vm.prank(alice);
    token.approve(bob, 500e18);

    vm.prank(bob);

    bool ok = token.transferFrom(alice, bob, 300e18);

    assertTrue(ok);
    assertEq(token.balanceOf(alice), 700e18);
    assertEq(token.balanceOf(bob), 300e18);
    assertEq(token.allowance(alice, bob), 200e18);
}
```

This test verifies the complete delegated transfer workflow.

**Step 1 — Mint tokens**

Alice receives 1,000 HSN.

**Step 2 — Approve the spender**

Alice authorizes Bob to spend up to 500 HSN.

**Step 3 — Execute the delegated transfer**

Bob calls:

```solidity
token.transferFrom(alice, bob, 300e18);
```

Bob transfers 300 HSN from Alice to himself using the allowance granted by Alice.

**Step 4 — Verify the resulting state**

| Property | Expected Result |
|---|---:|
| Alice's balance | 700 HSN |
| Bob's balance | 300 HSN |
| Remaining allowance | 200 HSN |

This test verifies that the token balances and remaining allowance are updated correctly.

### 3.2 Testing Insufficient Allowance

```solidity
function test_transferFrom_revertInsufficientAllowance() public {
    token.mint(alice, 1000e18);

    vm.prank(alice);
    token.approve(bob, 100e18);

    vm.prank(bob);

    vm.expectRevert(
        abi.encodeWithSelector(
            IERC20Errors.ERC20InsufficientAllowance.selector,
            bob,
            100e18,
            200e18
        )
    );

    token.transferFrom(alice, bob, 200e18);
}
```

This test verifies that a spender cannot transfer more tokens than the approved allowance.

Alice approves Bob for 100 HSN, but Bob attempts to transfer 200 HSN.

The operation must revert with:

```solidity
ERC20InsufficientAllowance(
    address spender,
    uint256 allowance,
    uint256 needed
)
```

The expected error data identifies:

- Spender: Bob.
- Available allowance: 100 HSN.
- Required allowance: 200 HSN.

This ensures that delegated transfers respect the owner's spending authorization.

### 3.3 Testing Infinite Approval

```solidity
function test_transferFrom_infiniteApproval() public {
    token.mint(alice, 1000e18);

    vm.prank(alice);
    token.approve(bob, type(uint256).max);

    vm.prank(bob);
    token.transferFrom(alice, bob, 500e18);

    assertEq(
        token.allowance(alice, bob),
        type(uint256).max
    );
}
```

ERC-20 implementations commonly support an infinite approval pattern.

In Solidity:

```solidity
type(uint256).max
```

returns the maximum value that can be represented by `uint256`.

OpenZeppelin's ERC-20 implementation treats this maximum allowance specially.

When a spender uses an infinite allowance, the allowance is not decreased after `transferFrom()`.

This test verifies that the remaining allowance is still equal to `type(uint256).max` after Bob transfers 500 HSN.

**Important:** Infinite approval is a convenience mechanism, but it also grants the spender broad spending permission. Users should understand the security implications before granting it.

### 3.4 Testing Transfer to the Zero Address

```solidity
function test_transferFrom_revertToZeroAddress() public {
    token.mint(alice, 100e18);

    vm.prank(alice);
    token.approve(bob, 100e18);

    vm.prank(bob);

    vm.expectRevert(
        abi.encodeWithSelector(
            IERC20Errors.ERC20InvalidReceiver.selector,
            address(0)
        )
    );

    token.transferFrom(alice, address(0), 50e18);
}
```

This test verifies that an approved spender cannot transfer tokens to the zero address.

Even though Alice has enough tokens and Bob has sufficient allowance, the recipient is invalid.

The transfer must therefore revert with `ERC20InvalidReceiver`.

This demonstrates why testing should cover not only permissions and balances, but also invalid transaction parameters.

## 4. Understanding Ownership Management

The Hassan contract inherits from OpenZeppelin's `Ownable` contract.

Ownership management determines which address has permission to execute functions protected by `onlyOwner`.

In our implementation, the `mint()` function is restricted to the owner:

```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

OpenZeppelin provides two important ownership functions:

- `transferOwnership()`
- `renounceOwnership()`

These functions have different effects on the contract's administrative permissions.

## 5. Testing transferOwnership()

The `transferOwnership()` function transfers contract ownership from the current owner to a new address.

Its interface is:

```solidity
transferOwnership(address newOwner)
```

After a successful ownership transfer, the new owner receives the permissions associated with the `onlyOwner` modifier.

### 5.1 Testing Successful Ownership Transfer

```solidity
function test_transferOwnership_success() public {
    token.transferOwnership(alice);

    assertEq(token.owner(), alice);
}
```

The current owner transfers ownership to Alice.

The test verifies that:

```solidity
token.owner()
```

returns Alice's address.

### 5.2 Testing Unauthorized Ownership Transfer

```solidity
function test_transferOwnership_revertIfNotOwner() public {
    vm.prank(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            alice
        )
    );

    token.transferOwnership(bob);
}
```

This test verifies that Alice cannot transfer ownership when she is not the current owner.

The expected error is:

```solidity
OwnableUnauthorizedAccount(address account)
```

This confirms that ownership management is protected by the `onlyOwner` restriction.

### 5.3 Testing Ownership Transfer to the Zero Address

```solidity
function test_transferOwnership_revertToZeroAddress() public {
    vm.expectRevert(
        abi.encodeWithSelector(
            Ownable.OwnableInvalidOwner.selector,
            address(0)
        )
    );

    token.transferOwnership(address(0));
}
```

This test verifies that ownership cannot be transferred to the zero address through `transferOwnership()`.

OpenZeppelin's `Ownable` implementation rejects the invalid new owner with `OwnableInvalidOwner`.

The distinction between this function and `renounceOwnership()` is important: transferring ownership requires a valid new owner, while renouncing ownership intentionally removes the current owner.

### 5.4 Testing Whether the New Owner Can Mint

```solidity
function test_transferOwnership_newOwnerCanMint() public {
    token.transferOwnership(alice);

    vm.prank(alice);
    token.mint(bob, 100e18);

    assertEq(token.balanceOf(bob), 100e18);
}
```

This test verifies that Alice receives the owner's permissions after ownership is transferred to her.

Alice can now call the owner-restricted `mint()` function.

The test confirms that Bob receives 100 HSN.

### 5.5 Testing Whether the Previous Owner Loses Minting Permissions

```solidity
function test_transferOwnership_oldOwnerCannotMint() public {
    token.transferOwnership(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            owner
        )
    );

    token.mint(bob, 100e18);
}
```

After ownership is transferred to Alice, the previous owner must no longer be able to execute owner-only functions.

This test verifies that the old owner cannot mint tokens after losing ownership.

Together, the previous two tests confirm that ownership transfer changes the account authorized to perform administrative operations.

## 6. Testing renounceOwnership()

The `renounceOwnership()` function allows the current owner to permanently give up ownership of the contract.

Its interface is:

```solidity
renounceOwnership()
```

After successful execution, the owner becomes:

```solidity
address(0)
```

This means that no account is recognized as the owner.

### 6.1 Testing Successful Ownership Renunciation

```solidity
function test_renounceOwnership_success() public {
    token.renounceOwnership();

    assertEq(token.owner(), address(0));
}
```

This test verifies that the owner can renounce ownership and that the contract's owner address becomes the zero address.

### 6.2 Testing Unauthorized Renunciation

```solidity
function test_renounceOwnership_revertIfNotOwner() public {
    vm.prank(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            alice
        )
    );

    token.renounceOwnership();
}
```

This test verifies that an account that does not own the contract cannot renounce its ownership.

Only the current owner can execute this operation.

### 6.3 Testing That Nobody Can Mint After Renunciation

```solidity
function test_renounceOwnership_noOneCanMint() public {
    token.renounceOwnership();

    vm.expectRevert(
        abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            owner
        )
    );

    token.mint(alice, 100e18);
}
```

This test verifies the impact of renouncing ownership on the custom `mint()` function.

Since ownership has been removed, the previous owner can no longer execute the `onlyOwner`-protected minting operation.

The mint attempt must revert with `OwnableUnauthorizedAccount`.

### Important Security Consideration

Renouncing ownership is a significant and potentially irreversible administrative decision.

For a contract that relies on owner-only functions, renouncing ownership means those functions can no longer be executed by an owner.

In the Hassan token, this means that no one can use the owner-restricted `mint()` function after ownership has been renounced.

This behavior should be considered carefully before renouncing ownership on a production contract.

## 7. Important Concepts and Foundry Utilities

The tests in this session introduce and reinforce several important Solidity and Foundry concepts.

| Concept | Explanation |
|---|---|
| `approve()` | Grants another address permission to spend a specified token amount. |
| `allowance()` | Returns the remaining spending permission. |
| `transferFrom()` | Transfers tokens using an existing allowance. |
| Infinite allowance | A maximum `uint256` allowance that OpenZeppelin does not decrease after spending. |
| `transferOwnership()` | Transfers contract ownership to a new valid address. |
| `renounceOwnership()` | Removes the current owner by setting ownership to the zero address. |
| `vm.prank()` | Simulates a call from a specified address. |
| `vm.expectRevert()` | Verifies that an operation reverts with the expected error. |
| `vm.expectEmit()` | Verifies expected emitted events. |
| `assertEq()` | Checks whether two values are equal. |
| `assertTrue()` | Checks whether a condition is true. |

## 8. Test Coverage

This session adds tests for the following behaviors:

### Approve and Allowances

- Successful approval.
- Replacing an existing allowance.
- Rejecting the zero address as a spender.
- Emitting the expected `Approval` event.

### TransferFrom

- Successful delegated transfer.
- Rejecting transfers exceeding the available allowance.
- Preserving infinite allowance.
- Rejecting transfers to the zero address.

### Transfer Ownership

- Successful ownership transfer.
- Rejecting ownership transfer by unauthorized accounts.
- Rejecting the zero address as a new owner.
- Allowing the new owner to mint.
- Preventing the previous owner from minting.

### Renounce Ownership

- Successfully renouncing ownership.
- Rejecting renunciation by unauthorized accounts.
- Preventing minting after ownership has been renounced.

## 9. Key Takeaways

By completing this session, the following concepts were explored and tested:

- Understanding the ERC-20 approval mechanism.
- Distinguishing token transfers from spending permissions.
- Tracking allowances between token owners and spenders.
- Understanding how delegated transfers work.
- Testing allowance consumption after `transferFrom()`.
- Understanding the infinite approval pattern.
- Testing custom ERC-20 errors.
- Verifying ownership transfer behavior.
- Testing the effects of changing the contract owner.
- Understanding ownership renunciation.
- Verifying how ownership changes affect `onlyOwner` functions.
- Using Foundry to test both successful and unsuccessful execution paths.

These tests help verify important aspects of token permissions and contract administration, extending the test suite beyond basic transfers and minting.

## 10. References

- [Foundry Documentation](https://getfoundry.sh/)
- [Foundry Testing Guide](https://getfoundry.sh/forge/tests)
- [Foundry Cheatcodes](https://getfoundry.sh/reference/cheatcodes/overview/)
- [OpenZeppelin ERC-20 Documentation](https://docs.openzeppelin.com/contracts/5.x/erc20)
- [OpenZeppelin ERC-20 API](https://docs.openzeppelin.com/contracts/5.x/api/token/erc20)
- [OpenZeppelin Ownable Documentation](https://docs.openzeppelin.com/contracts/5.x/access-control)
- [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)

---

**Day 05 completed:** Extended the Hassan ERC-20 Foundry test suite to cover approvals, allowances, delegated transfers, ownership transfer, and ownership renunciation.