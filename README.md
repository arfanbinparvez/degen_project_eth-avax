# degen_project_eth-avax

This Solidity program is a simple program that demonstrates the creation of the ERC20 token "Degen". We can track the deployed contract's transactions using our contract address on the "Snowtrace Testnet" tool.
## Description

This program is a simple contract written in Solidity, a programming language used for developing smart contracts on the Ethereum blockchain. Here, I have named my token "Degen" and taken its symbol as "DGN". You can use any name and symbol of your own choice.

## Getting Started

### Executing program

You can use Remix, an online Solidity IDE to run this program. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., HelloWorld.sol). Copy and paste the following code into the file:

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    uint256 public constant REDEMPTION_RATE = 100;

    struct ItemOwnership {
        uint256 quantity;
    }

    mapping(address => mapping(uint256 => ItemOwnership)) public itemsOwned;

    struct GameItem {
        string name;
        uint256 cost; 
        uint256 id; 
    }

    GameItem[] public gameItems;
    uint256 public itemIdCounter; 

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _mint(msg.sender, 0);
        itemIdCounter = 0; 
    }

    function redeemTokens(uint256 itemId, uint256 quantity) public {
        require(itemId < itemIdCounter, "Invalid item ID");
        GameItem memory item = gameItems[itemId];
        uint256 cost = item.cost * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem for an item");

        itemsOwned[msg.sender][itemId].quantity += quantity;
        _burn(msg.sender, cost);
    }

    function checkTokensOwned(address user, uint256 itemId) public view returns (uint256) {
        return itemsOwned[user][itemId].quantity;
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address to, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to transfer");
        _transfer(msg.sender, to, amount);
    }

    function addGameItem(string memory name, uint256 cost) public onlyOwner {
        GameItem memory item = GameItem(name, cost, itemIdCounter);
        gameItems.push(item);
        itemIdCounter++; 
    }

    function getGameItems() public view returns (GameItem[] memory) {
        return gameItems;
    }
}


```

To compile the code, click the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.4" (or another compatible version), and then click on the "Compile ERC20.sol" button.

Once the code is compiled, you can deploy the contract by connecting your Metmask with Remix IDE by selecting "Injected Provider Metamask" in the environment field of the DEPLOY section.

Once the contract is deployed, you can interact with it by calling functions defined in the code above.
## Authors

Arfan Mohd
