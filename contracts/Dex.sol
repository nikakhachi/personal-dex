// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dex is Ownable {
    struct TradingPair {
        ERC20 base;
        ERC20 quote;
    }

    uint32 public baseTradingFee = 10; // 10 = 1%

    mapping(string => TradingPair) public tradingPairs;
    string[] public tradingPairList;

    function registerTradingPair(ERC20 _base, ERC20 _quote) public onlyOwner {
        string memory baseSymbol = _base.symbol();
        string memory quoteSymbol = _quote.symbol();
        string memory tradingPairName = string.concat(baseSymbol, quoteSymbol);

        tradingPairs[tradingPairName] = TradingPair(_base, _quote);
        tradingPairList.push(tradingPairName);
    }

    function trade(string calldata _pairName, uint256 _amountIn) public {
        TradingPair memory pair = tradingPairs[_pairName];

        pair.base.transferFrom(msg.sender, address(this), _amountIn);

        uint amountInWithFee = (_amountIn * (1000 - baseTradingFee)) / 1000;

        uint amountOut = (pair.quote.balanceOf(address(this)) *
            amountInWithFee) /
            (pair.base.balanceOf(address(this)) + amountInWithFee);

        pair.quote.transfer(msg.sender, amountOut);
    }

    function price(string calldata _pairName) public view returns (uint) {
        TradingPair memory pair = tradingPairs[_pairName];
        return
            (pair.quote.balanceOf(address(this)) * 10 ** 18) /
            (pair.base.balanceOf(address(this)) + 10 ** 18);
    }

    function getLiquidityPool(
        string calldata _pairName
    ) public view returns (uint, uint) {
        TradingPair memory pair = tradingPairs[_pairName];

        return (
            pair.base.balanceOf(address(this)),
            pair.quote.balanceOf(address(this))
        );
    }

    // function addLiquidity(
    //     string calldata _pairName,
    //     uint _baseAmountIn,
    //     uint _quoteAmountIn
    // ) {
    //     require(_baseAmountIn > 0 && _quoteAmountIn > 0);
    //     TradingPair memory pair = tradingPairs[_pairName];

    //     // TODO
    //     // TODO First should make sure to regulate ratio to avoid price manipulations
    //     pair.base.transferFrom(msg.sender, address(this), _baseAmountIn);
    //     pair.quote.transferFrom(msg.sender, address(this), _quoteAmountIn);
    // }
}
