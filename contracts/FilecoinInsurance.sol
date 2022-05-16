//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "usingtellor/contracts/UsingTellor.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FilecoinInsurance is UsingTellor, ERC20 {

    string queryType;

    struct Claim {
        mapping(address => uint256) payments;
        bool live;
    }

    mapping(bytes32 => Claim) public claims;

    constructor(address payable _tellorAddress) UsingTellor(_tellorAddress) ERC20("FilecoinInsurance", "FCI") {
        queryType = "FilecoinDealStatus";
    }

    function requestClaim(string memory _proposalCID) external {
        bytes memory queryData = abi.encode(queryType, abi.encode(_proposalCID));
        bytes32 queryId = keccak256(queryData);
        (bool success, bytes memory rawStatus, uint256 timestamp) = getDataBefore(queryId, block.timestamp - 3 hours);

        require(success, "request to Tellor unsuccessful");

        if (status == false) {
            claims[keccak256(_proposalCID)].live = false;
            claims[keccak256(_proposalCID)][msg.sender] = 0;
        }

        transferFrom(address(this), msg.sender);

    }

    function requestCoverage(string memory _proposalCID) external {


    }
}
