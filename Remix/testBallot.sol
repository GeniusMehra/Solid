// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ballot{

    struct Voter{
        uint weight;
        bool voted;
        address delegate;
        uint index;
    }

    struct Proposal{
        string name;
        uint voteCount;
    }

    address public chairperson;
    mapping(address=>Voter) public voters;
    Proposal[] public proposals;

    constructor(string[] memory _proposalNames){
        chairperson=msg.sender;
        voters[chairperson].weight=1;

        for (uint i=0;i<_proposalNames.length;i++){
            proposals.push(Proposal({
                name:_proposalNames[i],
            voteCount:0}));
        }
    }

    function giveRightToVote(address voter) public {

        require(msg.sender==chairperson,
        "Only chairperson can give right to vote");

        require(
            !voters[voter].voted,
            "The voter already voted"
        );
        require(voters[voter].weight==0);
        voters[voter].weight=1;
    }

    function delegate(address to) public {
        Voter storage sender=voters[msg.sender];
        require(!sender.voted,"You already voted");
        require(to!=msg.sender,"Self delegation is disallowed");

        while (voters[to].delegate!=address(0)){
            to=voters[to].delegate;

            require(to!=msg.sender,"Loop in delegation");
        }
        sender.voted=true;
        sender.delegate=to;
        Voter storage delegate_=voters[to];
        if(delegate_.voted){
            proposals[delegate_.index].voteCount+=sender.weight;
        }else{
            delegate_.weight+=sender.weight;
        }

    }

    function vote(uint proposal) public{
        Voter storage _voter=voters[msg.sender];
        require(!_voter.voted,"Already voted");
        require(_voter.weight!=0,"No right to vote");
        _voter.voted=true;
        _voter.index=proposal;
        proposals[proposal].voteCount+=_voter.weight;
    }



        uint winningCount=0;
        uint winumbers=0;
    function winningProposal() public returns(uint){
        for (uint i=0;i<proposals.length;i++){
            if (proposals[i].voteCount>winningCount){
                winningCount=proposals[i].voteCount;
                winumbers++;
            }
        }
    }
//Changes here
//modified for handling multiple winners
        string[] public winners;
    function winnerName() public returns(string[] memory winnername_){
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].voteCount==winningCount){
            winners.push(winners[i]);
            }
        }

    }

}
