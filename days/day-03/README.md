# ERC-20 Deployment, Verification & Interaction

## Overview

This day focuses on taking an ERC-20 smart contract beyond local development and making it accessible on an Ethereum test network.

The `Hassan (HSN)` token contract was deployed to the Sepolia test network using Remix IDE. After deployment, the contract was verified on blockchain explorers, its functions were explored through Blockscout, and the token was imported into MetaMask.

The practical workflow covered:

1. Deploying a smart contract to Sepolia.
2. Verifying the contract source code on Blockscout.
3. Interacting with the deployed contract through Blockscout.
4. Importing a custom ERC-20 token into MetaMask.
5. Verifying the contract on Sepolia Etherscan.

**Deployment tool:** Remix IDE  
**Network:** Sepolia Testnet  
**Token:** Hassan (HSN)  
**Contract standard:** ERC-20

> Note: This deployment was performed using Remix IDE as a learning exercise. Foundry deployment is a separate workflow and is not covered by this deployment step.

## 1. Deploying a Smart Contract to Sepolia

### 1.1 What Is Smart Contract Deployment?

Smart contract deployment is the process of publishing compiled contract bytecode to a blockchain network.

When a contract is deployed:

- A deployment transaction is submitted to the network.
- Validators process the transaction.
- The contract is assigned a unique blockchain address.
- Its code becomes available at that address.
- The deployment transaction is recorded permanently on the blockchain.

Unlike a normal application running on a local machine, a deployed smart contract can be accessed by other users and applications through the blockchain.

### 1.2 What Is Sepolia?

Sepolia is an Ethereum test network used by developers to test smart contracts and decentralized applications without spending real ETH.

It provides an environment for testing deployment, transactions, and contract interactions before working with the Ethereum mainnet.

Sepolia uses test ETH, which has no real monetary value.

### 1.3 Why Deploy to a Testnet?

Deploying to a testnet allows developers to:

- Test smart contracts in a real blockchain environment.
- Experiment with transactions and gas fees.
- Test wallet integrations.
- Interact with deployed contracts.
- Identify problems before mainnet deployment.

### 1.4 Deploying Through Remix IDE

Remix IDE is a browser-based development environment for writing, compiling, deploying, and interacting with Solidity smart contracts.

The deployment workflow includes:

1. Opening the Solidity contract in Remix.
2. Selecting the appropriate Solidity compiler version.
3. Compiling the contract.
4. Connecting MetaMask to the Sepolia network.
5. Selecting the injected provider in Remix.
6. Deploying the contract.
7. Confirming the transaction through MetaMask.
8. Retrieving the deployed contract address.

The deployed contract address is the public identifier used to access the contract on the blockchain.

## 2. Contract Verification on Blockscout

### 2.1 What Is Contract Verification?

Contract verification is the process of publishing the contract's source code and compiler settings to a blockchain explorer so that they can be compared against the bytecode deployed on the blockchain.

The goal is to establish that the published source code corresponds to the deployed contract.

Without verification, an explorer may show the contract address and bytecode, but users cannot easily inspect the original Solidity source code.

### 2.2 What Is Blockscout?

Blockscout is an open-source blockchain explorer that allows users and developers to explore blockchain data.

It provides access to:

- Transactions.
- Blocks.
- Wallet addresses.
- Smart contracts.
- Contract source code when verified.
- Contract interactions.

### 2.3 Why Verify a Smart Contract?

Verification improves transparency and makes it easier for users and developers to understand what a deployed contract does.

It allows them to:

- Inspect the Solidity source code.
- Review public functions.
- Understand contract behavior.
- Read available contract data.
- Interact with supported functions through the explorer.

### 2.4 Verification Requirements

Successful verification generally requires matching the deployed contract's build configuration, including:

- The exact Solidity source code.
- Compiler version.
- Optimization settings.
- Constructor arguments.
- Dependency and library information when applicable.

A mismatch between the original deployment settings and the submitted verification settings can cause verification to fail.

## 3. Interacting with a Smart Contract Through Blockscout

After a contract is verified, Blockscout can provide an interface for reading and writing contract functions.

### 3.1 Read Functions

Read functions retrieve information from the blockchain without creating a state-changing transaction.

Examples from an ERC-20 contract include:

| Function | Purpose |
|---|---|
| `name()` | Returns the token name. |
| `symbol()` | Returns the token symbol. |
| `decimals()` | Returns the token decimal precision. |
| `totalSupply()` | Returns the current total token supply. |
| `balanceOf(address)` | Returns the token balance of an address. |
| `allowance(owner, spender)` | Returns the remaining spending allowance. |

Read operations do not require a transaction fee because they do not modify blockchain state.

### 3.2 Write Functions

Write functions modify the contract's state and therefore require blockchain transactions.

Examples include:

