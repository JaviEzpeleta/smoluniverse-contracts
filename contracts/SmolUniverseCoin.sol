// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SmolUniverseCoin is ERC20, Ownable {
    constructor() ERC20("SmolUniverseCoin", "SMOL") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000_000_000_000 * 10 ** decimals()); // 1 quadrillion SMOLs
    }

    function mintAndApprove(
        address to,
        uint256 amount,
        address spender
    ) external onlyOwner {
        _mint(to, amount);
        _approve(to, spender, amount);
    }
}
