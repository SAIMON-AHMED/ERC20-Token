# ERC20-Token

The ERC-20 introduces a standard for Fungible Tokens, in other words, they have a property that makes each Token be exactly the same (in type and value) as another Token. For example, an ERC-20 Token acts just like the ETH, meaning that 1 Token is and will always be equal to all the other Tokens.

Your task in this problem is to create your own ERC-20 token following the EIP-20 standard. The price of a token is calculated as total TOKENs in circulation * 0.001 ETH.

Let's say there are currently 100 TOKENs in supply, if Alice wants to mint 2 TOKENs, she'll have to pay (100 * 0.01 + 101 * 0.01) ETH.

(NOTE: The deployer is made the owner)

Your smart contract must include the following public functions / constructor:
 

Input:
constructor(string name, string symbol) : Constructor sets the name and symbol for the ERC-20 token.

mint(address to, uint256 amount) : This function allows the owner to mint amount of tokens to to.

burn(uint256 amount): This function allows the sender to burn their tokens. Function should revert if they have less than amount .

batchMint(address[] _to, uint256[] _amounts): This allows the owner to mint tokens to multiple accounts. _amounts[i] is minted to _to[i]. This function must revert if lengths of the two arrays do not match, and if the arrays are empty.

publicMint(uint256 amount): This allows sender to mint TOKENs by sending ETH. The price is determined by the above mentioned rules. If amount is 0, the function must revert.

blacklistUser(address user): This function allows the owner to blacklist a user. All the tokens user has must be burned. If the user is already blacklisted, the function must revert. A blacklist user cannot own any tokens ever.

 

Output:
name() returns (string): This function returns the name of the token (provided).

symbol() returns (string):This function returns the symbol of the token (provided).

balanceOf(address user) returns (uint256):This function returns the balance of the user.
