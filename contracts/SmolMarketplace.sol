// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SmolNFT} from "./SmolNFT.sol";
import {SmolUniverseCoin} from "./SmolUniverseCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SmolMarketplace is Ownable, ReentrancyGuard {
    event NFTListed(
        address indexed nft,
        uint256 indexed tokenId,
        address seller,
        uint256 price
    );
    event NFTSold(
        address indexed nft,
        uint256 indexed tokenId,
        address buyer,
        uint256 price
    );

    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }

    SmolUniverseCoin public paymentToken;
    mapping(uint256 tokenId => Listing listing) public listings;

    constructor(address _paymentToken) Ownable(msg.sender) {
        paymentToken = SmolUniverseCoin(_paymentToken);
    }

    function listNFT(
        address nft,
        uint256 tokenId,
        uint256 price,
        address seller
    ) external onlyOwner nonReentrant {
        require(price > 0, "Price must be greater than 0");

        SmolNFT smolNft = SmolNFT(nft);
        require(smolNft.ownerOf(tokenId) == seller, "Not the owner");

        listings[tokenId] = Listing(seller, price, true);
        emit NFTListed(nft, tokenId, msg.sender, price);
    }

    function buyNFT(
        address nft,
        uint256 tokenId,
        address buyer
    ) external onlyOwner nonReentrant {
        Listing memory listing = listings[tokenId];
        require(listing.active, "NFT not for sale");
        require(
            paymentToken.balanceOf(buyer) >= listing.price,
            "Insufficient funds"
        );

        require(
            paymentToken.transferFrom(buyer, listing.seller, listing.price),
            "Payment error"
        );

        SmolNFT(nft).safeTransferFrom(listing.seller, buyer, tokenId);

        delete listings[tokenId];

        emit NFTSold(nft, tokenId, msg.sender, listing.price);
    }
}
