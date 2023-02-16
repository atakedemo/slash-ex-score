// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SampleNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private addressAdmin;
    
    constructor() public ERC721("SampleNFTforSlachHackathon", "SSH") {
        addressAdmin = msg.sender;
    }

    function mintNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {   
        require(msg.sender == addressAdmin);
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function upgradeAdminTo(address _address)
        private
    {
        require(msg.sender == addressAdmin);
        addressAdmin = _address;
    }
}