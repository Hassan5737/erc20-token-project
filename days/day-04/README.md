# ERC-20 Testing with Foundry

## Overview

This day focuses on building an automated testing suite for the `Hassan (HSN)` ERC-20 token using Foundry.

After implementing the token with OpenZeppelin, the next step is to verify that its behavior matches the expected ERC-20 functionality and that its access restrictions work correctly.

The testing suite covers three main areas:

1. Constructor initialization.
2. Owner-restricted token minting.
3. ERC-20 token transfers.

It also tests failure scenarios, validates emitted events, and checks that the contract rejects invalid operations.

### Project Details

| Property | Value |
|---|---|
| Project | Hassan ERC-20 Token |
| Token Name | Hassan |
| Token Symbol | HSN |
| Standard | ERC-20 |
| Language | Solidity |
| Testing Framework | Foundry |
| Contract Library | OpenZeppelin Contracts |
| Solidity Version | `^0.8.31` |
| Test File | `test/Hassan.t.sol` |
| Initial Test Results | 13 Passed, 0 Failed |

## 1. Why Smart Contract Testing Matters

Smart contracts operate on blockchain networks, where deployed code is difficult to modify and transactions can have financial consequences.

A function compiling successfully does not necessarily mean that it behaves correctly.

Testing helps developers verify that:

- Functions produce the expected results.
- Contract state changes are correct.
- Access restrictions cannot be bypassed.
- Invalid operations are rejected.
- Events are emitted correctly.
- Important edge cases are handled safely.

For an ERC-20 token, testing is especially important because errors in balance management, transfers, or permissions can directly affect token ownership and supply.

## 2. What Is Foundry Testing?

Foundry is a Solidity development toolkit that provides tools for compiling, testing, debugging, and deploying smart contracts.

Its testing framework allows developers to write tests directly in Solidity rather than relying on a separate testing language.

Foundry provides several useful components:

| Component | Purpose |
|---|---|
| Forge | Builds, tests, and deploys smart contracts. |
| `forge-std` | Provides testing utilities and helper functions. |
| `Test.sol` | Base contract for writing Solidity tests. |
| Assertions | Verify expected values and conditions. |
| Cheatcodes | Control and manipulate the testing environment. |

### Running Tests

The following command executes the project's test suite:

```bash
forge test
```

Foundry compiles the required files and executes the discovered test functions.

Each test runs in an isolated testing environment, allowing tests to start from a predictable state.

## 3. Preparing the Testing Environment

The test file is located at:

```text
test/
└── Hassan.t.sol
```

The initial testing setup is:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

import "forge-std/Test.sol";
import "../src/Hassan.sol";

contract HassanTest is Test {
    Hassan public token;

    address public owner;
    address public alice;
    address public bob;

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        token = new Hassan("Hassan", "HSN");
    }
}
```

### 3.1 Importing the Required Contracts

```solidity
import "forge-std/Test.sol";
import "../src/Hassan.sol";
```

Two dependencies are imported:

**Test.sol**

Provides the base testing contract and utilities such as:

- Assertions.
- Address creation helpers.
- Cheatcode access through `vm`.
- Other testing-related functionality.

**Hassan.sol**

Imports the ERC-20 token implementation being tested.

### 3.2 Inheriting from Test

```solidity
contract HassanTest is Test
```

The test contract inherits from Foundry's `Test` contract.

This gives the test suite access to assertion functions and the testing utilities required to simulate different scenarios.

### 3.3 Defining Test Accounts

```solidity
Hassan public token;

