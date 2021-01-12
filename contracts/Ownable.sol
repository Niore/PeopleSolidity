pragma solidity 0.7.5;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _; // run the function --> line will be replaced with function call
    }
}
