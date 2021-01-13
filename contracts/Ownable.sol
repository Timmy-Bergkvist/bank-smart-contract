contract Ownable {
    address internal owner;
    
    // this is an event
    event depositDone(uint amout, address indexed depositetTo);
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _; // run the function
    }
    
    constructor(){
        owner = msg.sender;
    }
}