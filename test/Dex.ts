import { ethers } from "hardhat";
import { expect } from "chai";

describe("Dex", () => {
  const initialRandomBaseTokenSupply = 2000;
  const initialRandomQuoteTokenSupply = 1000;
  const initialDexCoinSupply = 1000;

  async function deployDexFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const Dex = await ethers.getContractFactory("Dex");
    const dex = await Dex.deploy();

    const DexCoin = await ethers.getContractFactory("DexCoin");
    const dexCoin = await DexCoin.deploy(ethers.utils.parseUnits(String(initialDexCoinSupply)), dex.address);

    const RandomBaseToken = await ethers.getContractFactory("RandomBaseToken");
    const randomBaseToken = await RandomBaseToken.deploy(ethers.utils.parseUnits(String(initialRandomBaseTokenSupply)), dex.address);

    const RandomQuoteToken = await ethers.getContractFactory("RandomQuoteToken");
    const randomQuoteToken = await RandomQuoteToken.deploy(ethers.utils.parseUnits(String(initialRandomQuoteTokenSupply)), dex.address);

    return { randomBaseToken, owner, otherAccount, randomQuoteToken, dex, dexCoin };
  }
  it("Should Work", async () => {
    const { randomBaseToken, randomQuoteToken, dex, owner, otherAccount, dexCoin } = await deployDexFixture();

    await dex.registerTradingPair(randomBaseToken.address, randomQuoteToken.address);

    const randomBaseTokenSymbol = await randomBaseToken.symbol();
    const randomQuoteTokenSymbol = await randomQuoteToken.symbol();

    const tradingPairName = `${randomBaseTokenSymbol}${randomQuoteTokenSymbol}`;
    const tradingPair = await dex.tradingPairs(tradingPairName);

    expect(tradingPair.base).to.eq(randomBaseToken.address);
    expect(tradingPair.quote).to.eq(randomQuoteToken.address);

    const amount = 10;

    await randomBaseToken.approve(dex.address, ethers.utils.parseUnits(String(amount)));
    await dex.trade(tradingPairName, ethers.utils.parseUnits(String(amount)));

    // expect(Number(ethers.utils.formatUnits(await randomBaseToken.balanceOf(owner.address)))).to.eq(initialRandomBaseTokenSupply - amount);
    // expect(Number(ethers.utils.formatUnits(await randomBaseToken.balanceOf(dex.address)))).to.eq(amount);
    // expect(Number(ethers.utils.formatUnits(await randomQuoteToken.balanceOf(owner.address)))).to.eq(amount);
    // expect(Number(ethers.utils.formatUnits(await randomQuoteToken.balanceOf(dex.address)))).to.eq(initialRandomQuoteTokenSupply - amount);
  });
});
