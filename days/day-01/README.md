# Blockchain Tokens, ERC Standards, ERC-20, and OpenZeppelin

## Introduction

Before implementing an ERC-20 token, it is important to understand the concepts and standards behind token development on Ethereum.

This guide introduces four fundamental topics:

1. What is a Token?
2. What is an ERC?
3. What is ERC-20?
4. What is OpenZeppelin?

The goal is to establish the technical foundation required to understand how tokens are represented, how smart contracts interact with them, why standards exist, and how developers can build token contracts that work with the broader Ethereum ecosystem.

No previous experience with token development is required.

---

# 1. What Is a Token?

## 1.1 Understanding Tokens

A **token** is a digital representation of an asset, right, utility, or value within a blockchain ecosystem.

Tokens can represent many different things, including:

- Digital currencies.
- Ownership or shares in an asset.
- Voting rights in a decentralized organization.
- In-game items and rewards.
- Loyalty points.
- Access to a service or platform.
- Digital collectibles.

For example, a company could issue tokens representing shares in a project, a game could issue tokens as rewards, and a decentralized organization could use tokens to represent voting power.

The important idea is that a token does not have to represent money. It can represent almost anything that can be expressed and managed digitally.

## 1.2 Native Coins vs. Tokens

Before going further, it is important to distinguish between a blockchain's native cryptocurrency and tokens deployed on top of that blockchain.

### Native Coins

A native coin is the cryptocurrency built into the blockchain protocol itself.

For example:

- ETH is the native cryptocurrency of Ethereum.
- BTC is the native cryptocurrency of Bitcoin.

On Ethereum, ETH is used to pay transaction fees (gas) and participate in the network's economic system.

ETH is not an ERC-20 token. Its behavior is defined by the Ethereum protocol itself.

### Tokens

Tokens are assets created and managed through smart contracts deployed on an existing blockchain.

For example, an ERC-20 token on Ethereum is managed by a smart contract rather than being a native asset of the Ethereum protocol.

| Native Coin | Token |
|---|---|
| Built into the blockchain protocol | Created through a smart contract |
| Its behavior is defined by the protocol | Its behavior is defined by its contract |
| Example: ETH | Example: DAI or USDC on Ethereum |

This distinction is important because developing a token usually means developing a smart contract that manages token balances and operations.

## 1.3 Fungible vs. Non-Fungible Tokens

Tokens can represent different types of assets. One of the most important distinctions is whether the units are interchangeable.

### Fungible Tokens

A fungible asset is interchangeable with another unit of the same type and value.

For example:

- One dollar is interchangeable with another dollar.
- One ETH is interchangeable with another ETH.
- One unit of a particular fungible token is equivalent to another unit of that same token.

If Alice owns 10 units of a fungible token and Bob owns 10 units of the same token, the individual units are not treated as unique assets.

The important property is the quantity, not the identity of each individual unit.

Common use cases include:

- Cryptocurrencies.
- Stablecoins.
- Governance tokens.
- Staking tokens.
- Utility tokens.

### Non-Fungible Tokens (NFTs)

A non-fungible asset is unique and cannot necessarily be exchanged one-to-one with another asset of the same collection.

For example, two houses may have different locations, sizes, and ownership records. Their identities and properties matter.

NFTs can represent:

- Digital artwork.
- Collectibles.
- Game items.
- Tickets.
- Unique digital ownership records.

### Comparison

| Fungible Tokens | Non-Fungible Tokens |
|---|---|
| Interchangeable units | Unique individual assets |
| Quantity is the primary concern | Identity and individual properties matter |
| Commonly used for currencies and voting | Commonly used for collectibles and ownership |
| ERC-20 is a common standard | ERC-721 is a common standard |

Ethereum also supports ERC-1155, a multi-token standard that can represent both fungible and non-fungible token types.

## 1.4 What Is a Token Contract?

A token contract is a smart contract responsible for managing token-related data and operations.

On Ethereum, a token is not necessarily a separate digital object stored inside a wallet. For a typical ERC-20 implementation, the smart contract maintains information such as:

- The total token supply.
- The balance associated with each address.
- The amount an approved spender is allowed to transfer.
- The rules governing token transfers.

For example, a simplified token contract may maintain a relationship like this:

```solidity
mapping(address => uint256) balances;
```

This mapping associates each Ethereum address with a token balance.

If an address has a balance of 100, the contract records that the address owns 100 units of that token.

When tokens are transferred, the contract updates the relevant balances according to its rules.

**Important:** Sending ERC-20 tokens generally means calling a function on the token's smart contract. The contract updates its internal accounting and emits the appropriate event.

