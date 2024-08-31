// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IERC20.sol";

contract SaveERC20 {
    address public owner;
    address public tokenAddress;

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;
    mapping(address => uint256) public rewards;

    event DepositSuccessful(address indexed user, uint256 indexed amount);
    event WithdrawalSuccessful(
        address indexed user,
        uint256 indexed amount,
        uint256 reward
    );
    event RewardCalculated(address indexed user, uint256 indexed reward);

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not owner");
        _;
    }

    function deposit(uint256 _amount) external {
        require(msg.sender != address(0), "zero address detected");
        require(_amount > 0, "can't deposit zero");

        uint256 _userTokenBalance = IERC20(tokenAddress).balanceOf(msg.sender);
        require(_userTokenBalance >= _amount, "insufficient amount");

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        if (stakes[msg.sender].amount > 0) {
            rewards[msg.sender] += calculateReward(msg.sender);
        }

        stakes[msg.sender].amount += _amount;
        stakes[msg.sender].startTime = block.timestamp;

        emit DepositSuccessful(msg.sender, _amount);
    }

    function calculateReward(address _user) internal view returns (uint256) {
        Stake memory userStake = stakes[_user];
        uint256 stakingDuration = block.timestamp - userStake.startTime;

        uint256 rewardRate = 1;
        uint256 reward = (userStake.amount * rewardRate * stakingDuration) /
            (100 * 1 days);

        return reward;
    }

    function withdraw() external {
        require(msg.sender != address(0), "zero address detected");
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "no funds to withdraw");

        uint256 reward = calculateReward(msg.sender) + rewards[msg.sender];
        uint256 totalAmount = userStake.amount + reward;

        delete stakes[msg.sender];
        rewards[msg.sender] = 0;

        IERC20(tokenAddress).transfer(msg.sender, totalAmount);

        emit WithdrawalSuccessful(msg.sender, userStake.amount, reward);
    }

    function myStake() external view returns (uint256 amount, uint256 startTime, uint256 reward)  {
        Stake memory userStake = stakes[msg.sender];
        return (
            userStake.amount,
            userStake.startTime,
            calculateReward(msg.sender) + rewards[msg.sender]
        );
    }

    function getContractBalance() external view onlyOwner returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function ownerWithdraw(uint256 _amount) external onlyOwner {
        require( IERC20(tokenAddress).balanceOf(address(this)) >= _amount, "insufficient funds");
        IERC20(tokenAddress).transfer(owner, _amount);
    }
}
