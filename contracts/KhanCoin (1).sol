// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);    
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);    
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);    
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);    

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract ERC20 is IERC20{

    address owner;
    string name_ ;
    string symbol_;
    uint8 decimals_;
    uint256 tSupply;
    mapping (address => uint256) balances;

    //event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor (string memory _name, string memory _symbol,
                    uint8 _decimals) {
        name_ = _name;
        symbol_ = _symbol;
        decimals_ = _decimals;
        //tSupply = _tSupply;
        //balances[msg.sender] = tSupply;
        owner = msg.sender; // deployer
    }
    function name() public view returns (string memory){
        return name_;
    }
    function symbol() public view returns (string memory){
        return symbol_;
    }
    function decimals() public view returns (uint8){
        return decimals_;
    }

    function totalSupply() public view override returns (uint256){
        return tSupply;
    }
    function balanceOf(address _owner) public view override returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public override returns (bool success){
        require(balances[msg.sender]>=_value,"ERROR: Not enough balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        //a = a+b is same as  a+=b
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    uint8 brokerage;
    function setBrokerage(uint8 _num)public {
        require( msg.sender == owner, "Error : Only Owner");
        require( _num<=100, "Error : Unrealistic");
        brokerage = _num;
    }
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(balances[_from]>=_value,"ERROR: Not enough balance");
        require(allowed[_from][msg.sender]>= _value, "Error ::: Not enough allowance available");
        balances[_from] -= _value*(100+brokerage)/100;
        balances[_to] += _value;
        balances[msg.sender] += _value*brokerage/100;
        allowed[_from][msg.sender]-=_value;
        emit Transfer(_from, _to, _value);
        return true;
        
    }
    mapping(address=>mapping(address => uint256)) allowed;
    // Owner => Spender => Allowance
    //event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval (msg.sender,_spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return allowed[_owner][_spender];    
    }
    // Increase & Decrease allowance
    function increaseAllowance(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] += _value;
        emit Approval (msg.sender,_spender, _value);
        return true;
    }
    function decreaseAllowance(address _spender, uint256 _value) public returns (bool success) {
        // Must check if _value of allowance is remaining or not.
        uint rem = allowed[msg.sender][_spender];
        require(rem>=_value, "Error : Not enough allowance to decrease");
        allowed[msg.sender][_spender] -= _value;
        emit Approval (msg.sender,_spender, _value);
        return true;
    }
    // Mint & Burn tokens.
    function mint (uint256 _inc, address _addr) public {
        require(owner == msg.sender, "Only owner");
        // Increase total supply
        tSupply += _inc;
        // Allocate this inc to some wallet. (owner)
        balances[_addr] += _inc;

    }

    function burn (uint256 _inc, address _addr) public {
        require(owner == msg.sender, "Only owner");
        uint bal = balances[_addr];
        require(bal>=_inc, "Not enough tokens to burn");
        // Increase total supply
        tSupply -= _inc;
        // Allocate this inc to some wallet. (owner)
        balances[_addr] -= _inc;

    }

        
}

contract ClientToken2 is ERC20 {

    constructor(uint256 _totalQty) ERC20("KhanCoin2","KHC2",0) {    
        mint(_totalQty,msg.sender);
        // mint(_totalQty/2,_coOwner);
        // coOwner = _coOwner;
    }       
    address coOwner;

    function bulkTransfer(address[] memory _addr, uint256[] memory _salary) public returns(bool){
        // some code here

    }

}