A wallet interface reads this information and displays it to the user.

---

# 2. What Is an ERC?

## 2.1 Understanding Ethereum Standards

Ethereum is a platform where developers can deploy smart contracts and build decentralized applications.

However, smart contracts are not automatically compatible with one another.

Imagine that every developer creates tokens using completely different function names, parameters, and behaviors.

One token might use `sendTokens()`, another might use `moveBalance()`, and another might use an entirely different mechanism.

Wallets, exchanges, and decentralized applications would need custom integration logic for every token they support.

This would make the Ethereum ecosystem difficult to integrate and maintain.

To address this problem, the Ethereum community developed standards that define common interfaces and expected behaviors.

These standards make it easier for different applications and smart contracts to communicate.

## 2.2 What Is an EIP?

**EIP** stands for **Ethereum Improvement Proposal**.

An EIP is a document that proposes a change, improvement, or specification related to the Ethereum ecosystem.

EIPs provide a structured process for discussing, documenting, and reviewing proposed improvements.

They can cover different areas, such as:

- Core protocol changes.
- Ethereum Virtual Machine (EVM) specifications.
- Application-level standards.
- Developer tools and conventions.

An EIP is not automatically an accepted or implemented change simply because someone publishes it. Proposals go through discussion and review, and their status depends on the relevant process.

## 2.3 What Is an ERC?

**ERC** stands for **Ethereum Request for Comments**.

ERCs are application-level standards and conventions within the Ethereum ecosystem. They describe how smart contracts should expose interfaces or behave so that other applications can interact with them consistently.

In practice, ERC specifications are documented through the Ethereum Improvement Proposals process.

For example:

- ERC-20 defines a common interface for fungible tokens.
- ERC-721 defines a common interface for non-fungible tokens.
- ERC-1155 defines a multi-token standard.

### Why Do ERC Standards Matter?

ERC standards provide interoperability.

Interoperability means that different applications can interact with compatible contracts without needing a completely different integration for every implementation.

For example, if a token contract follows the ERC-20 interface, an ERC-20-compatible wallet can use the standard functions to:

- Read the token balance.
- Read the token symbol.
- Transfer tokens.
- Interact with token approvals.

The wallet does not need to know the internal implementation details of every token contract.

It only needs to understand the expected interface and behavior.

### EIP vs. ERC

| Term | Meaning | Purpose |
|---|---|---|
| EIP | Ethereum Improvement Proposal | The proposal and specification process for Ethereum improvements |
| ERC | Ethereum Request for Comments | Application-level standards and conventions |

An important distinction is that ERC is not a completely separate process from EIP. ERC standards are documented within the broader EIP framework.

---

# 3. What Is ERC-20?

## 3.1 Introduction to ERC-20

**ERC-20** is a standard interface for fungible tokens on Ethereum.

It defines a common set of functions and events that token contracts should implement so that wallets, exchanges, decentralized applications, and other smart contracts can interact with them consistently.

