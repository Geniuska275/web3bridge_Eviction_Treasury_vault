# Treasury Execution System Architecture

## Overview

This project implements a **secure modular treasury execution system** that allows protocol governance to:

- Propose treasury transactions
- Delay execution using a timelock
- Verify authorization of executors
- Distribute funds to contributors
- Protect the protocol against governance attacks

The architecture follows a **modular smart contract design**, where each component has a single responsibility.  
Modules communicate through **interfaces**, making the system easier to upgrade, test, and audit.

---

# Architecture Diagram

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

---

# Project Structure

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
 │
script/
 └── DeployTreasury.s.sol
     
test/
 └── Treasury.t.sol
```

---

# Core Modules

## 1. AuthorizationManager

### Responsibility

Manages governance permissions and authorized executors.

### Features

- Governance-controlled access
- Executor whitelist
- Prevents unauthorized treasury execution

### Key Functions

```solidity
setExecutor(address executor, bool allowed)
authorizedExecutors(address executor)
```

---

## 2. ProposalManager

### Responsibility

Handles treasury transaction proposals.

Each proposal contains:

- Target contract
- ETH value
- Call data
- Execution timestamp (ETA)

### Proposal Structure

```solidity
struct Proposal {
    address target;
    uint256 value;
    bytes data;
    bool executed;
    uint256 eta;
}
```

### Key Functions

```solidity
createProposal()
proposals()
proposalCount()
```

---

## 3. TimelockController

### Responsibility

Prevents immediate execution of governance proposals.

A proposal must wait for the **minimum delay** before execution.

### Security Benefit

Protects against:

- Flash governance attacks
- Immediate treasury drains
- Malicious upgrades

### Key Functions

```solidity
validateExecution(uint256 eta)
```

---

## 4. TreasuryCore

### Responsibility

Executes approved treasury transactions.

TreasuryCore verifies:

- Executor authorization
- Proposal validity
- Timelock expiration

### Execution Flow

```
1. Verify executor authorization
2. Load proposal
3. Verify proposal not executed
4. Validate timelock delay
5. Execute call
```

### Key Function

```solidity
executeProposal(uint256 proposalId)
```

---

## 5. ContributorDistributor

### Responsibility

Handles contributor rewards.

The system uses the **pull payment model**, where contributors claim rewards themselves.

### Security Advantages

- Prevents reentrancy issues
- Avoids failed bulk payouts
- Reduces gas cost risks

### Key Functions

```solidity
addReward(address contributor, uint256 amount)
claim()
```

---

# Interfaces

All modules interact using **interfaces** to ensure modularity.

Interfaces are located in:

```
src/interfaces/
```

Example interfaces:

```
IAuthorizationManager
IProposalManager
ITimelockController
IContributorDistributor
```

Benefits:

- Loose coupling
- Upgrade flexibility
- Easier testing with mocks

---

# Libraries Used

The project integrates libraries from **OpenZeppelin** to improve security.

Libraries include:

- ReentrancyGuard
- SafeERC20
- AccessControl
- Address


---

# Governance Execution Flow

### Step 1 — Create Proposal

Governance submits a proposal.

```solidity
createProposal(target, value, data, eta)
```

---

### Step 2 — Timelock Delay

Proposal must wait until:

```
block.timestamp >= eta
```

---

### Step 3 — Authorized Executor Executes

Executor calls:

```solidity
executeProposal(proposalId)
```

---

### Step 4 — Treasury Transaction Runs

The treasury executes the encoded transaction.

---

### Step 5 — Contributor Rewards Distributed

Governance allocates rewards:

```solidity
addReward(contributor, amount)
```

Contributor claims reward:

```solidity
claim()
```

---

# Security Design

The system implements multiple layers of protection.

## Timelock Protection

Prevents instant governance actions.

## Executor Authorization

Only approved executors can trigger treasury execution.

## Pull Payment Model

Prevents reentrancy and gas griefing.

## Modular Design

Limits the impact of a compromised module.

---

# Attack Mitigation

| Attack | Mitigation |
|------|------|
| Instant treasury drain | Timelock delay |
| Unauthorized execution | AuthorizationManager |
| Reentrancy payout | Pull payment model |
| Hidden transactions | Proposal registry |
| Governance takeover | Execution delay |

---

# Testing Strategy

The system includes **Foundry tests** that verify:

- Proposal creation
- Timelock enforcement
- Authorized execution
- Contributor reward claims

Tests are located in:

```
test/Treasury.t.sol
```

Run tests using:

```
forge test
```

---

# Deployment

Deployment is handled via a **Foundry script**.

Location:

```
script/DeployTreasury.s.sol
```

Run deployment:

```
forge script script/DeployTreasury.s.sol \
--rpc-url <RPC_URL> \
--private-key <PRIVATE_KEY> \
--broadcast
```

---

# Future Improvements

Potential upgrades include:

- Governance voting (Governor contract)
- Multi-signature execution
- Batched treasury transactions
- Token treasury support (ERC20)
- Proposal cancellation
- Emergency pause functionality

---

# Summary

This treasury architecture provides:

- Modular design
- Secure governance execution
- Timelock protection
- Safe contributor payouts
- Interface-driven modules
- Foundry deployment and testing

The system is designed to be **auditable, extensible, and secure for decentralized protocol governance**.