// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SmolNFT is ERC721, Ownable {
    uint256 public nextTokenId;

    constructor() ERC721("SmolNFT", "SNFT") Ownable(msg.sender) {}

    function mint(address to, string memory tokenURI) external onlyOwner {
        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, tokenUri);
        nextTokenId++;
    }
}
