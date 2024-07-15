// SPDX-License-Identifier: MIT
pragma solidity >=0.7.5;
pragma abicoder v2;

interface IRewardDistributor {
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

    // function identity() external view returns (address);
    // function reserveBalances() external view returns (uint256[] memory);
    // function recipients(uint256 i) external view returns (address recipient, uint256 bips, bool wrap);
    // function recipientsCount() external view returns (uint256);
    // function recipientsAll() external view returns (Recipient[] memory);
    // function owner() external view returns (address);
}
