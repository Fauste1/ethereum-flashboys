
async function deployTokens(amount, numberOfTokens) {
    const TokenFactory  = await ethers.getContractFactory("Token")
    let tokenMeta       = [
        {name: 'AToken', symbol: 'ATO'},
        {name: 'BToken', symbol: 'BTO'},
        {name: 'CToken', symbol: 'CTO'},
        {name: 'DToken', symbol: 'DTO'}
    ]
    let tokens          = []

    for (let i = 0; i < numberOfTokens; i++) {
        let newToken = await TokenFactory.deploy(amount, tokenMeta[i].name, tokenMeta[i].symbol)
        tokens.push(newToken)
    }
    
    return tokens;
}

module.exports = {
    deployTokens
}