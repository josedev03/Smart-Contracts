//SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

contract ColeccionCosmovision is ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;

    Counters.Counter public tokenIdCounter;

    // modifiers
    modifier onlyAdmin() {
        require(
            hasRole(ROL_ADMIN, msg.sender),
            "It is enable only for an ADMIN"
        );
        _;
    }

    // ------- Structs
    struct Donation {
        string name;
        address walletDonator;
    }

    struct Associate {
        string name;
        address walletAssociate;
    }

    // ------- Errors
    error amountNotValid(string message);

    // ------- Events
    event addFounds(
        uint amountAdded,
        address senderAddress
    );

    bytes32 public constant ROL_ADMIN = keccak256("ROL_ADMIN");
    bytes32 public constant ROL_HISTORIADOR = keccak256("ROL_HISTORIADOR");
    bytes32 public constant ROL_SOCIO = keccak256("ROL_SOCIO");
    address mainAddress;
    address payable mainAddressWallet;
    uint256 minimumDonation;
    Donation[] public donations;
    Associate[] public associates;

    // "Comunidad Kichwa"
    // "KICHWA"
    constructor(uint256 _minimumDonation) ERC721("Comunidad Kichwa", "KICHWA") {
        _grantRole(ROL_ADMIN, msg.sender);
        minimumDonation = _minimumDonation;
        mainAddress = msg.sender;
        mainAddressWallet = payable(msg.sender);
    }

    function releaseFunds() private onlyAdmin {
        // TO-DO
        // implementing the logic
    }

    function addRoleHistoriographer(address account) public onlyAdmin {
        _grantRole(ROL_HISTORIADOR, account);
    }

    function removeRoleHistoriographer(address account) public onlyAdmin {
        _revokeRole(ROL_HISTORIADOR, account);
    }

    modifier onlyHistoriographer() {
        require(
            hasRole(ROL_HISTORIADOR, msg.sender),
            "It is enable only for an HISTORIOGRAPHER"
        );
        _;
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function addDonation(string memory nameDonator) public payable{
        require(msg.value >= minimumDonation, "Amount not valid, please send a value upper than 10");
        mainAddressWallet.transfer(msg.value);
        Donation memory tempDonation;
        tempDonation.walletDonator = msg.sender;
        tempDonation.name = nameDonator;
        donations.push(tempDonation);
    }

    function createAssociate(string calldata nameAssociate, address account) public onlyAdmin{
        _grantRole(ROL_SOCIO, account);
        Associate memory tempAssociate;
        tempAssociate.walletAssociate = msg.sender;
        tempAssociate.name = nameAssociate;
        associates.push(tempAssociate);
    }

    function mint(string calldata urlJsonUri) public onlyHistoriographer {
        uint256 tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        _safeMint(mainAddress, tokenId);
        _setTokenURI(tokenId, urlJsonUri);
    }

    function getAllDonors() public view returns(Donation[] memory){
       return donations;
    }

    function getAllAssociate() public view returns(Associate[] memory){
       return associates;
    }
}