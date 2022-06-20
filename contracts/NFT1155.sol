// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestNFT is ERC1155, Ownable {
  
  string public name;
  string public symbol;
  uint256 public mintRate = 0.05 ether;
  uint256[] public minted = [0];
  uint256[] public supplies = [10];
  mapping(uint => string) public tokenURI;

  constructor() ERC1155("") {
    name = "TestNFT";
    symbol = "TEST";
  }

  function mint(uint _id, uint _amount) payable public {
    require(_id <=supplies.length,"Token doesn't exist");
    require(_id > 0, "Token doesn't exist");
    require(msg.value >= (_amount * mintRate), "Insufficient amount sent");
    require(minted[_id-1]+_amount <= supplies[_id-1], "Exceeds max supply");

    _mint(msg.sender, _id, _amount, "");
    minted[_id-1] += _amount;
  }

  function setURI(uint _id, string memory _uri) external onlyOwner {
    tokenURI[_id] = _uri;
    emit URI(_uri, _id);
  }

  function uri(uint _id) public override view returns (string memory) {
    return tokenURI[_id];
  }
  function addNewCollectionSupply(uint _totalCount) external onlyOwner{
      supplies.push(_totalCount);
      minted.push(0);
  }

}