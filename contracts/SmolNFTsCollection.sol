// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract SmolNFTsCollection is ERC721, ERC721URIStorage, Ownable {
    using Strings for uint256;

    struct NFTData {
        string imageURI;
        string title;
    }

    mapping(uint256 => NFTData) private _nftData;
    uint256 private _nextTokenId = 1;

    constructor() 
        ERC721("SmolSmolNFTsCollectionTEESSST", "SCN") 
        Ownable(msg.sender) 
    {}

    function mintSmolNFTsCollection(
        address cloneAddress,
        string memory imageURI,
        string memory title
    ) external onlyOwner {
        uint256 tokenId = _nextTokenId++;
        
        _mint(cloneAddress, tokenId);
        _nftData[tokenId] = NFTData(imageURI, title);
        
        _setTokenURI(tokenId, _buildTokenURI(imageURI, title));
    }

    function _buildTokenURI(
        string memory imageURI, 
        string memory title
    ) internal pure returns (string memory) {
        bytes memory json = abi.encodePacked(
            '{"name": "', title, '",',
            '"image": "', imageURI, '",',
            '"description": "AI-generated NFT from SmolUniverse"}'
        );
        
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(json)
            )
        );
    }

    // Funciones override requeridas
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}