address public owner;
address public alice;
address public bob;
```

These variables represent the contract under test and three different accounts.

- `owner`: The initial owner of the token contract.
- `alice`: An account used to receive and transfer tokens.
- `bob`: Another account used to receive tokens.

### 3.4 Understanding setUp()

```solidity
function setUp() public {
    owner = address(this);
    alice = makeAddr("alice");
    bob = makeAddr("bob");

    token = new Hassan("Hassan", "HSN");
}
```

`setUp()` is a special function recognized by Foundry.

Foundry executes it before each individual test function.

Its purpose is to prepare a fresh testing environment.

The function performs four operations:

1. Assigns the test contract's address to `owner`.
2. Creates a test address named Alice.
3. Creates another test address named Bob.
4. Deploys a new Hassan token contract.

### Why Is the Test Contract the Owner?

The token contract uses:

```solidity
Ownable(msg.sender)
```

The `msg.sender` during deployment is the address that deploys the token.

Since `setUp()` deploys the token directly from the `HassanTest` contract, the test contract itself becomes the token owner.

Therefore:

```solidity
owner = address(this);
```

correctly represents the initial owner.

This detail is important when testing access-controlled functions.

## 4. Testing Constructor Initialization

The constructor is responsible for initializing the token's configuration and ownership.

The Hassan contract accepts two parameters:

```solidity
constructor(string memory name, string memory symbol)
    ERC20(name, symbol)
    Ownable(msg.sender)
{
}
```

The testing suite verifies that these values are initialized correctly.

### 4.1 Testing the Token Name

```solidity
function test_constructor_setsName() public view {
    assertEq(token.name(), "Hassan");
}
```

This test verifies that the token name is initialized as `Hassan`.

`assertEq()` compares two values and causes the test to fail if they are different.

### 4.2 Testing the Token Symbol

```solidity
function test_constructor_setsSymbol() public view {
    assertEq(token.symbol(), "HSN");
}
```

This verifies that the token symbol is correctly initialized as `HSN`.

### 4.3 Testing the Contract Owner

```solidity
function test_constructor_setsOwner() public view {
    assertEq(token.owner(), owner);
}
```

This verifies that the address stored as the token owner matches the test contract's address.

It confirms that the `Ownable` initialization works as expected.

### 4.4 Testing the Initial Token Supply

```solidity
function test_constructor_zeroInitialSupply() public view {
    assertEq(token.totalSupply(), 0);
}
```

The constructor does not mint any tokens.

Therefore, the initial total supply must be zero.

### 4.5 Testing Token Decimals

```solidity
function test_decimals() public view {
    assertEq(token.decimals(), 18);
}
```

OpenZeppelin's ERC-20 implementation uses 18 decimal places by default.

This test verifies that the token returns the expected decimal precision.

**Important:** Decimals affect how token amounts are represented to users. ERC-20 token balances are still stored and calculated using integer values.

## 5. Testing Token Minting

Minting creates new tokens and increases the total token supply.

The Hassan contract implements minting through:

```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

The `_mint()` function is provided by OpenZeppelin's ERC-20 implementation.

The custom `mint()` function exposes that functionality while restricting access to the contract owner.

The tests cover successful minting, multiple recipients, unauthorized access, and invalid recipient addresses.

### 5.1 Testing Successful Minting by the Owner

```solidity
function test_mint_asOwner() public {
    token.mint(alice, 1000 ether);

    assertEq(token.balanceOf(alice), 1000 ether);
    assertEq(token.totalSupply(), 1000 ether);
}
```

This test verifies that the owner can successfully mint tokens.

It checks two important results:

- Alice receives 1,000 tokens.
- The total token supply increases by 1,000 tokens.

### Understanding ether in Solidity Tests

The expression:

```solidity
1000 ether
```

is a Solidity unit expression equivalent to:

```solidity
1000 * 10**18
```

It represents 1,000 whole tokens when the ERC-20 contract uses 18 decimals.

It does not mean that the token contract is transferring or spending ETH.

### 5.2 Testing Minting to Multiple Addresses

```solidity
function test_mint_toMultipleAddresses() public {
    token.mint(alice, 500 ether);
    token.mint(bob, 300 ether);

    assertEq(token.balanceOf(alice), 500 ether);
    assertEq(token.balanceOf(bob), 300 ether);
    assertEq(token.totalSupply(), 800 ether);
}
```

This test verifies that tokens can be minted to different addresses.

Expected results:

| Account | Minted Amount |
|---|---:|
| Alice | 500 HSN |
| Bob | 300 HSN |
| Total Supply | 800 HSN |

It also verifies that the total supply correctly reflects the sum of all minted tokens.

### 5.3 Testing Unauthorized Minting

```solidity
function test_mint_revertIfOwner() public {
    vm.prank(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            Ownable.OwnableUnauthorizedAccount.selector,
            alice
        )
    );

    token.mint(alice, 1000 ether);
}
```

