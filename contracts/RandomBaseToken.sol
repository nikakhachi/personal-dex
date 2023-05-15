// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RandomBaseToken is ERC20 {
    constructor(
        uint256 _initialSupply,
        address _dexAddress
    ) ERC20("RandomBase", "BASE") {
        _mint(msg.sender, _initialSupply / 2);
        _mint(_dexAddress, _initialSupply / 2);
    }
}
