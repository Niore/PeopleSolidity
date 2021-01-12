pragma solidity 0.7.5;

import "./Ownable.sol";

contract People is Ownable {
    uint256 balance;
    struct Person {
        uint256 id;
        string name;
        uint256 age;
        uint256 height;
        bool senior;
    }

    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);

    mapping(address => Person) people;
    address[] private creators;

    function createPerson(
        string memory name,
        uint256 age,
        uint256 height
    ) public payable {
        require(age < 150);
        require(msg.value >= 1 ether);
        balance += msg.value;

        Person memory p;
        p.name = name;
        p.age = age;
        p.height = height;
        p.senior = age >= 65 ? true : false;

        insertPerson(p);
        creators.push(msg.sender);

        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name,
                    people[msg.sender].age,
                    people[msg.sender].height,
                    people[msg.sender].senior
                )
            ) == keccak256(abi.encodePacked(p.name, p.age, p.height, p.senior))
        );
        emit personCreated(p.name, p.senior);
    }

    function getCreator(uint256 idx) public view onlyOwner returns (address) {
        return creators[idx];
    }

    function deletePerson(address person) public onlyOwner() {
        bool senior = people[person].senior;
        string memory name = people[person].name;

        delete people[person];
        assert(people[person].age == 0);
        emit personDeleted(name, senior, owner);
    }

    function insertPerson(Person memory newP) private {
        address person = msg.sender;
        people[person] = newP;
    }

    function getPerson()
        public
        view
        returns (
            string memory name,
            uint256 age,
            uint256 height,
            bool senior
        )
    {
        return (
            people[msg.sender].name,
            people[msg.sender].age,
            people[msg.sender].height,
            people[msg.sender].senior
        );
    }

    function withdrawlAll() public onlyOwner returns (uint256) {
        uint256 amount = balance;
        balance = 0;
        msg.sender.transfer(amount);
        return amount;
    }
}
