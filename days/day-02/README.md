# ERC-20 Token Implementation

## Overview

This day focuses on implementing a custom ERC-20 token using Solidity, Foundry, and OpenZeppelin Contracts.

Instead of implementing the ERC-20 standard from scratch, this project uses OpenZeppelin's reusable ERC-20 implementation and extends it with an ownership-based minting mechanism.

The token created in this project is:

| Property | Value |
|---|---|
| Token Name | Hassan |
| Token Symbol | HSN |
| Standard | ERC-20 |
| Network | Ethereum-compatible |
| Implementation | OpenZeppelin Contracts |
| Solidity Version | `^0.8.31` |

## 1. Project Structure

The implementation is organized as follows:

```text
erc20-token-project/
├── days/
│   ├── day-01/
│   └── day-02/
│       └── README.md
├── lib/
│   └── openzeppelin-contracts/
├── src/
│   ├── ERC20/
│   └── Hassan.sol
├── test/
├── script/
├── foundry.toml
└── README.md
```

- `src/Hassan.sol`: The custom ERC-20 token contract.
- `lib/openzeppelin-contracts/`: OpenZeppelin Contracts dependency.
- `foundry.toml`: Foundry configuration, including dependency remappings.
- `days/day-02/README.md`: Documentation for the concepts and implementation covered on this day.

## 2. What Is an ERC-20 Implementation?

ERC-20 defines a common interface for fungible tokens on Ethereum.

An ERC-20 implementation provides the actual behavior behind that interface, including:

- Tracking token balances.
- Transferring tokens between addresses.
- Approving other addresses to spend tokens.
- Tracking spending allowances.
- Emitting events when token operations occur.

A contract can implement the ERC-20 interface itself, or reuse an existing implementation such as OpenZeppelin's ERC20 contract.

## 3. What Is OpenZeppelin?

OpenZeppelin Contracts is a widely used library of reusable smart contract implementations.

It provides implementations of common Ethereum standards and security-related components, including:

- ERC-20 tokens.
- ERC-721 NFTs.
- Access control.
- Ownership management.
- Other reusable smart contract components.

Using OpenZeppelin helps avoid rewriting standard functionality and reduces the risk of introducing implementation mistakes.

In this project, OpenZeppelin provides the ERC-20 functionality, while the custom contract adds the project's specific behavior.

## 4. Understanding the Hassan Token Contract

