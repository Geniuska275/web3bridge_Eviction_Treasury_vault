# Security Policy for Treasury Execution System

## 1. Security Overview

This project implements a **modular and secure treasury system** for decentralized governance.  

The design incorporates multiple security layers:

- **Access control** with OpenZeppelin `AccessControl` roles ( `EXECUTOR_ROLE`)  
- **Timelock delay** to prevent instant execution of proposals  
- **Pull payment model** for contributor rewards to prevent reentrancy attacks  
- **Modular interfaces** for loose coupling and upgradeability  
- **Use of audited libraries**: OpenZeppelin `ReentrancyGuard`, `AccessControl`  


##  Security Best Practices

### 1 Access Control

- Use `AccessControl` roles to separate responsibilities:
  - `DEFAULT_ADMIN_ROLE` – Governance and emergency admin
  - `EXECUTOR_ROLE` – Authorized executors for proposal execution

### 2 Timelock Enforcement

- All treasury executions must respect the **timelock delay**  
- Prevents **flash governance attacks** and immediate fund drains

### 3 Pull Payment Model

- Contributors claim rewards themselves via `claim()`  
- Prevents **reentrancy attacks** and failed batch payments  
- Use `ReentrancyGuard` on `claim()` and other ETH transfer functions

###  Proposal Validation

- Only **authorized executors** can execute proposals  
- Cannot execute **already executed proposals**  
- Timelock validation ensures proper ETA before execution


