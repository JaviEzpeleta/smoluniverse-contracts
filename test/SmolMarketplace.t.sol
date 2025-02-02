// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SmolMarketplace} from "../contracts/SmolMarketplace.sol";
import {SmolNFT} from "../contracts/SmolNFT.sol";
import {SmolUniverseCoin} from "../contracts/SmolUniverseCoin.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract SmolMarketplaceTest is Test {
    uint256 constant INITIAL_BALANCE = 10 ether;

    SmolMarketplace public marketplace;
    SmolNFT public nft;
    SmolUniverseCoin public paymentToken;
    address public owner;
    address public buyer;
    address public nftOwner;

    function setUp() public {
        owner = address(this);
        nftOwner = address(0x321);
        buyer = address(0x123);

        vm.startPrank(owner);
        paymentToken = new SmolUniverseCoin();
        nft = new SmolNFT();
        marketplace = new SmolMarketplace(address(paymentToken));

        paymentToken.mintAndApprove(buyer, INITIAL_BALANCE, address(marketplace));

        nft.mintAndApprove(nftOwner, address(marketplace), "Random description", "@me", "https://example.com/nft1");
        vm.stopPrank();
    }

    function testListNFT() public {
        uint256 nftPrice = 100 ether;

        vm.prank(owner);
        marketplace.listNFT(address(nft), 0, nftPrice, nftOwner);

        (address seller, uint256 price, bool active) = marketplace.listings(0);
        assertEq(seller, nftOwner);
        assertEq(price, nftPrice);
        assertTrue(active);
    }

    function testBuyNFT() public {
        uint256 nftPrice = 1 ether;

        vm.prank(owner);
        marketplace.listNFT(address(nft), 0, nftPrice, nftOwner);

        vm.prank(owner);
        marketplace.buyNFT(address(nft), 0, buyer);

        assertEq(nft.ownerOf(0), buyer);
        assertEq(paymentToken.balanceOf(nftOwner), nftPrice);
        assertEq(paymentToken.balanceOf(buyer), INITIAL_BALANCE - nftPrice);

        (,, bool active) = marketplace.listings(0);
        assertFalse(active);
    }

    function testCannotListNFTWithZeroPrice() public {
        vm.prank(owner);
        vm.expectRevert("Price must be greater than 0");
        marketplace.listNFT(address(nft), 0, 0, nftOwner);
    }

    function testCannotBuyNFTNotForSale() public {
        vm.prank(owner);
        vm.expectRevert("NFT not for sale");
        marketplace.buyNFT(address(nft), 0, buyer);
    }

    function testCannotBuyNFTWithInsufficientFunds() public {
        vm.prank(owner);
        marketplace.listNFT(address(nft), 0, INITIAL_BALANCE + 1, nftOwner);

        vm.prank(owner);
        vm.expectRevert("Insufficient funds");
        marketplace.buyNFT(address(nft), 0, buyer);
    }

    function testTokenURI() public {
        string memory description = "Random description";
        string memory handle = "@me";
        string memory imageUri = "https://example.com/nft1";

        vm.prank(owner);
        nft.mintAndApprove(buyer, owner, description, handle, imageUri);

        string memory expectedTokenURI = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "SmolNFT", "description": "',
                            description,
                            '", "attributes": [',
                            '{"trait_type": "handle", "value": "',
                            handle,
                            '"}',
                            '], "image":"',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );

        string memory actualTokenURI = nft.tokenURI(0);
        assertEq(actualTokenURI, expectedTokenURI);
    }
}