The contract is implemented in `src/Hassan.sol`.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hassan is ERC20, Ownable {

    constructor() ERC20("Hassan", "HSN") Ownable(msg.sender) {
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

}
```

### 4.1 Solidity Version

```solidity
pragma solidity ^0.8.31;
```

Specifies the Solidity compiler versions accepted by this source file, starting from version `0.8.31` and allowing compatible later versions below `0.9.0`.

### 4.2 Importing OpenZeppelin Contracts

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```

Two OpenZeppelin contracts are imported:

**ERC20**

Provides the standard ERC-20 token functionality, including balance tracking, transfers, approvals, allowances, and the related events.

**Ownable**

Provides ownership management. It tracks the owner address and provides the `onlyOwner` access restriction.

### 4.3 Inheritance

```solidity
contract Hassan is ERC20, Ownable
```

The `Hassan` contract inherits from both `ERC20` and `Ownable`.

This means it reuses the functionality provided by these contracts and can extend it with custom functions.

### 4.4 Constructor

```solidity
constructor() ERC20("Hassan", "HSN") Ownable(msg.sender) {
}
```

The constructor runs once when the contract is deployed.

It initializes two inherited contracts:

- `ERC20("Hassan", "HSN")`: Sets the token name to `Hassan` and its symbol to `HSN`.
- `Ownable(msg.sender)`: Sets the deployer as the initial owner.

The contract does not mint an initial supply in its constructor. Its initial total supply is therefore zero.

## 5. Understanding the ERC-20 Functions

The OpenZeppelin ERC20 implementation provides the core functions needed to manage token balances and transfers.

### 5.1 Token Information

| Function | Purpose |
|---|---|
| `name()` | Returns the token name. |
| `symbol()` | Returns the token symbol. |
| `decimals()` | Returns the number of decimal places used for display. |
| `totalSupply()` | Returns the current total token supply. |
| `balanceOf(address)` | Returns the token balance of an address. |

OpenZeppelin's ERC20 implementation uses 18 decimals by default.

**Important:** The `decimals` value affects how token amounts are displayed. It does not change the integer arithmetic used internally by the contract.

For example, one whole token is represented internally as:

```solidity
1 * 10 ** 18
```

### 5.2 Transfer Tokens

```solidity
transfer(address to, uint256 value)
```

Transfers tokens from the caller's address to another address.

The function:

1. Checks that the sender has enough tokens.
2. Updates the sender's balance.
3. Updates the recipient's balance.
4. Emits a `Transfer` event.

The transfer is performed by the token holder directly.

### 5.3 Approve

```solidity
approve(address spender, uint256 value)
```

Allows another address, known as the spender, to spend a specified amount of the caller's tokens.

The approval does not transfer any tokens. It only establishes a spending allowance.

An `Approval` event is emitted when the allowance is updated.

### 5.4 Allowance

```solidity
allowance(address owner, address spender)
```

Returns the amount of tokens that a spender is currently allowed to spend on behalf of an owner.

For example:

- Alice owns 100 HSN.
- Alice approves Bob to spend 30 HSN.
- Bob's allowance is now 30 HSN.

The allowance represents permission to spend, not an actual transfer.

### 5.5 Transfer From

```solidity
transferFrom(address from, address to, uint256 value)
```

Transfers tokens from one address to another using an existing allowance.

For example:

1. Alice owns 100 HSN.
2. Alice approves Bob to spend 30 HSN.
3. Bob calls `transferFrom` to transfer 20 HSN from Alice to Charlie.
4. Charlie receives 20 HSN.
5. Bob's remaining allowance becomes 10 HSN.

This mechanism is commonly used when a contract or another account needs permission to spend tokens on behalf of a user.

## 6. Owner-Only Minting

The custom contract introduces a `mint` function:

```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

### What Is Minting?

Minting means creating new tokens and adding them to the total token supply.

Unlike transferring tokens, minting does not move existing tokens from one address to another. It creates new tokens.

### What Is the Owner?

The owner is the address that has administrative ownership of the contract through OpenZeppelin's `Ownable` implementation.

In this project, the deployer becomes the initial owner through:

```solidity
Ownable(msg.sender)
```

### What Does `onlyOwner` Do?

`onlyOwner` is an access restriction provided by OpenZeppelin's `Ownable` contract.

It ensures that only the current owner can execute the protected function.

If another address attempts to call `mint`, the transaction reverts.

### What Does `_mint` Do?

`_mint` is an internal function provided by OpenZeppelin's ERC20 implementation.

It creates the requested amount of tokens, assigns them to the specified recipient, updates the total supply, and emits a `Transfer` event from the zero address.

The custom `mint` function exposes this operation externally while restricting access to the owner.

## 7. Understanding the Main Token Operations

The following table summarizes the difference between the main operations:

| Operation | What It Does | Who Initiates It? |
|---|---|---|
| `mint` | Creates new tokens. | Contract owner only |
| `transfer` | Transfers the caller's tokens. | Token holder |
| `approve` | Grants another address spending permission. | Token holder |
| `allowance` | Reads the remaining spending permission. | Any caller |
| `transferFrom` | Transfers tokens using an allowance. | Approved spender |

## 8. Foundry Configuration

The project uses a Foundry remapping to resolve OpenZeppelin imports.

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]

remappings = [
    '@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts'
]
```

The remapping tells Foundry where to find imports that start with:

```solidity
@openzeppelin/contracts/
```

For example:

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```

is resolved to the corresponding file inside:

```text
lib/openzeppelin-contracts/contracts/
```

## 9. Key Takeaways

By completing this implementation, the following concepts were explored:

- Reusing an existing ERC-20 implementation through OpenZeppelin.
- Inheriting from multiple smart contracts.
- Initializing inherited contracts through constructor arguments.
- Defining token metadata such as name and symbol.
- Understanding token balances and total supply.
- Transferring tokens between addresses.
- Creating spending permissions through approvals.
- Reading and managing allowances.
- Executing delegated transfers through `transferFrom`.
- Creating new tokens through minting.
- Restricting sensitive operations using `onlyOwner`.

## 10. References

- [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [OpenZeppelin ERC-20 Documentation](https://docs.openzeppelin.com/contracts/5.x/erc20)
- [OpenZeppelin ERC20 API](https://docs.openzeppelin.com/contracts/5.x/api/token/erc20)
- [OpenZeppelin Ownable API](https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable)
- [Foundry Documentation](https://getfoundry.sh/)

---

**Day 02 completed:** Implemented a custom ERC-20 token using OpenZeppelin, added owner-restricted minting, and explored the standard token operations: transfers, approvals, allowances, and delegated transfers.