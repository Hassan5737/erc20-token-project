
# ERC-20 Token

A Solidity-based ERC-20 token implementation built with Foundry, following the Ethereum token standard and established smart contract development practices.

This project demonstrates the design, implementation, testing, and deployment of a fungible token on Ethereum. It covers the core ERC-20 functionality, including token supply management, balance tracking, transfers, approvals, and delegated transfers.

The codebase emphasizes correctness, security, maintainability, and comprehensive automated testing, providing a practical implementation of one of the most fundamental standards in the Ethereum ecosystem.

---

## Table of Contents

- [Overview](#overview)
- [Core Features](#core-features)
- [ERC-20 Standard](#erc-20-standard)
- [Token Architecture](#token-architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Smart Contract Design](#smart-contract-design)
- [Testing](#testing)
- [Security Considerations](#security-considerations)
- [Deployment](#deployment)
- [Installation and Usage](#installation-and-usage)
- [Development Principles](#development-principles)
- [References](#references)

---

## Overview

ERC-20 is the standard interface for fungible tokens on Ethereum. It enables different applications, wallets, exchanges, and smart contracts to interact with tokens through a consistent set of functions and events.

This project provides an ERC-20 token implementation using Solidity and Foundry. It focuses on the essential mechanisms behind token contracts and demonstrates how these mechanisms work together to maintain consistent token ownership and supply accounting.

The implementation covers the complete token lifecycle, from initial supply creation to transfers and delegated spending through allowances.

## Core Features

- **ERC-20 Compliance:** Implements the standard token interface defined by EIP-20.
- **Token Metadata:** Provides token name, symbol, and decimal precision.
- **Supply Management:** Defines and manages the token's initial supply and minting behavior.
- **Balance Tracking:** Maintains the token balance of each account.
- **Token Transfers:** Supports direct transfers between accounts.
- **Approval Mechanism:** Allows token holders to authorize other accounts to spend tokens.
- **Allowance Management:** Tracks and updates approved spending limits.
- **Delegated Transfers:** Supports transfers performed on behalf of token holders through `transferFrom`.
- **Event Emission:** Emits standard ERC-20 events for transfers and approvals.
- **Automated Testing:** Uses Foundry to validate contract behavior, expected reverts, and edge cases.
- **Testnet Deployment:** Includes deployment scripts and testnet deployment support.

## ERC-20 Standard

The implementation follows [EIP-20](https://eips.ethereum.org/EIPS/eip-20), which defines the standard interface for fungible tokens.

### Required Functions

| Function | Description |
|---|---|
| `totalSupply()` | Returns the total number of tokens in existence. |
| `balanceOf(address)` | Returns the token balance of a specified account. |
| `transfer(address, uint256)` | Transfers tokens from the caller to another account. |
| `allowance(address, address)` | Returns the remaining amount approved for a spender. |
| `approve(address, uint256)` | Sets the amount a spender is allowed to use. |
| `transferFrom(address, address, uint256)` | Transfers tokens using an existing allowance. |

### Required Events

| Event | Description |
|---|---|
| `Transfer` | Emitted when tokens are transferred between accounts. |
| `Approval` | Emitted when an allowance is approved or updated. |

### Token Metadata

The token also exposes the commonly used ERC-20 metadata:

- `name()`: The human-readable token name.
- `symbol()`: The token ticker symbol.
- `decimals()`: The number of decimal places used for displaying token amounts.

The metadata functions are defined by the optional ERC-20 metadata extension.

## Token Architecture

The contract follows the ERC-20 token model, in which balances and allowances are maintained independently for each account.

### Supply and Balances

The token supply represents the total amount of tokens in existence. Each account has an associated balance, and token transfers update the sender's and recipient's balances while preserving the total supply.

### Transfers

A token holder can transfer tokens directly to another address. A successful transfer decreases the sender's balance and increases the recipient's balance by the same amount.

### Approvals and Allowances

The approval mechanism allows an account to authorize another account to spend a specified amount of its tokens.

The allowance mechanism tracks the remaining approved amount and enables delegated transfers through `transferFrom`.

### Delegated Transfers

An approved spender can transfer tokens from the token holder's account, provided that the requested amount does not exceed the available allowance or the owner's balance.

## Technology Stack

| Technology | Purpose |
|---|---|
| Solidity | Smart contract implementation. |
| Foundry | Smart contract development and testing framework. |
| Forge | Compilation, testing, and deployment scripting. |
| Cast | Ethereum RPC interaction and contract operations. |
| Anvil | Local Ethereum development network. |
| OpenZeppelin Contracts | Standardized smart contract interfaces and reusable implementations. |
| Ethereum | Blockchain execution environment. |
| Sepolia | Ethereum test network. |
| Etherscan / Blockscout | Transaction and contract exploration. |
| Git & GitHub | Version control and source code management. |


## Project Structure

The repository is organized into dedicated directories for smart contract development, automated testing, deployment, and day-by-day technical documentation.

```text
erc20-token-project/
├── days/
│   ├── day-01/
│   │   └── README.md
│   └── day-02/
│       └── README.md
├── lib/
│   ├── forge-std/
│   └── openzeppelin-contracts/
├── script/
│   └── DeployERC20.s.sol
├── src/
│   └── ERC20Token.sol
├── test/
│   └── ERC20Token.t.sol
├── .env.example
├── .gitignore
├── foundry.toml
└── README.md
```

### Daily Development Documentation

The `days/` directory contains technical documentation organized by development day. Each day's README records the concepts studied, implementation details, engineering decisions, and relevant references.

| Directory | Focus |
|---|---|
| `day-01/` | Token fundamentals, fungible tokens, Ethereum token standards, ERC-20 specification, IERC20 interface, and OpenZeppelin ERC-20 implementation. |
| `day-02/` | ERC-20 smart contract implementation, token metadata, initial supply, minting, transfers, approvals, and allowance management. |

### Main Project Directories

- `src/`: Solidity smart contract source code.
- `test/`: Foundry automated tests covering functionality, edge cases, and expected reverts.
- `script/`: Deployment and contract interaction scripts.
- `lib/`: External Solidity dependencies, including Foundry and OpenZeppelin libraries.
- `days/`: Structured technical documentation for each development day.

## Smart Contract Design

The token implementation is organized around the responsibilities defined by the ERC-20 standard.

### Token Initialization

The contract initializes its metadata and establishes the initial token supply, assigning the initial allocation according to the constructor configuration.

### Supply Management

Token supply operations maintain accurate accounting of the total number of tokens in existence. Minting operations increase the supply and update the recipient's balance consistently.

### Balance Management

Every account's token balance is maintained through the contract's state. Transfers and supply operations update balances while preserving the contract's accounting invariants.

### Approval and Allowance Management

The contract provides an authorization mechanism for delegated token spending. Allowances are tracked per token owner and spender, and are updated as delegated transfers are executed.

### Events

The standard `Transfer` and `Approval` events provide an observable record of token transfers and approval changes, allowing external applications and blockchain explorers to track token activity.

## Testing

The project uses Foundry to provide automated testing for the token's functionality and expected behavior.

The test suite covers:

- Initial token supply and allocation.
- Token metadata.
- Account balance tracking.
- Successful transfers.
- Transfers with insufficient balances.
- Minting behavior.
- Approval operations.
- Allowance updates.
- Successful delegated transfers.
- Delegated transfers exceeding the available allowance.
- Delegated transfers with insufficient owner balances.
- Event emission.
- Invalid inputs and relevant edge cases.
- Expected reverts and failure conditions.

Tests are designed to validate both successful operations and situations in which the contract must reject an operation.

Run the complete test suite:

```bash
forge test
```

Run tests with detailed execution traces:

```bash
forge test -vvvv
```

Generate a code coverage report:

```bash
forge coverage
```

## Security Considerations

Smart contract security is a fundamental part of the implementation.

The project considers the following areas:

- **Access Control:** Restricting privileged operations to authorized accounts.
- **Supply Integrity:** Maintaining consistency between total supply and account balances.
- **Balance Validation:** Preventing transfers that exceed available balances.
- **Allowance Validation:** Enforcing approved spending limits during delegated transfers.
- **Input Validation:** Handling invalid addresses and unsupported operations.
- **State Consistency:** Ensuring that state updates preserve token accounting invariants.
- **Dependency Management:** Using established libraries and maintaining controlled dependency versions.
- **Automated Testing:** Validating expected behavior, failure conditions, and edge cases.

The use of established libraries and automated tests improves development reliability but does not replace a professional security audit.

## Deployment

The contract is deployable to Ethereum-compatible networks using Foundry deployment scripts.

The deployment workflow includes:

1. Configuring the target network and RPC endpoint.
2. Setting up deployment credentials securely.
3. Executing the deployment script.
4. Recording the deployed contract address and transaction hash.
5. Verifying the contract source code on a supported block explorer.
6. Interacting with the deployed token through wallet and RPC tools.

Sepolia is used as the primary Ethereum test network for deployment and validation.

### Environment Configuration

Network credentials and sensitive values are supplied through environment variables.

Example configuration:

```bash
SEPOLIA_RPC_URL=
PRIVATE_KEY=
ETHERSCAN_API_KEY=
```

Private keys and API credentials must never be committed to version control.

## Installation and Usage

### Prerequisites

- Git
- Foundry
- Solidity compiler supported by the project configuration
- An Ethereum wallet for testnet interaction
- Sepolia test ETH for deployment

### Clone the Repository

```bash
git clone https://github.com/Hassan5737/erc20-token-project.git
cd erc20-token-project
```

### Install Dependencies

```bash
forge install
```

### Build Contracts

```bash
forge build
```

### Run Tests

```bash
forge test
```

### Format Solidity Files

```bash
forge fmt
```

### Start a Local Blockchain

```bash
anvil
```

### Deploy to Sepolia

After configuring the environment variables:

```bash
forge script script/DeployERC20.s.sol:DeployERC20 \
    --rpc-url $SEPOLIA_RPC_URL \
    --broadcast \
    --verify
```

The exact deployment configuration depends on the selected network and verification provider.

## Development Principles

The project follows these engineering principles:

- **Standard Compliance:** Follow established Ethereum token standards.
- **Separation of Concerns:** Keep contract logic, tests, and deployment scripts organized.
- **Readability:** Prefer clear naming, consistent formatting, and maintainable code.
- **Testability:** Validate behavior through automated tests.
- **Security Awareness:** Consider failure conditions and state invariants during implementation.
- **Reproducibility:** Use version-controlled dependencies and documented commands.
- **Documentation:** Explain the architecture, important design decisions, and usage workflow.

## References

- [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [Ethereum Developer Documentation](https://ethereum.org/en/developers/docs/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts Documentation](https://docs.openzeppelin.com/contracts/)
- [Foundry Documentation](https://book.getfoundry.sh/)

---

**Author:** [Hassan Ahmed](https://github.com/Hassan5737)

**GitHub Repository:** [erc20-token-project](https://github.com/Hassan5737/erc20-token-project)