This test verifies that an address other than the owner cannot mint tokens.

Two Foundry utilities are used.

**vm.prank(address)**

Changes `msg.sender` for the next external call.

In this test, Alice becomes the caller.

**vm.expectRevert(bytes)**

Tells Foundry to expect the next relevant call to revert with the specified error data.

OpenZeppelin's `Ownable` contract uses the custom error:

```solidity
OwnableUnauthorizedAccount(address account)
```

The test verifies that the unauthorized caller is correctly identified as Alice.

This confirms that the owner-only restriction is enforced.

### 5.4 Testing Minting to the Zero Address

```solidity
function test_mint_revertIfMintToZeroAddress() public {
    vm.expectRevert(
        abi.encodeWithSelector(
            IERC20Errors.ERC20InvalidReceiver.selector,
            address(0)
        )
    );

    token.mint(address(0), 1000 ether);
}
```

This test verifies that the contract rejects attempts to mint tokens to the zero address.

The zero address is:

```solidity
address(0)
```

OpenZeppelin's ERC-20 implementation rejects invalid token recipients using the custom error:

```solidity
ERC20InvalidReceiver(address receiver)
```

The `IERC20Errors` interface provides the error selector used to construct the expected revert data.

**Why is this important?**

Minting tokens to the zero address would make those tokens inaccessible through normal account ownership. Rejecting this operation helps preserve correct token accounting.

## 6. Testing the Transfer Function

The ERC-20 `transfer()` function allows a token holder to send tokens directly to another address.

Its interface is:

```solidity
transfer(address to, uint256 value)
```

The test suite covers successful transfers, insufficient balances, invalid recipients, and emitted events.

### 6.1 Testing a Successful Transfer

```solidity
function test_transfer_success() public {
    token.mint(alice, 1000e18);

    vm.prank(alice);

    bool ok = token.transfer(bob, 400e18);

    assertTrue(ok);
    assertEq(token.balanceOf(alice), 600e18);
    assertEq(token.balanceOf(bob), 400e18);
}
```

This test follows four steps:

1. Mint 1,000 HSN to Alice.
2. Simulate Alice as the caller.
3. Transfer 400 HSN from Alice to Bob.
4. Verify the return value and both balances.

Expected results:

| Account | Balance Before | Balance After |
|---|---:|---:|
| Alice | 1,000 HSN | 600 HSN |
| Bob | 0 HSN | 400 HSN |

The test uses:

```solidity
assertTrue(ok);
```

to verify that the transfer function returns `true`.

It then checks that the sender's balance decreases and the recipient's balance increases by the transferred amount.

### 6.2 Testing Insufficient Balance

```solidity
function test_transfer_revertInsufficientBalance() public {
    token.mint(alice, 100e18);

    vm.prank(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            IERC20Errors.ERC20InsufficientBalance.selector,
            alice,
            100e18,
            200e18
        )
    );

    token.transfer(bob, 200e18);
}
```

This test verifies that an account cannot transfer more tokens than it owns.

Alice has 100 HSN but attempts to transfer 200 HSN.

The expected error is:

```solidity
ERC20InsufficientBalance(
    address sender,
    uint256 balance,
    uint256 needed
)
```

The test checks the exact error data:

- Sender: Alice.
- Available balance: 100 HSN.
- Required amount: 200 HSN.

This ensures that the contract correctly rejects transfers that exceed the sender's available balance.

### 6.3 Testing Transfer to the Zero Address

```solidity
function test_transfer_revertToZeroAddress() public {
    token.mint(alice, 100e18);

    vm.prank(alice);

    vm.expectRevert(
        abi.encodeWithSelector(
            IERC20Errors.ERC20InvalidReceiver.selector,
            address(0)
        )
    );

    token.transfer(address(0), 50e18);
}
```

This test verifies that tokens cannot be transferred to the zero address.

Even though Alice has enough tokens, the recipient address is invalid.

The contract must therefore reject the transaction with `ERC20InvalidReceiver`.

### 6.4 Testing the Transfer Event

```solidity
function test_transfer_emitsEvent() public {
    token.mint(alice, 100e18);

    vm.prank(alice);

    vm.expectEmit(true, true, false, true);

    emit IERC20.Transfer(alice, bob, 50e18);

    token.transfer(bob, 50e18);
}
```

