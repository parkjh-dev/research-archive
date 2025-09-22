// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract MyNFT is ERC721URIStorage, Ownable, ChainlinkClient {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    bytes32 private jobId;
    address private oracle;
    uint256 private fee;

    using Chainlink for Chainlink.Request;


    constructor() ERC721("MydNFT", "dNFT") {
        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }



    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _setTokenURI(tokenId, tokenURI);
    }

    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }


    function getData() public {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
   
        req.add(
            "get",
            "http://armypark.myds.me/user/1"
        );
        req.add("path","data.data");

        sendChainlinkRequestTo(oracle, req, fee);
    }



    function fulfill(bytes32 _requestId, uint256 _uri) public {
        string memory tokenURI = bytes32ToString(bytes32(_uri));
        uint256 newItemId = _tokenIds.current();
        _setTokenURI(newItemId, tokenURI);
    }

    function bytes32ToString(bytes32 _bytes32) private pure returns (string memory) {
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

}
