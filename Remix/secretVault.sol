// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract Hotel{

    address payable public owner;
    enum Statuses {Vacant,
    Occupied}
    event Occupy(address _occupant, uint256 _value);

    Statuses public currentStatus;

    constructor(){
        owner=payable(msg.sender);
        currentStatus=Statuses.Vacant;
    }

    modifier onlyWhileVacant(){
        require(currentStatus==Statuses.Vacant,"Currently Occupied");
        _;
    }

    modifier costs(uint _amount){
        require(msg.value>=_amount,"Not enough ether provided");
        _;
    }



    function book() public payable onlyWhileVacant costs(1 ether) {
        currentStatus=Statuses.Occupied;
        // owner.transfer(msg.value);
        (bool sent,bytes memory data)=owner.call{value:msg.value}("");
        require(sent);
        emit Occupy(msg.sender,msg.value);
    }

}
