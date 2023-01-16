// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Showcase contract inheritance

contract Ownable {
    address owner;

   

    modifier onlyOwner() {
        require(msg.sender == owner, "must be owner");
        _;
    }
}

contract SecretVault {
    string secret;

    constructor(string memory _secret) {
        secret = _secret;
    }

    function getSecret() public view returns (string memory) {
        return secret;
    }
}

contract Secret is Ownable {
    address secrect;
    mapping(address=>uint) public users;
    uint public counter=1;
    address[] public secretVault=[0xdD870fA1b7C4700F2BD7f44238821C26f7392148];
    constructor(string memory _secret) {
        owner=msg.sender;
        SecretVault _secretVault = new SecretVault(_secret);
        secrect=address(_secretVault);
        secretVault.push(secrect);
        users[owner]=counter;
        counter++;
        super;
    }




    function createSecret(string memory _secret) public{
        owner=msg.sender;
        uint check=users[owner];
        if (check==0){
             users[owner]=counter;
        SecretVault anewSecretVault=new SecretVault(_secret);
        address agetAdd=address(anewSecretVault);
        secretVault.push(agetAdd);
        counter++;
          
        }else{
            SecretVault newSecretVault=new SecretVault(_secret);
        address getAdd=address(newSecretVault);
        secretVault[check]=getAdd;  
        }    
    }

    // function showSecret() public view onlyOwner returns(string memory){
    //     uint _count=users[msg.sender];
    //     return SecretVault(secretVault[_count]).getSecret();

    // }

    function check() public returns(uint){
         owner=msg.sender;
         uint acheck=users[owner];
        return (acheck);
    }

    function getSecret(uint count) public view onlyOwner returns (string memory) {
        address add=secretVault[count];
        return SecretVault(add).getSecret();
    }
}
