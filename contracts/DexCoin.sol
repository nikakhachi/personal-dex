// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DexCoin is ERC20 {
    constructor(
        uint256 _initialSupply,
        address _dexAddress
    ) ERC20("DexCoin", "DXCO") {
        _mint(_dexAddress, _initialSupply);
    }
}
