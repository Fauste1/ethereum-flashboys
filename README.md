This is a practice "ecosystem" for issuing a loan based on a deposited collateral and using the borrowed funds for further trading, including basic flashloan functionality.

Note that there are many backdoors and not yet resolved loopholes that allow anybody to drain nearly any balance of the bank / exchange / token holder. These may or may not be fixed in the future. 

The goal is not to build a functional production ready protocol for use with real world money. The goal is to practice and test some mechanisms that I've learned over the past few days.

Feel free to fork & modify, but only at your own risk :)

Deployment notes:
- the tokens that are currently being used are ERC-20 compliant, including stuff like allowance etc. Make sure you give the exchange and the bank enough allowance before you start interacting with the "dapps"
- also make sure you load up the dapps with tokens before you start interacting with them