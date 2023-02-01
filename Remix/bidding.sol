pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

//Majorly SOlidity example but with changes

contract Bidding{
    uint public highestBid=0;
    address public highestBidder;
    address[] public users;
    mapping(address=>uint) public pendingReturns;
    address payable public beneficiary;
    uint endTime;
    bool ended=false;

    event highestBidChanged(address bidder,uint amount);
    event winner(address winner);
    event winningBid(uint amount);

    error withdrawFailed();
    error bidLow();
    error auctionEnded();
    error auctionNotEndedYet();
    error auctionEndAlreadyCalled();

    constructor(
        address payable _beneficiary,
        uint biddingTime
    ) payable{
        beneficiary=_beneficiary;
        endTime=block.timestamp + biddingTime;
    }

    function bid() public payable {
        if(msg.value<=highestBid){
            revert bidLow();
        }
        if(block.timestamp>endTime){
            revert auctionEnded();
        }
        if(highestBid!=0){
            if(pendingReturns[highestBidder]==0){
                users.push(highestBidder);
            }
            pendingReturns[highestBidder]+=highestBid;
        }
        highestBidder=msg.sender;
        highestBid=msg.value;

        emit highestBidChanged(msg.sender,msg.value);

    }

    function withdraw() public payable returns(bool){
        uint amount=pendingReturns[msg.sender];
        if(amount>0){
            pendingReturns[msg.sender]=0;
        }
        if(!payable(msg.sender).send(amount)){
            pendingReturns[msg.sender]=amount;
            return false;
        }
        return true;
    }

    function withdrawOther() public payable returns(bool){
        require(msg.sender==beneficiary,"Only Owner can do this");
        uint amount;
        address sender;
        for(uint i=0;i<users.length;i++){
            sender=users[i];
            amount=pendingReturns[sender];
            if (amount>0){
            pendingReturns[sender]=0;
            if(!payable(sender).send(amount)){
                pendingReturns[sender]=amount;
                return false;
            }
            }
            
        }
        return true;
    }

    function AuctionEnd() public{
        if(block.timestamp<endTime){
            revert auctionNotEndedYet();
        }
        if(ended){
            revert auctionEndAlreadyCalled();
        }
        ended=true;
        emit winner(highestBidder);
        emit winningBid(highestBid);
    }
}

