// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EtherStaking {
    address public owner;
    uint256 public rewardRate; 

    struct Stake {
        uint256 stakingTime;
        uint256 amount;
    }

    mapping(address => Stake) public stakes;

    bool private locked;

    modifier onlyAdmin() {
        require(msg.sender == owner, "Only admin can perform this action");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrancy guard: reentrant call detected");
        locked = true;
        _;
        locked = false;
    }

    constructor(uint256 _rewardRate) {
        owner = msg.sender;
        rewardRate = _rewardRate;
        locked = false;
    }

    function deposit() public payable {
        require(msg.sender != address(0), "Invalid address");
        require(msg.value > 0, "Deposit amount must be greater than zero");

        Stake storage staker = stakes[msg.sender];
        
        if (staker.amount == 0) {
            staker.stakingTime = block.timestamp;
        }

        staker.amount += msg.value;
    }

    function calculateReward(address stakerAddress) public view returns (uint256) {
        Stake storage staker = stakes[stakerAddress];

        uint256 stakingDuration = block.timestamp - staker.stakingTime;
        uint256 reward = (staker.amount * rewardRate * stakingDuration) / 1 days;

        return reward;
    }

    function withdraw(uint256 _amount) external nonReentrant {
        require(msg.sender != address(0), "Invalid address");
        require(_amount > 0, "Withdrawal amount must be greater than zero");
        
        Stake storage staker = stakes[msg.sender];
        require(staker.amount >= _amount, "Insufficient staked amount");

        uint256 reward = calculateReward(msg.sender);
        uint256 totalAmountToWithdraw = _amount + reward;

        staker.amount -= _amount;
        if (staker.amount == 0) {
            staker.stakingTime = 0;
        }

        (bool success, ) = msg.sender.call{value: totalAmountToWithdraw}("");
        require(success, "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return stakes[msg.sender].amount;
    }

    function getContractBalance() external view onlyAdmin returns (uint256) {
        return address(this).balance;
    }

    function updateRewardRate(uint256 _newRewardRate) external onlyAdmin {
        rewardRate = _newRewardRate;
    }
}
