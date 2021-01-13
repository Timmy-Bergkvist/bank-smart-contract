pragma solidity 0.7.5;

import "./Ownable.sol";
import "./Destructible.sol";

interface GovernmentInterFace {
    function addTransaction(address _from, address _to, uint _amount) external payable;
    
}

contract Bank is Ownable, Destroyable { 
    
    GovernmentInterFace governmentInstance = GovernmentInterFace(0xd9145CCE52D386f254917e481eB44e9943F39138);
    
    mapping(address => uint) balance;
    
    function deposit() public payable returns (uint){
        balance[msg.sender] += msg.value;
   	    emit depositDone(msg.value, msg.sender); // emiting the event
        return balance[msg.sender];
    }
    
    function withdraw(uint amount) public returns (uint){
        require(balance[msg.sender] >= amount);
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);
        return balance[msg.sender];
    }
    
    function getAddress() public view returns (uint){
        return balance[msg.sender];
    }
    
    function transfer(address recipient, uint amount)public {
        //check balance of msg.sender
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Dont transfer money to yourself"); // sender cant send money to his/hers address
        
        uint previousSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        governmentInstance.addTransaction(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == previousSenderBalance - amount); //checks the code 
    }
    
    function _transfer(address from , address to, uint amount) private {
        
        balance[from] -= amount; // reduce the balance
        balance[to] += amount; // increase balance
        
    }
}