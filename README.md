# Hassan ERC-20 Token

A fungible ERC-20 token implemented in Solidity with OpenZeppelin Contracts and developed, tested, deployed, and verified using Foundry.

The project demonstrates the core ERC-20 token lifecycle on Ethereum: token metadata, supply management, balances, direct transfers, approvals, delegated transfers, access-controlled minting, ownership management, automated testing, testnet deployment, source-code verification, and wallet integration.

> **Network:** Ethereum Sepolia (Chain ID: `11155111`)  
> **Token:** Hassan (`HSN`)  
> **Contract:** [`0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB`](https://eth-sepolia.blockscout.com/address/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB)

---

## Table of Contents

- [Project Overview](#project-overview)
- [Deployed Contract](#deployed-contract)
- [Features](#features)
- [ERC-20 Standard](#erc-20-standard)
- [Contract Design](#contract-design)
- [Token Lifecycle](#token-lifecycle)
- [Access Control and Ownership](#access-control-and-ownership)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
- [Testing Strategy](#testing-strategy)
- [Build and Test](#build-and-test)
- [Deployment](#deployment)
- [Contract Verification](#contract-verification)
- [MetaMask Integration](#metamask-integration)
- [Security Considerations](#security-considerations)
- [Configuration and Secrets](#configuration-and-secrets)
- [Development Workflow](#development-workflow)
- [References](#references)

---

## Project Overview

ERC-20 is the widely adopted Ethereum token standard for fungible assets. It defines a common interface that allows wallets, decentralized applications, exchanges, and other smart contracts to interact with tokens in a consistent way.

This project implements a token named **Hassan**, with the symbol **HSN**, using the audited and widely adopted ERC-20 implementation provided by OpenZeppelin Contracts. Rather than reimplementing the standard's accounting and transfer logic, the project inherits the established implementation and adds a project-specific minting capability protected by ownership-based access control.

The token's name and symbol are fixed in the contract constructor. The contract deployer becomes the initial owner, and the initial total supply is zero. The owner can create tokens later through the restricted `mint` function.

The project also includes a Foundry test suite covering expected behavior, access restrictions, emitted events, invalid inputs, and important edge cases. The deployed Sepolia contract has been verified on Etherscan, Blockscout, and Sourcify, and the token has been added to MetaMask for wallet-side inspection.

## Deployed Contract

| Property | Value |
|---|---|
| Contract name | `Hassan` |
| Token name | `Hassan` |
| Token symbol | `HSN` |
| Network | Ethereum Sepolia Testnet |
| Chain ID | `11155111` |
| Solidity pragma | `^0.8.31` |
| Compiler used for deployment | `0.8.37+commit.f401782d` |
| EVM version | `osaka` |
| Optimization | Disabled |
| License | MIT |
| Token decimals | `18` |
| Initial total supply | `0 HSN` |
| Deployer / initial owner | `0x708f5b324aCcC61c9bfc30bF10653783e3680d4E` |
| Contract address | `0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB` |
| Deployment transaction | `0xd50487be6e7ea8b716d67f36c78c5668e2e5391f9b486932fa95fe303bc70a31` |

### Contract Explorer Links

- [View on Etherscan — Sepolia](https://sepolia.etherscan.io/address/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB)
- [View on Blockscout — Sepolia](https://eth-sepolia.blockscout.com/address/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB)
- [View verified source on Sourcify](https://repo.sourcify.dev/contracts/full_match/11155111/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB/)
- [View deployment transaction](https://sepolia.etherscan.io/tx/0xd50487be6e7ea8b716d67f36c78c5668e2e5391f9b486932fa95fe303bc70a31)

## Features

- **ERC-20 implementation:** Uses OpenZeppelin's standard ERC-20 implementation.
- **Fixed token metadata:** Initializes the token name as `Hassan` and symbol as `HSN` directly in the constructor.
- **Standard decimal precision:** Uses the OpenZeppelin ERC-20 default of 18 decimals.
- **Owner-controlled minting:** Restricts token creation to the current owner through `onlyOwner`.
- **Balance accounting:** Inherits standard balance tracking and supply accounting.
- **Direct transfers:** Supports `transfer` between accounts.
- **Approvals and allowances:** Supports `approve` and `allowance` for delegated token spending.
- **Delegated transfers:** Supports `transferFrom` subject to the owner's balance and the available allowance.
- **Ownership management:** Supports ownership transfer and renunciation through OpenZeppelin `Ownable`.
- **Automated testing:** Uses Foundry to test successful operations, expected reverts, events, and edge cases.
- **Foundry deployment:** Deploys the contract to Sepolia using a configured Foundry keystore account.
- **Multi-explorer verification:** Verified source code is available through Etherscan, Blockscout, and Sourcify.
- **Wallet integration:** Added the deployed HSN token to MetaMask on Sepolia.

## ERC-20 Standard

The contract builds on [EIP-20](https://eips.ethereum.org/EIPS/eip-20), which specifies the common interface for fungible tokens.

### Standard Functions

| Function | Purpose |
|---|---|
| `totalSupply()` | Returns the total number of tokens currently in existence. |
| `balanceOf(address account)` | Returns the token balance of an account. |
| `transfer(address to, uint256 value)` | Transfers tokens from the caller to another address. |
| `allowance(address owner, address spender)` | Returns the remaining amount an owner has authorized a spender to use. |
| `approve(address spender, uint256 value)` | Sets or replaces the spender's allowance. |
| `transferFrom(address from, address to, uint256 value)` | Transfers tokens using an allowance previously granted by the token owner. |

### Standard Events

| Event | Purpose |
|---|---|
| `Transfer` | Records token transfers. Minting is also represented by a `Transfer` event whose sender is the zero address. |
| `Approval` | Records an allowance approval or update. |

### Metadata

The token exposes the ERC-20 metadata extension:

- `name()` returns `Hassan`.
- `symbol()` returns `HSN`.
- `decimals()` returns `18`.

`decimals` affects how token amounts are displayed by wallets and interfaces. It does not change the integer arithmetic used by the contract. For example, `1 HSN` is represented on-chain as `1e18` base units.

## Contract Design

**Source file:** `src/Hassan.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hassan is ERC20, Ownable {
    constructor() ERC20("Hassan", "HSN") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
```

### Inheritance

The contract inherits from two OpenZeppelin contracts:

- `ERC20` provides the standard token implementation, including balances, transfers, approvals, allowances, metadata, and the standard events.
- `Ownable` provides ownership management and the `onlyOwner` access-control modifier.

This keeps the project-specific contract small and makes its custom behavior easy to identify: the contract fixes its metadata at deployment and adds an owner-restricted minting function.

### Constructor and Initialization

```solidity
constructor() ERC20("Hassan", "HSN") Ownable(msg.sender) {}
```

The constructor intentionally takes no arguments. The token name and symbol are constants for this project and are initialized directly through the parent `ERC20` constructor. `Ownable(msg.sender)` assigns ownership to the account deploying the contract.

No tokens are minted during construction, so `totalSupply()` initially returns zero. The owner can create the initial supply later by calling `mint`.

### Minting

```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

The `onlyOwner` modifier ensures that only the current owner can call this function. OpenZeppelin's `_mint` updates the recipient's balance and the total supply, and emits the standard `Transfer` event from the zero address. Invalid recipients are rejected by the inherited implementation.

The contract does not impose a maximum supply or a minting schedule. The current owner therefore has the authority to mint any amount accepted by the ERC-20 implementation. This is an important trust assumption for anyone using the token.

## Token Lifecycle

### 1. Minting and Supply

Minting creates new tokens and increases both the recipient's balance and the total supply. Since the constructor does not mint an initial allocation, the supply remains zero until the owner calls `mint`.

### 2. Direct Transfers

A holder can call `transfer` to move tokens from their own balance to a recipient. A successful transfer decreases the sender's balance and increases the recipient's balance by the same amount. The total supply does not change.

### 3. Approvals and Allowances

A token holder can call `approve` to authorize a spender to use up to a specified amount of their tokens. The approved amount is stored as an allowance for that owner-spender pair and can be queried through `allowance`.

Calling `approve` again sets the allowance to the new value; it does not add the new value to the previous allowance. Applications should take care when changing non-zero allowances, because allowance changes can have transaction-ordering implications. Users should approve only spenders they trust and only amounts they intend to authorize.

### 4. Delegated Transfers

An approved spender can call `transferFrom` to transfer tokens from the owner's balance, subject to both the owner's available balance and the remaining allowance. For a finite allowance, a successful delegated transfer reduces the remaining allowance by the amount transferred.

OpenZeppelin's ERC-20 implementation treats `type(uint256).max` as an infinite allowance: it is not decreased by `transferFrom`. This behavior is explicitly covered by the project's tests. Infinite approvals are convenient, but they grant broad spending authority and should be used carefully.

## Access Control and Ownership

The contract uses OpenZeppelin `Ownable` for privileged operations.

- **Initial owner:** The deploying account becomes the owner through `Ownable(msg.sender)`.
- **Restricted minting:** Only the current owner can call `mint`.
- **Ownership transfer:** The owner can call `transferOwnership` to assign ownership to another valid address. After the transfer, the previous owner can no longer perform owner-only operations.
- **Ownership renunciation:** The owner can call `renounceOwnership`, setting the owner to the zero address. Once ownership is renounced, there is no owner account able to call `mint`.

Renouncing ownership is a consequential and effectively irreversible action for this contract: because minting is protected by `onlyOwner`, renunciation permanently removes the ability to mint through the current contract implementation. Ownership should only be transferred or renounced after carefully checking the destination and the intended administrative model.

## Technology Stack

| Technology | Role |
|---|---|
| Solidity | Smart contract programming language. |
| Foundry | Development, compilation, testing, deployment, and verification workflow. |
| Forge | Build, test, deploy, and verification commands. |
| OpenZeppelin Contracts | ERC-20 implementation and ownership access control. |
| forge-std | Foundry testing utilities and assertions. |
| Ethereum | Blockchain execution environment. |
| Sepolia | Ethereum testnet used for deployment and validation. |
| Etherscan | Contract and transaction explorer; source verification. |
| Blockscout | Contract explorer and source verification. |
| Sourcify | Contract source verification and metadata repository. |
| MetaMask | Wallet used to import and inspect the deployed HSN token. |
| Git and GitHub | Version control and project hosting. |

## Repository Structure

The repository separates the contract, automated tests, dependencies, and day-by-day learning documentation.

```text
erc20-token-project/
├── days/
│   ├── day-01/
│   │   └── README.md
│   ├── day-02/
│   │   └── README.md
│   ├── day-03/
│   │   └── README.md
│   ├── day-04/
│   │   └── README.md
│   └── day-05/
│       └── README.md
├── lib/
│   ├── forge-std/
│   └── openzeppelin-contracts/
├── src/
│   └── Hassan.sol
├── test/
│   └── Hassan.t.sol
├── .env.example
├── .gitignore
├── foundry.toml
├── Makefile
└── README.md
```

The `days/` documentation records the concepts and implementation work covered during the project:

| Documentation | Focus |
|---|---|
| `day-01/` | Fungible tokens, Ethereum token standards, ERC-20, interfaces, and OpenZeppelin. |
| `day-02/` | Implementing the Hassan token, metadata, minting, transfers, approvals, and allowances. |
| `day-03/` | Testnet deployment, contract interaction, explorer verification workflow, and wallet inspection. |
| `day-04/` | Foundry testing fundamentals and tests for initialization, minting, and transfers. |
| `day-05/` | Approval and allowance behavior, delegated transfers, and ownership management tests. |

## Testing Strategy

The project uses Foundry's `forge test` framework. The test contract deploys a fresh `Hassan` instance in `setUp()` for each test and prepares separate owner, Alice, and Bob accounts. This isolates test cases and makes caller identity explicit when testing permissions and delegated operations.

The test suite covers the following areas:

### Constructor and Metadata

- Verifies the token name is `Hassan`.
- Verifies the token symbol is `HSN`.
- Verifies the deployer/test contract is the initial owner.
- Verifies the initial total supply is zero.
- Verifies the token uses 18 decimals.

### Minting

- Successful minting by the owner.
- Minting to multiple recipient addresses.
- Rejection of minting by a non-owner.
- Rejection of minting to the zero address.
- Correct updates to recipient balances and total supply.

### Transfers

- Successful transfer between accounts.
- Rejection of transfers exceeding the sender's balance.
- Rejection of transfers to the zero address.
- Verification of the emitted `Transfer` event.

### Approvals and Allowances

- Successful approval and allowance assignment.
- Replacing an existing allowance with a new amount.
- Rejection of an approval using the zero address as spender.
- Verification of the emitted `Approval` event.

### Delegated Transfers

- Successful `transferFrom` by an approved spender.
- Correct sender and recipient balances after the transfer.
- Correct reduction of a finite allowance after spending.
- Rejection when the requested amount exceeds the allowance.
- Preservation of an infinite allowance set to `type(uint256).max`.
- Rejection of delegated transfers to the zero address.

### Ownership Management

- Successful transfer of ownership.
- Rejection of ownership transfer by a non-owner.
- Rejection of ownership transfer to the zero address.
- Confirmation that the new owner can mint.
- Confirmation that the previous owner can no longer mint.
- Successful ownership renunciation.
- Rejection of renunciation by a non-owner.
- Confirmation that minting is no longer possible after renunciation.

Run the tests with:

```bash
forge test
```

For detailed traces:

```bash
forge test -vvvv
```

For a coverage report:

```bash
forge coverage
```

The test suite is intended to validate both successful execution and the contract's behavior when an operation must be rejected. The exact test count should be taken from the output of the current checkout rather than hard-coded in this README.

## Build and Test

### Prerequisites

- Git
- Foundry (including `forge`)
- An Ethereum wallet for testnet interaction
- Sepolia test ETH for deployment
- A Sepolia RPC endpoint
- An Etherscan API key if using Etherscan verification

### Clone the Repository

```bash
git clone https://github.com/Hassan5737/erc20-token-project.git
cd erc20-token-project
```

### Install Dependencies

The repository includes its Foundry and OpenZeppelin dependencies under `lib/`. If dependencies need to be installed or restored, use the project's configured dependency setup and remappings.

### Compile

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

## Deployment

The Hassan token was deployed to Ethereum Sepolia using Foundry's `forge create` command and a locally configured Foundry keystore account. The token metadata is embedded in the constructor, so no name or symbol arguments are required during deployment.

The deployment command used was:

```bash
forge create Hassan \
    --account hassanAccount \
    --rpc-url "$SEPOLIA_RPC_URL" \
    --broadcast
```

The command compiled the project successfully and broadcast the deployment transaction. The resulting contract address and transaction hash are recorded in the [Deployed Contract](#deployed-contract) section.

### Deployment Notes

- `hassanAccount` is the local Foundry keystore account name; it is not a private key.
- The RPC endpoint is supplied at runtime and should not be hard-coded into public documentation.
- Foundry prompts for the keystore password when required.
- The deployer becomes the initial owner and therefore receives the authority to mint and manage ownership.
- The deployment is on Sepolia, a test network, and is not an Ethereum mainnet deployment.

## Contract Verification

The deployed contract source was verified across three blockchain verification platforms.

| Platform | Result | Link |
|---|---|---|
| Etherscan | Foundry verification command reported the contract was already verified. | [Etherscan](https://sepolia.etherscan.io/address/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB#code) |
| Blockscout | Contract page displays **Contract source code verified (exact match)**. | [Blockscout](https://eth-sepolia.blockscout.com/address/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB?tab=contract) |
| Sourcify | Contract is available under the Sepolia `full_match` repository path. | [Sourcify](https://repo.sourcify.dev/contracts/full_match/11155111/0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB/) |

The Foundry verification command used for Etherscan and Sourcify was:

```bash
forge verify-contract \
    --chain-id 11155111 \
    --verifier etherscan \
    --etherscan-api-key "$ETHERSCAN_API_KEY" \
    --watch \
    0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB \
    src/Hassan.sol:Hassan
```

The command reported that the contract was already verified on Etherscan and Sourcify. Blockscout's contract page displays an exact-match source verification status. Verification allows users to inspect the published source and compare it with the deployed contract bytecode under the verification settings.

## MetaMask Integration

After deployment, the custom HSN token was added to MetaMask on the Ethereum Sepolia network using its contract address.

To inspect the token in a wallet:

1. Switch MetaMask to **Sepolia**.
2. Open the import-token flow.
3. Enter the deployed Hassan token contract address:
   `0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB`
4. Confirm the detected token details (`HSN`, 18 decimals) and import the token.

The wallet screenshot shows the imported token entry. The displayed balance is `0 HSN`; this is consistent with the contract's zero initial supply unless tokens have subsequently been minted and transferred to that wallet. Importing a token into MetaMask does not itself mint or transfer tokens.

## Security Considerations

This project is an educational and portfolio project deployed to a testnet. It has not been presented as professionally audited or production-ready.

Important trust and security considerations include:

- **Owner privilege:** The owner can mint new tokens without a configured maximum supply. Token holders must trust the owner not to inflate the supply unexpectedly.
- **Ownership transfer:** Transferring ownership changes who can mint. The destination address should be checked carefully before the transaction is confirmed.
- **Ownership renunciation:** Renouncing ownership removes the account authorized to mint. This action should be treated as permanent for this contract.
- **Token approvals:** An approved spender can transfer tokens up to the available allowance. Users should review spender addresses and approval amounts.
- **Infinite approvals:** An allowance of `type(uint256).max` is not reduced by delegated transfers in the inherited OpenZeppelin implementation. This can expose the approved balance to the spender until the approval is changed or otherwise revoked.
- **Dependency use:** OpenZeppelin provides established implementations, but using a library does not automatically make a complete application secure.
- **Testing limitations:** Automated tests improve confidence in expected behavior but do not prove the absence of vulnerabilities.
- **Network scope:** The deployment is on Sepolia and has no claim to mainnet deployment or production audit status.

## Configuration and Secrets

Supply RPC endpoints and API credentials locally through environment variables or the project's local configuration. Do not commit secrets to Git.

Example `.env` entries:

```dotenv
SEPOLIA_RPC_URL=YOUR_SEPOLIA_RPC_URL
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
CONTRACT_ADDRESS=0x95Bea4C3757c5143d12dAD30Eb93bEf58B9e88fB
```

Security rules:

- Never commit private keys, keystore passwords, RPC credentials, or API keys.
- Keep `.env` excluded through `.gitignore`.
- Use a placeholder-only `.env.example` for configuration documentation.
- If an API key or credential is exposed in a terminal recording, screenshot, chat, or public repository, revoke or rotate it before using it again.
- Do not publish generated compiler input or build artifacts unless there is a specific reason to include them.

## Development Workflow

The project follows a practical smart contract development workflow:

1. Study the ERC-20 specification and the role of its interface and events.
2. Implement the project token by extending OpenZeppelin's ERC-20 and Ownable contracts.
3. Build and run the contract locally with Foundry.
4. Write automated tests for standard operations, permissions, events, expected reverts, and edge cases.
5. Deploy the contract to Sepolia using a Foundry keystore account.
6. Verify the deployed source on Etherscan, Blockscout, and Sourcify.
7. Import the deployed token into MetaMask and inspect its wallet representation.
8. Document the implementation, testing, deployment, and verification process.

## References

- [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [Ethereum Developer Documentation](https://ethereum.org/en/developers/docs/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts Documentation](https://docs.openzeppelin.com/contracts/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Etherscan Sepolia](https://sepolia.etherscan.io/)
- [Blockscout](https://www.blockscout.com/)
- [Sourcify](https://sourcify.dev/)
- [MetaMask Documentation](https://support.metamask.io/)

---

## Author

**Hassan Ahmed**  
[GitHub](https://github.com/Hassan5737) · [LinkedIn](https://www.linkedin.com/in/hassan-ahmed-assad/)

**Repository:** [Hassan ERC-20 Token](https://github.com/Hassan5737/erc20-token-project)
