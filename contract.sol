// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Implement the ERC-20 smart contract.
contract Token {

    string public name;
    string public symbol;
    address private owner;
    uint256 constant PRICE_PER_TOKEN = 0.001 ether;

    uint256 totalTokenSupply;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;
    mapping(address => bool) blacklisted;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyNotBlacklisted {
        require(!blacklisted[msg.sender], "This user is in the blacklist.");
        _;
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        require(!blacklisted[_to], "This address is in the blacklist.");
        _mint(_to, _amount);
    }

    function _mint(address _to, uint256 _amount) internal {
        balances[_to] += _amount;
        totalTokenSupply += _amount;
    }

    function burn(uint256 amount) public onlyNotBlacklisted {
        require(balances[msg.sender] >= amount, "Not enough amount to burn");
        balances[msg.sender] -= amount;
        totalTokenSupply -= amount;
    }

    function batchMint(address[] calldata _to, uint256[] calldata _amounts) external onlyOwner {
        require(_to.length == _amounts.length, "Unequal length");
        require(_to.length > 0, "Empty arrays are not allowed");
        for (uint256 i = 0; i < _to.length; i++) {
            _mint(_to[i], _amounts[i]);
        }
    }

    function publicMint(uint256 amount) public payable {
        require(!blacklisted[msg.sender], "You are in the blacklist.");
        require(amount > 0, "Amount must be more than zero");
        require(msg.value ==  1000000000000000 * (amount * ((2 * totalTokenSupply) + (amount - 1)))/2);


        _mint(msg.sender, amount);
        
    }

    function blacklistUser(address user) public onlyOwner {
        require(!blacklisted[user], "This user is already blacklisted");
        blacklisted[user] = true;
        totalTokenSupply -= balances[user];
        balances[user] = 0;
    }

    function balanceOf(address user) public view returns (uint256) {
        return balances[user];
    }

    function totalSupply() public view returns (uint256) {
        return totalTokenSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(balances[msg.sender] >= _value, "Not enough balance to transfer.");
        balances[_to] += _value;
        balances[msg.sender] -= _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        require(allowances[_from][msg.sender] >= _value, "ERC20: transfer amount exceeds allowance");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }

}
