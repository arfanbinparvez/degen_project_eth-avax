// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    uint256 public constant REDEMPTION_RATE = 100;

    struct ItemOwnership {           //items owned are mapped to the id or name of the item 
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