ERC-20 uses the `Transfer` event to record token transfers.

Its event definition is:

```solidity
event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
);
```

The test verifies that the transfer emits the expected event with:

- `from`: Alice.
- `to`: Bob.
- `value`: 50 HSN.

Foundry's `vm.expectEmit()` allows a test to validate emitted events.

Its arguments control which parts of the event should be checked:

```solidity
vm.expectEmit(
    true,  // Check the first indexed topic
    true,  // Check the second indexed topic
    false, // Do not check the third indexed topic
    true   // Check the event data
);
```

The expected event is emitted in the test before executing the actual contract call. Foundry then checks the event emitted by the contract against the expected values.

**Why test events?**

Events allow external applications, wallets, and blockchain explorers to observe important contract activity.

Testing them helps ensure that integrations can rely on the expected event data.

## 7. Important Foundry Testing Utilities

The following utilities were used throughout the test suite.

| Utility | Purpose |
|---|---|
| `setUp()` | Prepares a fresh environment before every test. |
| `makeAddr()` | Creates a deterministic test address. |
| `address(this)` | Returns the current test contract's address. |
| `assertEq()` | Checks whether two values are equal. |
| `assertTrue()` | Checks whether a condition is true. |
| `vm.prank()` | Changes the caller for the next external call. |
| `vm.expectRevert()` | Expects the next relevant call to revert. |
| `vm.expectEmit()` | Verifies an event emitted by the contract. |

Understanding these utilities makes it easier to write tests for more complex smart contracts.

## 8. Test Execution and Results

The test suite was executed using:

```bash
forge test
```

The reported result was:

```text
Ran 13 tests for test/Hassan.t.sol:HassanTest

[PASS] test_constructor_setsName()
[PASS] test_constructor_setsOwner()
[PASS] test_constructor_setsSymbol()
[PASS] test_constructor_zeroInitialSupply()
[PASS] test_decimals()

[PASS] test_mint_asOwner()
[PASS] test_mint_revertIfMintToZeroAddress()
[PASS] test_mint_revertIfOwner()
[PASS] test_mint_toMultipleAddresses()

[PASS] test_transfer_emitsEvent()
[PASS] test_transfer_revertInsufficientBalance()
[PASS] test_transfer_revertToZeroAddress()
[PASS] test_transfer_success()

Suite result: ok. 13 passed; 0 failed; 0 skipped.
```

### Test Coverage Summary

| Category | Tests |
|---|---:|
| Constructor and token configuration | 5 |
| Minting | 4 |
| Transfers | 4 |
| **Total** | **13** |

All 13 reported tests passed successfully.

This confirms that the tested constructor behavior, minting operations, transfer operations, access restrictions, invalid-address handling, and transfer event behavior matched their expected results.

## 9. Key Takeaways

By completing this testing session, the following concepts were explored and applied:

- Writing Solidity tests using Foundry.
- Organizing a reusable test environment with `setUp()`.
- Deploying a contract before each test.
- Understanding `msg.sender` during contract deployment.
- Testing constructor initialization.
- Verifying token metadata and initial supply.
- Testing successful token minting.
- Testing minting to multiple addresses.
- Verifying owner-only access restrictions.
- Testing invalid token recipients.
- Testing successful ERC-20 transfers.
- Testing insufficient-balance reverts.
- Validating emitted ERC-20 events.
- Using Foundry assertions and cheatcodes.
- Interpreting test results and gas reports.

## 10. References

- [Foundry Documentation](https://getfoundry.sh/)
- [Foundry Testing Guide](https://getfoundry.sh/forge/tests)
- [Foundry Cheatcodes](https://getfoundry.sh/reference/cheatcodes/overview/)
- [OpenZeppelin ERC-20 Documentation](https://docs.openzeppelin.com/contracts/5.x/erc20)
- [OpenZeppelin ERC-20 API](https://docs.openzeppelin.com/contracts/5.x/api/token/erc20)
- [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)

---

**Day 04 completed:** Established a Foundry testing environment for the Hassan ERC-20 token and successfully executed 13 tests covering constructor initialization, owner-restricted minting, token transfers, failure conditions, and event emission.