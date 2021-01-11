pragma solidity 0.7.5;

contract Bank { 
    
    mapping(address => uint) balance;
    
    function deposit() public payable returns (uint){
        balance[msg.sender] += msg.value;
   	    emit depositDone(msg.value, msg.sender); // emiting the event
        return balance[msg.sender];
    }
    
    function withdraw(uint amount) public returns (uint){
        // get the balance from sender
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
        
        governmentInstance.addTransaction{value: 1 ether}(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == previousSenderBalance - amount); //checks the code 
    }
    
    function _transfer(address from , address to, uint amount) private {
        
        balance[from] -= amount; // reduce the balance
        balance[to] += amount; // increase balance
        
    }

}