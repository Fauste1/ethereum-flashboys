
const { expect }    = require('chai');
const { ethers }    = require("hardhat");
const helpers       = require('./utils/helpers');

describe("Exchange contract", function() {
    let alice, bob; // signers
    // let dToken, cToken; // token contract instances
    let exchange; // exchange contract instance
    let setupTokens;
    const deploymentAmount = BigInt('10000000000000000000000') // 10000 (ten thousand) with 18 decimals
    const exchangeSetupAmount = BigInt('1000000000000000000000') // 1000 (thousand) with 18 decimals

    this.beforeEach(async () => {
        // get signers
        [alice, bob] = await ethers.getSigners();
        
        // deploy token contracts
        setupTokens = await helpers.deployTokens(deploymentAmount, 2)
        // dToken = setupTokens[0]
        // cToken = setupTokens[1]

        // deploy exchange
        const Exchange = await ethers.getContractFactory("Exchange");
        exchange = await Exchange.deploy(setupTokens[0].address, setupTokens[1].address);

        // deposit setup amount of each deployed token to the exchange
        for(token of setupTokens) {
            await token.transfer(exchange.address, exchangeSetupAmount)
        }
    });

    it("should receive setup tokens", async () => {
        // let exchangeBalances = {}
        for (token of setupTokens) {
            let exchangeBalance = await token.balanceOf(exchange.address)
            expect(exchangeBalance.toString()).to.equal(exchangeSetupAmount.toString())
        }
        // exchangeBalances.cToken = await cToken.balanceOf(exchange.address);
        // expect(exchangeBalances.cToken.toString()).to.equal('1000000000000000000000');
    });

    xit("should allow basic swap", async () => {
        await exchange.swapDummyToCollateral(BigInt('10'));
        const dBalance = await dToken.balanceOf(alice.address);
        const cBalance = await cToken.balanceOf(alice.address);

        expect(dBalance.toString()).to.equal('')
    });

    xit("should allow to exploit arbitrage opportunity");
});