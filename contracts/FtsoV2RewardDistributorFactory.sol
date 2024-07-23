// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IFtsoV2RewardDistributorFactory } from "./interfaces/IFtsoV2RewardDistributorFactory.sol";
import { FtsoV2RewardDistributor } from "./FtsoV2RewardDistributor.sol";

contract FtsoV2RewardDistributorFactory is IFtsoV2RewardDistributorFactory {

    mapping(address => NamedInstance[]) private instances;

    function create(
        address[] memory voters,
        uint256[] memory reserveBalances,
        address[] calldata recipients,
        uint256[] calldata bips,
        bool[] calldata wrap,
        bool editable,
        string calldata description
    ) external returns (address instance) {
        instance = address(
            new FtsoV2RewardDistributor(
                voters,
                reserveBalances,
                recipients,
                bips,
                wrap,
                editable ? msg.sender : address(0)
            )
        );
        if (bytes(description).length > 0) {
            NamedInstance storage ni = instances[msg.sender].push();
            ni.instance = instance;
            ni.description = description;
        }
        emit Created(instance, voters);
    }

    function rename(address instance, string calldata description) external {
        require(bytes(description).length > 0, "Empty description");
        NamedInstance[] storage nis = instances[msg.sender];
        for (uint256 i; i < nis.length; i++) {
            if (nis[i].instance == instance) {
                nis[i].description = description;
                return;
            }
        }
        revert("Instance not found");
    }

    function remove(address instance) external {
        NamedInstance[] storage nis = instances[msg.sender];
        for (uint256 i; i < nis.length; i++) {
            if (nis[i].instance == instance) {
                if (i < nis.length - 1) nis[i] = nis[nis.length - 1];
                nis.pop();
                return;
            }
        }
        revert("Instance not found");
    }

    function count(address owner) external view returns (uint256) {
        return instances[owner].length;
    }

    function get(address owner, uint256 i) external view returns (address instance, string memory description) {
        NamedInstance storage ni = instances[owner][i];
        return (ni.instance, ni.description);
    }

    function getAll(address owner) external view returns (NamedInstance[] memory) {
        return instances[owner];
    }
}
