// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SmolNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    constructor() ERC721("SmolNFT", "SNFT") Ownable(msg.sender) {}

    function mintAndApprove(
        address to,
        string memory tokenURI,
        address spender
    ) external onlyOwner {
        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, tokenURI);
        _approve(spender, nextTokenId, address(0), false);
        nextTokenId++;
    }
}
