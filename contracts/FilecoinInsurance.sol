//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "usingtellor/contracts/UsingTellor.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FilecoinInsurance is UsingTellor, ERC20 {

    string queryType;

    mapping(bytes32 => mapping(address => uint256)) public claims;

    constructor(address payable _tellorAddress) UsingTellor(_tellorAddress) ERC20("FilecoinInsurance", "FCI") {
        queryType = "FilecoinDealStatus";
    }

    function requestClaim(string memory _proposalCID) external {
        bytes memory queryData = abi.encode(queryType, abi.encode(_proposalCID));
        bytes32 queryId = keccak256(queryData);
        (bool success, bytes memory rawStatus, uint256 timestamp) = getDataBefore(queryId, block.timestamp - 3 hours);

        require(success, "request to Tellor unsuccessful");

        bool status = abi.decode(rawStatus, (bool));

        uint256 claimAmount = claims[keccak256(abi.encode(_proposalCID))][msg.sender];

        if (status == false) {
            claims[keccak256(abi.encode(_proposalCID))][msg.sender] = 0;
        }

        transferFrom(address(this), msg.sender, claimAmount);

    }

    function requestCoverage(string memory _proposalCID, uint256 _amount) external {

        bytes memory queryData = abi.encode(queryType, abi.encode(_proposalCID));
        bytes32 queryId = keccak256(queryData);
        (bool success, bytes memory rawStatus, uint256 timestamp) = getDataBefore(queryId, block.timestamp - 3 hours);

        require(success, "request to Tellor unsuccessful");

        bool status = abi.decode(rawStatus, (bool));
        require(status, "Filecoin deal is non-active!");
        //set claim 
        claims[keccak256(abi.encode(_proposalCID))][msg.sender] = _amount;

        //approve
        approve(msg.sender, _amount);

        //transfer from
        transferFrom(msg.sender, address(this), _amount);


    }
}
