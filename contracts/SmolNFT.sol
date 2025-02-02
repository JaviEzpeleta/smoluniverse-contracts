// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract SmolNFT is ERC721URIStorage, Ownable {
    struct TokenMetadata {
        string description;
        string handle;
        string imageUri;
    }

    uint256 public nextTokenId;

    mapping(uint256 tokenId => TokenMetadata metadata) private tokenMetadata;

    constructor() ERC721("SmolNFT", "SNFT") Ownable(msg.sender) {}

    function mintAndApprove(
        address to,
        address spender,
        string memory description,
        string memory handle,
        string memory imageUri
    ) external onlyOwner {
        _safeMint(to, nextTokenId);
        _approve(spender, nextTokenId, address(0), false);
        tokenMetadata[nextTokenId] = TokenMetadata(description, handle, imageUri);
        nextTokenId++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        TokenMetadata memory metadata = tokenMetadata[tokenId];

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "SmolNFT", "description": "',
                            metadata.description,
                            '", "attributes": [',
                            '{"trait_type": "handle", "value": "',
                            metadata.handle,
                            '"}',
                            '], "image":"',
                            metadata.imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
