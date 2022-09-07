// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Founding{

    struct Project {
        bool isActive;
        uint total;
        uint goal;
        string projectName;
        address owner;
        address payable ownerWallet;
    }

    struct Contribution {
        address contributor;
        uint value;
    }

    Project[] public projects;
    mapping(string => Contribution[]) public contributions;

    function createProject(
        bool _isActive,
        uint _goal,
        string memory _projectName
    ) public {
        Project memory tempProject;
        tempProject.isActive = _isActive;
        tempProject.total = 0;
        tempProject.goal = _goal;
        tempProject.projectName = _projectName;
        tempProject.owner = msg.sender;
        tempProject.ownerWallet = payable(msg.sender);

        projects.push(tempProject);
    }

    // function showProject(uint index) public view returns (Project) {
    //     return arrayProject[0];
    // }

    // ------- Modifiers
    modifier onlyOwner(uint index){
        require(
            projects[index].owner == msg.sender,
            "Only owner change project status"
        );
        _;
    }

    modifier differentAdsress(uint index){
        require(
            projects[index].owner != msg.sender,
            "Owner can not add found"
        );
        _;
    }

    modifier projectAvailable(uint index){
        require(
            projects[index].isActive,
            "The project is not active"
        );
        _;
    }

    // ------- Events
    event chageStatus(
        bool newStatus,
        address ownerAddress
    );

    event addFounds(
        uint amountAdded,
        address senderAddress
    );

    // ------- Errors
    error amountNotValid(string message);

    // ------- Enums
    enum FundraisingState {Opened, Closed}

    function foundProject(uint index) public payable projectAvailable(index) differentAdsress(index){
        if(msg.value == 0){
            revert amountNotValid("Amount not valid, please send a value upper than 0");
        }
        Project memory tempProject = projects[index];
        tempProject.ownerWallet.transfer(msg.value);
        tempProject.total += msg.value;
        projects[index] = tempProject;

        contributions[tempProject.projectName].push(Contribution(msg.sender, msg.value));
        emit addFounds(msg.value, msg.sender);
    }

    function changeProjectStatus(uint index, bool _newStatus) public onlyOwner(index){
        require(projects[index].isActive != _newStatus, "the new status should be different of current");
        projects[index].isActive = _newStatus;
        emit chageStatus(_newStatus, msg.sender);
    }

    function changeProjectName(uint index, string memory _newName) public onlyOwner(index){
        projects[index].projectName = _newName;
    }

    function getStatus(uint index) public view returns (bool) {
        return projects[index].isActive;
    }
}