// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./interfaces/IRewardDistributor.sol";
import "./FlareLibrary.sol";

contract RewardDistributor is IRewardDistributor {

    Voter[] public voters;
    Recipient[] public recipients;
    address public owner;
    bool private locked;

    modifier lock() {
        require(!locked, "Re-entrancy detected");
        locked = true;
        _;
        locked = false;
    }

    modifier onlyOwner() {
        require(owner != address(0) && owner == msg.sender, "Forbidden");
        _;
    }

    constructor(
        address[] memory _voters,
        uint256[] memory _reserveBalances,
        address[] memory _recipients,
        uint256[] memory _bips,
        bool[] memory _wrap,
        address _owner
    ) {
        require(_voters.length == _reserveBalances.length, "Voter ReserveBalances length mismatch");
        uint256 len = _recipients.length;
        require(_bips.length == len, "Bips length mismatch");
        require(_wrap.length == len, "Wrap length mismatch");

        owner = _owner;

        addVoters(_voters, _reserveBalances);
        addRecipients(_recipients, _bips, _wrap);
    }

    receive() external payable lock {
        uint256 remainingAmount = msg.value;
        emit TotalRewards(block.timestamp, remainingAmount);
        uint256 currentBalance = 0;

        // Top-up voters
        for(uint256 i; i < voters.length; i++){
            Voter storage v = voters[i];
            uint256 reserveBalance = v.reserveBalance;
            currentBalance = v.voter.balance;
            if (currentBalance < reserveBalance) {
                uint256 refillAmount = reserveBalance - currentBalance;
                if (refillAmount > remainingAmount) refillAmount = remainingAmount;
                (bool success, ) = v.voter.call{value: refillAmount}("");
                require(success, "Unable to refill voter's account");
                emit Refill(v.voter, refillAmount);
                remainingAmount -= refillAmount;
            }
        }

        // Distribute rewards to recipients
        if (remainingAmount > 0) {
            uint256 remainingBips = 100_00;
            for (uint256 i; i < recipients.length; i++) {
                Recipient storage r = recipients[i];
                uint256 shareAmount = (remainingBips == r.bips)
                    ? remainingAmount
                    : (remainingAmount * r.bips) / remainingBips;
                if (r.wrap) {
                    FlareLibrary.getWNat().depositTo{value: shareAmount}(r.recipient);
                } else {
                    (bool success, ) = r.recipient.call{value: shareAmount}("");
                    require(success, "Unable to send reward");
                }
                emit Reward(r.recipient, shareAmount);
                remainingAmount -= shareAmount;
                remainingBips -= r.bips;
            }
        }
    }

    function replaceOwner(address _owner) external onlyOwner {
        owner = _owner;
    }

    function replaceVoters(address[] calldata _voters, uint256[] calldata _reserveBalances) external onlyOwner {
        for (uint256 i = voters.length; i > 0; i--) voters.pop();
        addVoters(_voters, _reserveBalances);
    }

    function replaceRecipients(address[] calldata _recipients, uint256[] calldata _bips, bool[] calldata _wrap)
        external onlyOwner {
        for (uint256 i = recipients.length; i > 0; i--) recipients.pop();
        addRecipients(_recipients, _bips, _wrap);
    }

    function recipientsCount() external view returns (uint256) {
        return recipients.length;
    }

    function recipientsAll() external view returns (Recipient[] memory) {
        return recipients;
    }

    function addVoters(address[] memory _voters, uint256[] memory _reserveBalances) private {
        for (uint256 i; i < _voters.length; i++) {
            Voter storage voter = voters.push();
            voter.voter = payable(_voters[i]);
            voter.reserveBalance = _reserveBalances[i];
        }
    }

    function addRecipients(address[] memory _recipients, uint256[] memory _bips, bool[] memory _wrap) private {
        uint256 total;
        for (uint256 i; i < _recipients.length; i++) {
            Recipient storage recipient = recipients.push();
            recipient.recipient = _recipients[i];
            recipient.bips = _bips[i];
            recipient.wrap = _wrap[i];
            total += _bips[i];
        }
        require(total == 100_00, "Sum is not 100%");
    }
}
