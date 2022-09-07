// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Storage is AccessControl {

    uint256 number;
    bytes32 public ROL_ADMIN = keccak256("ADMIN");
    bytes32 public ROL_WRITER = keccak256("WRITER");

    constructor(){
        _grantRole(ROL_ADMIN, msg.sender);
    }

    modifier onlyAdmin(){
        require(hasRole(ROL_ADMIN, msg.sender), "only admin can add or remove write roles");
        _;
    }

    modifier onlyWriter(){
        require(hasRole(ROL_WRITER, msg.sender), "only writer can store");
        _;
    }

    function addWrite(address _address) public onlyAdmin {
        _grantRole(ROL_WRITER, _address);
    }

    function removeWrite(address _address) public onlyAdmin {
        _revokeRole(ROL_WRITER, _address);
    }

    function store(uint256 num) public onlyWriter {
        number = num;
    }

    function retrieve() public view returns (uint256){
        return number;
    }
}