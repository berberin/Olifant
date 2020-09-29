pragma solidity ^0.5.5;
import "./Campaign.sol";

contract CampaignFactory {
    address[] public campaigns;
    mapping(address => bool) verifyCampaigns;
    mapping(address => address[]) ownerCampaigns;

    function createCampaign(
        uint256 _fundCall,
        uint256 _timeLock,
        uint256 _minimumContribution
    ) public returns (address) {
        address campaign = address(
            new Campaign(msg.sender, _fundCall, _timeLock, _minimumContribution)
        );
        campaigns.push(campaign);
        return campaign;
    }

    function getAllCampaigns() public view returns (address[] memory) {
        return campaigns;
    }

    function checkCampaign(address _campaignAddress)
        public
        view
        returns (bool)
    {
        return verifyCampaigns[_campaignAddress];
    }

    function getMyCampaigns(address _owner)
        public
        view
        returns (address[] memory)
    {
        return ownerCampaigns[_owner];
    }

    function() external payable {}
}
