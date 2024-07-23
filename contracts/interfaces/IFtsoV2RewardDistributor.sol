// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
pragma abicoder v2;

interface IFtsoV2RewardDistributor {
    struct Recipient {
        address recipient;
        uint256 bips;
        bool wrap;
    }

    struct Voter {
        address payable voter;
        uint256 reserveBalance;
    }

    event TotalRewards(uint256 timestamp, uint256 amount);
    event Reward(address indexed recipient, uint256 amount);
    event Refill(address indexed voter, uint256 amount);

    function replaceOwner(address _owner) external;
    function replaceVoters(address[] calldata _voters, uint256[] calldata _reserveBalances) external;
    function replaceRecipients(
        address[] calldata _recipients,
        uint256[] calldata _bips,
        bool[] calldata _wrap
    ) external;
}