ERC-20 was proposed by Fabian Vogelsteller and Vitalik Buterin in November 2015 through [EIP-20](https://eips.ethereum.org/EIPS/eip-20).

The standard makes it possible for different fungible tokens to expose a familiar interface, even when their internal implementations differ.

For example, a wallet can interact with two different ERC-20 tokens using the same standard operations:

- Read balances.
- Transfer tokens.
- Approve another address to spend tokens.
- Check spending allowances.

## 3.2 What Does ERC-20 Standardize?

ERC-20 specifies a common API for token contracts.

It defines six required functions:

1. `totalSupply()`
2. `balanceOf(address)`
3. `transfer(address, uint256)`
4. `approve(address, uint256)`
5. `allowance(address, address)`
6. `transferFrom(address, address, uint256)`

It also defines two required events:

1. `Transfer`
2. `Approval`

The standard additionally describes three optional metadata functions:

- `name()`
- `symbol()`
- `decimals()`

These metadata functions improve usability, but they are not mandatory requirements for ERC-20 compliance.

## 3.3 Understanding the ERC-20 Functions

### 1. totalSupply()

```solidity
function totalSupply() external view returns (uint256);
```

Returns the total number of tokens currently in existence.

For example, if a token contract has created 1,000,000 tokens and none have been burned, its total supply is 1,000,000 tokens, expressed in the contract's smallest units.

This function allows applications to retrieve the token's current supply.

### 2. balanceOf()

```solidity
function balanceOf(address account) external view returns (uint256);
```

Returns the token balance of a specific address.

For example:

```solidity
balanceOf(alice);
```

If Alice owns 500 tokens, the function returns the corresponding token amount in the smallest units.

This function is commonly used by wallets and decentralized applications to display user balances.

### 3. transfer()

```solidity
function transfer(address to, uint256 value) external returns (bool);
```

Transfers tokens from the caller's address to another address.

For example:

- Alice owns 100 tokens.
- Alice transfers 30 tokens to Bob.
- Alice's balance becomes 70.
- Bob's balance increases by 30.

The transfer operation is executed by the token contract, which updates the balances.

The function returns a boolean indicating whether the operation succeeded.

### 4. approve()

```solidity
function approve(address spender, uint256 value) external returns (bool);
```

Allows another address to spend a specified amount of tokens on behalf of the token owner.

This is especially useful when interacting with other smart contracts.

For example:

- Alice owns 100 tokens.
- Alice wants a decentralized application to spend 40 tokens on her behalf.
- Alice calls `approve()` and specifies the application's address and an allowance of 40.
- The application can now use `transferFrom()` to transfer up to the approved amount, subject to the current allowance and the owner's balance.

**Important:** Calling `approve()` does not transfer tokens. It creates or updates a spending permission.

### 5. allowance()

```solidity
function allowance(address owner, address spender) external view returns (uint256);
```

Returns the remaining amount that a spender is allowed to transfer from an owner's account.

For example:

- Alice approves Bob to spend 50 tokens.
- Bob transfers 20 tokens using `transferFrom()`.
- The remaining allowance becomes 30 tokens.

This function allows wallets and smart contracts to check the available spending permission.

### 6. transferFrom()

```solidity
function transferFrom(
    address from,
    address to,
    uint256 value
) external returns (bool);
```

Transfers tokens from one address to another using an allowance previously granted by the token owner.

For example:

1. Alice owns 100 tokens.
2. Alice approves a smart contract to spend 40 tokens.
3. The smart contract calls `transferFrom()` to transfer 25 tokens from Alice to Bob.
4. The contract updates the balances.
5. The remaining allowance becomes 15 tokens.

The spender cannot use this permission to transfer more than the available allowance or more than the owner's available balance.

## 3.4 Understanding the Approval Mechanism

The approval mechanism is one of the most important parts of ERC-20 because it enables smart contracts to use tokens on behalf of users.

Consider a decentralized exchange.

A user wants to swap tokens through the exchange's smart contract. The exchange needs permission to transfer the user's tokens.

The typical flow is:

```text
Token Owner
    |
    | 1. approve(spender, amount)
    v
ERC-20 Token Contract
    |
    | 2. Records the allowance
    v
Spender / DApp
    |
    | 3. transferFrom(owner, recipient, amount)
    v
ERC-20 Token Contract
    |
    | 4. Updates balances and allowance
    v
Recipient
```

The important distinction:

- `approve()` grants spending permission.
- `allowance()` checks the remaining permission.
- `transferFrom()` uses that permission to transfer tokens.

### A Practical Example

Assume Alice owns 100 tokens.

| Operation | Alice's Balance | Bob's Balance | Remaining Allowance |
|---|---:|---:|---:|
| Initial state | 100 | 0 | 0 |
| Alice approves Bob for 40 | 100 | 0 | 40 |
| Bob transfers 25 to himself | 75 | 25 | 15 |

This example illustrates how approvals and delegated transfers work together.

**Security note:** Changing an existing non-zero allowance directly can introduce transaction-ordering risks. The EIP-20 specification recommends that user interfaces set an allowance to zero before setting a new non-zero value when changing allowances. Applications should also carefully consider approval amounts and spender addresses.

## 3.5 Understanding ERC-20 Events

Events allow smart contracts to emit information into transaction logs.

Other applications can monitor these logs to track important contract activity.

ERC-20 defines two required events.

### Transfer

```solidity
event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
);
```

Emitted when tokens are transferred from one address to another.

It is also used by the standard to represent token creation and destruction through transfers involving the zero address.

For example, a wallet or blockchain explorer can monitor `Transfer` events to display token activity.

### Approval

```solidity
event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
);
```

Emitted when an owner approves a spender to use a specified amount of tokens.

This event allows applications to track changes in spending permissions.

## 3.6 Optional ERC-20 Metadata

ERC-20 defines three optional metadata functions.

### name()

```solidity
function name() external view returns (string);
```

Returns the human-readable name of the token.

Example:

```text
My Token
```

### symbol()

```solidity
function symbol() external view returns (string);
```

Returns the token's short symbol.

Example:

```text
MTK
```

### decimals()

```solidity
function decimals() external view returns (uint8);
```

Defines how many decimal places the token uses for displaying amounts.

Most ERC-20 implementations use 18 decimals by default, although this is not a requirement of the standard.

For example, if a token uses 18 decimals:

```text
1 token = 1,000,000,000,000,000,000 smallest units
```

Smart contracts generally store token amounts as integers. The `decimals()` value helps user interfaces convert those integer amounts into human-readable values.

**Important:** `decimals()` does not change the underlying arithmetic or automatically make token amounts fractional. It is metadata used for interpreting and displaying token quantities.

## 3.7 ERC-20 Interface Summary

| Function / Event | Purpose |
|---|---|
| `totalSupply()` | Returns the current total token supply |
| `balanceOf()` | Returns an account's token balance |
| `transfer()` | Transfers tokens from the caller |
| `approve()` | Grants a spender permission |
| `allowance()` | Returns the remaining spending permission |
| `transferFrom()` | Transfers tokens using an allowance |
| `Transfer` | Records token transfer activity |
| `Approval` | Records approval activity |
| `name()` | Optional token name |
| `symbol()` | Optional token symbol |
| `decimals()` | Optional display precision |

## 3.8 Why Is ERC-20 Important?

ERC-20 provides a common interface that makes fungible tokens easier to integrate across the Ethereum ecosystem.

Without a shared standard, every wallet, exchange, or decentralized application might need custom logic for every token.

With ERC-20, compatible applications can use a consistent interface.

This enables:

- Wallet integrations.
- Decentralized exchange integrations.
- Token-based payment systems.
- Staking applications.
- Governance systems.
- DeFi protocols.
- Other smart contracts that interact with fungible tokens.

ERC-20 does not define the complete economic design of a token. It does not decide whether a token should have a fixed supply, inflation, burning, minting permissions, or a particular business model.

Those decisions depend on the token contract's implementation and design.

---

# 4. What Is OpenZeppelin?

## 4.1 Introduction

**OpenZeppelin** is a widely used open-source project that provides reusable smart contract libraries and development tools for Ethereum and other EVM-compatible networks.

Its Contracts library contains implementations and utilities for common blockchain development requirements, including:

- ERC-20 tokens.
- ERC-721 NFTs.
- ERC-1155 multi-token contracts.
- Access control and permissions.
- Governance.
- Security-related utilities.
- Other reusable smart contract components.

Official documentation:

[OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)

## 4.2 Why Does OpenZeppelin Exist?

Developing smart contracts requires careful attention to correctness and security.

A small implementation mistake can lead to unexpected behavior or financial loss.

For example, when implementing an ERC-20 token, a developer must correctly handle:

- Balance updates.
- Total supply accounting.
- Transfer validation.
- Allowance management.
- Approval behavior.
- Event emission.
- Edge cases and failure conditions.

Implementing these features from scratch requires a strong understanding of Solidity and the relevant standards.

OpenZeppelin provides reusable implementations of commonly needed functionality, helping developers avoid repeatedly writing the same foundational code.

Instead of starting every project from an empty file, developers can use established implementations and extend them when necessary.

## 4.3 What Is OpenZeppelin Contracts?

OpenZeppelin Contracts is a Solidity library containing reusable smart contract implementations.

One of its most commonly used components is the ERC-20 implementation:

```solidity
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```

A developer can create a token by inheriting from the provided ERC20 contract.

For example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply)
        ERC20("My Token", "MTK")
    {
        _mint(msg.sender, initialSupply);
    }
}
```

This example demonstrates several important Solidity concepts.

- `import` makes the ERC20 implementation available to the contract.
- `is ERC20` means `MyToken` inherits from OpenZeppelin's ERC20 implementation.
- `ERC20("My Token", "MTK")` initializes the token's name and symbol.
- `_mint()` creates the initial token supply and assigns it to the specified address.
- `msg.sender` represents the address that called the constructor during deployment.

The example uses OpenZeppelin's implementation rather than implementing every ERC-20 function manually.

The amount passed to `_mint()` is expressed in the token's smallest units. If the implementation uses 18 decimals, an initial supply of 1,000 tokens is commonly represented as:

```solidity
1000 * 10 ** 18
```

## 4.4 Understanding Inheritance

The example above uses Solidity inheritance.

Inheritance allows one contract to reuse functionality implemented in another contract.

In this case:

```solidity
contract MyToken is ERC20
```

means that `MyToken` inherits the functions and behavior provided by `ERC20`.

As a result, the token contract receives the standard ERC-20 functionality without having to implement every function itself.

The developer can then add project-specific behavior when needed.

## 4.5 Does Using OpenZeppelin Guarantee Security?

No.

OpenZeppelin provides widely used, carefully developed, and maintained smart contract implementations. However, using a library does not automatically make an entire application secure.

Security still depends on:

- Choosing the correct contracts and extensions.
- Understanding the inherited behavior.
- Writing correct custom logic.
- Configuring permissions properly.
- Testing important scenarios.
- Reviewing external integrations.
- Following secure deployment practices.

A secure library cannot protect an application from every mistake made when integrating or extending it.

Developers must understand the code they use rather than treating dependencies as black boxes.

## 4.6 OpenZeppelin vs. Implementing ERC-20 from Scratch

There are two common approaches to building an ERC-20 token.

### Approach 1: Use OpenZeppelin

Inherit from OpenZeppelin's ERC20 implementation and customize the contract when necessary.

Advantages:

- Reuses an established implementation.
- Reduces the amount of foundational code.
- Provides a familiar implementation for other developers.
- Makes it easier to add supported extensions.

### Approach 2: Implement ERC-20 from Scratch

Write the token contract manually while following the ERC-20 specification.

Advantages:

- Provides a deeper understanding of how the standard works.
- Helps developers understand balances, allowances, and transfers internally.
- Makes it easier to study the responsibilities of each function.
- Builds stronger Solidity implementation skills.

Both approaches are useful.

Understanding the standard and its underlying mechanics is important regardless of which implementation approach is eventually selected.

---

# 5. How These Concepts Fit Together

The four topics are connected:

1. **Token:** A digital representation of an asset, value, right, or utility.
2. **ERC:** An application-level standard that describes how smart contracts should expose common interfaces or behaviors.
3. **ERC-20:** A specific standard for fungible tokens on Ethereum.
4. **OpenZeppelin:** A reusable smart contract library that provides implementations of ERC standards, including ERC-20.

The relationship can be summarized as follows:

```text
Blockchain
    |
    v
