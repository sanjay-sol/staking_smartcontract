//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingContract is ERC20 {

    mapping(address => uint256) public staked;
    mapping(address => uint256) public stakedTS; //Stake start from Time stamp(it shows when user staked token )
    constructor() ERC20("Staking Contract ","STC"){
        _mint(msg.sender,10000000000);
    }
    function mint(uint256 amount) external {
        require(amount > 0 , "amount should be greater than 0");
        _mint(msg.sender,amount);

    }
    function stake(uint256 amount) external {
        require(amount > 0 , "amount should be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Not enough balance to stake");
        _transfer(msg.sender, address(this),amount); // Usin internal transfer function ( no need to approve  )
        if(staked[msg.sender] > 0){
            claim();
        }
        stakedTS[msg.sender] = block.timestamp; // updates timestamp whwn they stake
        staked[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        require(amount > 0,"amount should be greater than 0");
        require(staked[msg.sender] >= amount ,"amount should be greater than staked amount");
        claim();
        staked[msg.sender] -= amount; // update staked amoutn
        _transfer(address(this),msg.sender,amount);

    }
    function claim() public {
        require(staked[msg.sender] > 0,"staked amount should be graeter than 0");
        uint256 sencondsStaked = block.timestamp - stakedTS[msg.sender];
        uint256 rewards = staked[msg.sender] * sencondsStaked / 3.154e7; // how muchh they stake multiplied by seconds staked divided by total seconds in a year 
        _mint(msg.sender , rewards); // For now Reward token is same as the staked token and this may vary based on your requuirement
        stakedTS[msg.sender] = block.timestamp;
    }


    // function totalStakedtime(address _address) public view returns(uint256 time) {
    //     require(staked[msg.sender] > 0,"staked amount should be graeter than 0");
    //     uint256 sencondsStaked = block.timestamp - stakedTS[msg.sender];
    //     return sencondsStaked;


    // }
}