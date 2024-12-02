//SPDX-License-Identifier:MIT

pragma solidity ^0.8.25;

import "./PriceConverter.sol";

contract Donation{
    using PriceConverter for uint256;

    address public owner;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    //Track donations address
    mapping(address=>uint256) public donations;
    address[] public funders; //Keep track of all donors

    //Events to log donations and withdrawal
    event donationsReceived(address indexed donor, uint256 amount);
    event fundsWithdrawn(address indexed owner, uint256 amount);

    //Modifiers to restrict access to only-owner functions
    modifier onlyOwmer(){
        require(msg.sender==owner, "Only owner can withdraw funds");_;
    }

    constructor (){
        owner = msg.sender; 
    }

    //Payable function to accept donations from people
    function fund() public payable{
         require(msg.value.getConversionRate() >= MINIMUM_USD, "Minimum donation is $50");
        // require(msg.value>0, "The amount should be greater than 0");
        donations[msg.sender] += msg.value;//track the donation count
        funders.push(msg.sender);//Add the sender to the donation list
        emit donationsReceived(msg.sender, msg.value);//logging the donations

    }

    //Function to withdraw all funds
    function withdraw() public onlyOwmer{
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");

        //Transfer all funds to the owner
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "Withdrawal failed");

        emit fundsWithdrawn(owner, contractBalance);//Logs the withdrawal
    }

    //Function to view the contract balance
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}