Token
    |
    v
Smart Contract
    |
    v
ERC Standard
    |
    v
ERC-20 Interface
    |
    v
ERC-20 Implementation
    |
    v
OpenZeppelin or a Custom Implementation
```

An ERC-20 token is a token whose smart contract follows the ERC-20 standard.

OpenZeppelin provides one established way to implement that standard.

The standard defines the expected interface, while the implementation provides the actual code and behavior.

---

# 6. Important Concepts to Remember

Before implementing an ERC-20 contract, make sure you understand the following:

- A token can represent more than just a cryptocurrency.
- ETH is Ethereum's native cryptocurrency, not an ERC-20 token.
- Tokens can be fungible or non-fungible.
- A token contract is a smart contract that manages token-related data and operations.
- ERC standards help different applications interact with compatible smart contracts.
- EIPs provide the broader Ethereum proposal and specification process.
- ERC-20 is designed for fungible tokens.
- ERC-20 defines six required functions and two required events.
- The `name()`, `symbol()`, and `decimals()` functions are optional metadata extensions in EIP-20.
- `approve()` grants spending permission; it does not transfer tokens.
- `transferFrom()` uses an existing allowance to transfer tokens.
- Token amounts are stored as integers, while `decimals()` helps represent them in a human-readable format.
- OpenZeppelin provides reusable smart contract implementations.
- Using a library does not eliminate the need for testing, security reviews, and understanding the code.

---

# 7. References and Further Reading

The following resources provide the official specifications and documentation used throughout this guide.

## Ethereum Documentation

- [Ethereum — ERC-20 Token Standard](https://ethereum.org/developers/docs/standards/tokens/erc-20/)
- [Ethereum — Development Standards](https://ethereum.org/developers/docs/standards/)
- [Ethereum — Token Standards](https://ethereum.org/developers/docs/standards/tokens/)

## Official Specifications

- [EIP-20 — ERC-20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [EIP-1 — EIP Purpose and Guidelines](https://eips.ethereum.org/EIPS/eip-1)

## OpenZeppelin Documentation

- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)
- [OpenZeppelin — ERC-20 Documentation](https://docs.openzeppelin.com/contracts/5.x/erc20)
- [OpenZeppelin — Contracts Repository](https://github.com/OpenZeppelin/openzeppelin-contracts)

---

## Conclusion

Understanding tokens, Ethereum standards, ERC-20, and OpenZeppelin provides the foundation for developing fungible token smart contracts.

These concepts explain what a token represents, why common interfaces are necessary, how ERC-20 contracts manage token operations, and how reusable libraries can support implementation.

With these fundamentals in place, the next step is to examine the ERC-20 specification in more detail and translate its requirements into a working smart contract.