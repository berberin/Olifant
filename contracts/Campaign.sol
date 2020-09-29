pragma solidity ^0.5.5;

contract Campaign {
    address public owner;
    uint256 public fundCall;
    uint256 public remainingFund;
    uint256 public timeLock;
    address[] public contributors;
    mapping(address => uint256) public contributions;
    event NewCampaign(address owner, uint256 fundCall, uint256 timeLock);
    bool public complete = false;

    uint256 public minimumContribution;

    constructor(
        address _owner,
        uint256 _fundCall,
        uint256 _timeLock,
        uint256 _minimumContribution
    ) public {
        require(_fundCall != 0 && _timeLock != 0 && _minimumContribution != 0);
        owner = _owner;
        fundCall = _fundCall * 1 wei;
        timeLock = now + _timeLock * 1 seconds;
        minimumContribution = _minimumContribution;
        emit NewCampaign(_owner, _fundCall, _timeLock);
    }

    /*
        Contribute to campaign
        Contribution must be greater than 0
        Current time must before expired time
        Address becomes contributor of campaign 
        If total contribution greater than minimumContribution, address become approver for request receive fund when campaign is successful
     */
    function contribute() public payable {
        require(msg.value > 0);
        require(now < timeLock);
        if (!isContributor(msg.sender)) {
            contributors.push(msg.sender);
        }
        contributions[msg.sender] += msg.value;
        if (address(this).balance >= fundCall) {
            complete = true;
            remainingFund = address(this).balance;
        }
    }

    /*
        Check address has donated and address is not locked address(0x0)
     */
    function isContributor(address who) internal view returns (bool) {
        if (who != address(0x0) && contributions[who] > 0) {
            return true;
        }
        return false;
    }

    /*
        Get list address of contributors
    */
    function getAllContributors() public view returns (address[] memory) {
        return contributors;
    }

    /*
        Get current balance of campaign  
     */

    function currentBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /*
        Refund contribution for contributor when campaign is unsuccessful
        Current time must be less than expiry time
        Current balance must be less than fundCall
        Address is must be contributor and has not withdrawn 
     */
    function refund() public {
        require(
            now >= timeLock && address(this).balance < fundCall,
            "Not eligible"
        );
        require(isContributor(msg.sender), "You have not contributed yet");
        msg.sender.transfer(contributions[msg.sender]);
        contributions[msg.sender] = 0;
    }

    /*
        Create request to withdraw money
        Only owner of campaign can create request to withraw money
     */
    function withdraw() public _onlyOnwner _enoughFund {
        // Request fundCall
        msg.sender.transfer(remainingFund);
    }

    modifier _onlyOnwner() {
        require(msg.sender == owner, "Only owner can do");
        _;
    }

    modifier _campaignExpired() {
        require(now >= timeLock, "Must enough time");
        _;
    }

    modifier _enoughFund() {
        require(complete, "Must enough fundCall");
        _;
    }
}