| Function | Purpose |
|---|---|
| `transfer()` | Transfers tokens between addresses. |
| `approve()` | Grants another address permission to spend tokens. |
| `transferFrom()` | Transfers tokens using an existing allowance. |
| `mint()` | Creates new tokens, subject to the contract's access restrictions. |

When calling a write function through Blockscout, the connected wallet must approve the transaction.

The transaction is then submitted to the network and processed by its validators.

### 3.3 Understanding Transaction Costs

State-changing transactions consume gas.

Gas represents the computational resources required to execute operations on the Ethereum network.

The transaction fee depends on the gas consumed and the network's gas price.

This is why write operations require test ETH on Sepolia.

## 4. Adding a Custom ERC-20 Token to MetaMask

### 4.1 Why Import a Custom Token?

Deploying an ERC-20 contract does not automatically make its token appear in every wallet.

Wallets need the token's contract address to identify and display its balance.

Importing a custom token allows MetaMask to recognize the deployed token and show its information.

### 4.2 Importing the Hassan Token

The general process is:

1. Open MetaMask.
2. Select the Sepolia network.
3. Open the token import option.
4. Enter the deployed ERC-20 contract address.
5. Allow MetaMask to retrieve the token information.
6. Confirm the imported token.

MetaMask can use the contract's public metadata, such as its token symbol and decimal precision, to display the asset.

### 4.3 Important Distinction

Importing a token into MetaMask does not deploy a new token or create a new smart contract.

It only adds the existing token contract to the wallet's displayed assets.

The token balances and transfers remain managed by the ERC-20 contract on the blockchain.

## 5. Contract Verification on Etherscan

### 5.1 What Is Etherscan?

Etherscan is a blockchain explorer for Ethereum networks.

It allows users to inspect blockchain activity, including:

- Blocks and transactions.
- Wallet addresses.
- Smart contract addresses.
- Token transfers.
- Verified contract source code.
- Contract events and interactions.

Etherscan provides a Sepolia testnet explorer for inspecting Sepolia blockchain data.

### 5.2 Why Verify on Etherscan?

Verifying the contract on Etherscan makes its source code publicly accessible through another widely used Ethereum explorer.

This improves transparency and helps developers and users inspect the deployed implementation.

### 5.3 Verification Workflow

The general process involves:

1. Opening the Sepolia Etherscan explorer.
2. Searching for the deployed contract address.
3. Navigating to the contract verification option.
4. Selecting the matching compiler version.
5. Providing the source code and required compiler settings.
6. Submitting the verification request.
7. Confirming that the source code has been successfully verified.

The verification process must match the original deployment configuration.

### 5.4 Blockscout vs. Etherscan

Both platforms provide blockchain exploration and smart contract verification.

| Feature | Blockscout | Etherscan |
|---|---|---|
| Blockchain exploration | Yes | Yes |
| Transaction inspection | Yes | Yes |
| Contract source verification | Yes | Yes |
| Contract interaction | Supported | Supported |
| Open-source explorer software | Yes | No |

Both explorers can help developers inspect and interact with deployed contracts, although their interfaces and supported features may differ.

## 6. The Complete Deployment Workflow

The following workflow summarizes the practical process covered during this day:

1. Prepare the Solidity contract.
2. Compile the contract in Remix IDE.
3. Connect MetaMask to Sepolia.
4. Deploy the contract.
5. Retrieve its deployed address.
6. Verify its source code on Blockscout.
7. Explore and interact with the contract.
8. Import the custom ERC-20 token into MetaMask.
9. Verify the contract on Sepolia Etherscan.

This workflow connects smart contract development with real blockchain infrastructure and wallet applications.

## 7. Key Takeaways

By completing this practical session, the following concepts were explored:

- Smart contract deployment and contract addresses.
- Ethereum test networks and Sepolia.
- Remix IDE deployment workflow.
- Contract verification and source-code transparency.
- Blockchain explorers and their capabilities.
- Reading contract data through Blockscout.
- Executing state-changing contract functions.
- Gas fees and blockchain transactions.
- Importing custom ERC-20 tokens into MetaMask.
- Verifying deployed contracts through Etherscan.
- The distinction between deploying a contract and importing a token into a wallet.

## 8. References

- [Remix IDE Documentation](https://remix-ide.readthedocs.io/)
- [Ethereum Developer Documentation](https://ethereum.org/en/developers/)
- [Sepolia Testnet](https://sepolia.etherscan.io/)
- [Blockscout Documentation](https://docs.blockscout.com/)
- [Etherscan Documentation](https://docs.etherscan.io/)
- [MetaMask Documentation](https://support.metamask.io/)
- [OpenZeppelin Contracts Documentation](https://docs.openzeppelin.com/contracts/5.x/)

---

**Day 03 completed:** Deployed the Hassan (HSN) ERC-20 token to Sepolia using Remix IDE, explored contract verification and interaction through Blockscout, imported the token into MetaMask, and verified the contract on Sepolia Etherscan.