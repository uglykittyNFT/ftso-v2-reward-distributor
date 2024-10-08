// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
pragma abicoder v2;

interface IFtsoV2RewardDistributorFactory {
    struct NamedInstance {
        address instance;
        string description;
    }

    event Created(address indexed instance, address[] indexed voters);

    function create(
        address[] memory voters,
        uint256[] memory reserveBalances,
        address[] calldata recipients,
        uint256[] calldata bips,
        bool[] calldata wrap,
        bool editable,
        string calldata description
    ) external returns (address instance);

    function rename(address instance, string calldata description) external;
    function remove(address instance) external;

    function count(address owner) external view returns (uint256);
    function get(address owner, uint256 i) external view returns (address instance, string memory description);
    function getAll(address owner) external view returns (NamedInstance[] memory);

}
