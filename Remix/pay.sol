//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Minter{
    address public minter;
    mapping(address=>uint) public balances;
    // address user;

    constructor(){
        minter=msg.sender;
    }

    event Sent(address from, address to, uint amount);



    function mintNew(address receiver,uint amount) public{
        require(msg.sender==minter,"Only minter can create new coins");
        balances[receiver]+=amount;
    }

    error InsufficientBalance(uint requested, uint available);


    function sendMoney(address to, uint _amount) public {
        // require(balances[msg.sender]>=_amount,"Not enough balance");
       if (_amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: _amount,
                available: balances[msg.sender]
            });
        
        balances[msg.sender]-=_amount;
        balances[to]+=_amount;
        emit Sent(msg.sender,to,_amount);

    }
    function balance(address _user) public view returns(uint){
        return balances[_user];
    }
}
