# Modular Treasury Execution System

## Overview

This project implements a **secure and modular treasury execution system** for decentralized governance.  

The treasury allows protocol governance to:

- Propose treasury transactions
- Delay execution using a timelock
- Verify executor authorization
- Distribute funds to contributors safely
- Prevent governance and reentrancy attacks


## Features

- **Governance Proposal System:** Proposals include target contract, value, data, and execution timestamp (ETA)
- **Timelock Protection:** Prevents instant execution of governance transactions
- **Role-Based Access Control:** Managed via OpenZeppelin `AccessControl`
- **Pull Payment Model:** Contributors claim rewards themselves to prevent reentrancy
- **Modular Interfaces:** Loose coupling allows upgrades and easier testing
- **Audited Libraries:** Uses OpenZeppelin’s `ReentrancyGuard`,`AccessControl`

---

## Architecture

```
                Governance
                     │
                     ▼
            AuthorizationManager
                     │
                     ▼
              ProposalManager
                     │
                     ▼
              TimelockController
                     │
                     ▼
                 TreasuryCore
                     │
                     ▼
          ContributorDistributor
```

### Core Modules

| Module | Responsibility |
|--------|----------------|
| `AuthorizationManager` | Manages executor and reward manager roles |
| `ProposalManager` | Handles creation and storage of treasury proposals |
| `TimelockController` | Enforces execution delays for proposals |
| `TreasuryCore` | Executes approved treasury transactions |
| `ContributorDistributor` | Manages contributor rewards and claims |

---

## Interfaces

All modules interact via **interfaces** to ensure modularity:

- `IAuthorizationManager`
- `IProposalManager`
- `ITimelockController`
- `IContributorDistributor`

Benefits:

- Loose coupling and modular upgrades
- Easier testing with mock contracts
- Cleaner separation of concerns

---

## Security

- **Access Control:** Uses OpenZeppelin `AccessControl` roles to limit who can execute proposals or add rewards
- **Timelock Delay:** Prevents flash governance attacks
- **Pull Payment Model:** Contributors claim rewards themselves, protecting against reentrancy
- **Safe Transfers:** ETH via `call{value: amount}("")` and ERC20 via `SafeERC20`
- **ReentrancyGuard:** Protects sensitive functions

For detailed security practices, see [SECURITY.md](SECURITY.md).

---

## Getting Started

### Requirements

- **Solidity 0.8.x**
- **Foundry** for building and testing
- Node.js and npm if running scripts with Hardhat (optional)

---

### Installation (Foundry)

```bash
# Install dependencies
forge install OpenZeppelin/openzeppelin-contracts
forge install transmissions11/solmate

# Build contracts
forge build
```

---

### Deployment

A Foundry deployment script is provided: `script/DeployTreasury.s.sol`

```bash
forge script script/DeployTreasury.s.sol \
--rpc-url <RPC_URL> \
--private-key <PRIVATE_KEY> \
--broadcast
```

---

### Running Tests

All tests are written in **Foundry** and located in `test/Treasury.t.sol`.

```bash
forge test
```

Tests cover:

- Proposal creation and storage
- Timelock enforcement
- Executor role check
- Contributor reward allocation and claims

---

## Usage Examples

### Granting Roles

```solidity
auth.grantRole(auth.EXECUTOR_ROLE(), executorAddress);
auth.grantRole(auth.REWARD_MANAGER_ROLE(), distributorAddress);
```

### Creating a Proposal

```solidity
proposalManager.createProposal(
    targetContract,
    valueInWei,
    encodedData,
    etaTimestamp
);
```

### Executing a Proposal

```solidity
treasury.executeProposal(proposalId);
```

### Adding Contributor Rewards

```solidity
distributor.addReward(contributorAddress, rewardAmount);
```

### Claiming Rewards

```solidity
distributor.claim();
```

---

## Project Structure

```
src/
 ├── core/
 │    └── TreasuryCore.sol
 │
 ├── modules/
 │    ├── AuthorizationManager.sol
 │    ├── ProposalManager.sol
 │    ├── TimelockController.sol
 │    └── ContributorDistributor.sol
 │
 ├── interfaces/
 │    ├── IAuthorizationManager.sol
 │    ├── IProposalManager.sol
 │    ├── ITimelockController.sol
 │    └── IContributorDistributor.sol
script/
 └── DeployTreasury.s.sol
test/
 └── Treasury.t.sol
```




