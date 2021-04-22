# SmartContracts
---
## Task A:
Create the dApp (only smart-contracts part), where user could create a project with (name, description) and issue shares for this project.
All created projects store on market, where users could get project info, get price for project share, get available count of shares, buy shares using ETH, sell shares.

## Stack:
    Ethereum (ropstan/kovan)
    Truffle
    ganache-cli
    Solidity
## Dependencies install

### _node & npm_ & truffle

<https://github.com/nvm-sh/nvm>

To install and use node LTS version:

```
npm install -g truffle
```

## _Install_

---

```bash
$ npm i
```

## _Tests_

---

To run tests:

Start development blockchain with run `$ truffle test`


---
## How to use:
### Create Market
Use ***deployed***
### Create Project
Use method ***createProject(string memory name, string memory description, uint price, uint256 amount)*** by ***Market*** 
### Buy Shares
Use ***buyShares(string memory name, uint tokenAmount)*** by ***Market*** 
### Buy Shares
Use ***approve(address MarketAddress, uint selltokenAmount)*** by ***Project*** 

Use ***sellShares(string memory name, uint selltokenAmount)*** by ***Market*** 

## Methods:

**getProjectAddress(string memory name)** - ***return Project address by name;***

**getProjectDescription(string memory name)** - ***return Project description by name;***

**getProjectOwner(string memory name)** - ***return Project owner by name;***

**getPrice(string memory name)** - ***return Project count Wei for 1 share by name;***

**getSharesCount(string memory name)** - ***return available count of shares by name;***

## How deploy to TestNet

> 1. Create project on [Infura](https://infura.io/dashboard)
> 2. Create your wallet with 2+ ETH for transactions & Get mnemonic
> 3. In truffle-config.js

* set your mnemonic(12 word)
* set ropsten ENDPOINT from Infura (https://ropsten.infura.io/v3/<ProjectID>)
    
> 4. Delete folder 'build'
> 5. In Terminal your Project insert:

* $ truffle compile
* $ truffle deploy --network ropsten
* **contract address you can get from console after successful deploy**

> 6. File 'build/contracts/NameofContract.json' it's your deploy Contract!
