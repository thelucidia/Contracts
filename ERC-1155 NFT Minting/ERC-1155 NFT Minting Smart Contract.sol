// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/utils/Counters.sol";

contract NonTransferableNFT is ERC1155, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 public constant MAX_SUPPLY = 10000;
    mapping(address => bool) public hasMinted; // Track if an address has already minted

    constructor() ERC1155("https://ipfs.io/ipfs/QmbQyg4sieJxxvhDggUMLw3iAK9UENi538WwNLXDKhB9Bo") {
    }

    function mint() public {
        require(!hasMinted[msg.sender], "Address has already minted.");
        uint256 currentTokenId = _tokenIdCounter.current();
        require(currentTokenId < MAX_SUPPLY, "Exceeds maximum supply");

        _mint(msg.sender, currentTokenId, 1, "");
        _tokenIdCounter.increment();
        hasMinted[msg.sender] = true; // Mark this address as having minted
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        require(from == address(0) || to == address(0), "Transfer not allowed");
    }
}
