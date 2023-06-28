// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./fintrustToken.sol";
import "hardhat/console.sol";

//  /$$$$$$$$/$$$$$$/$$   /$$/$$$$$$$$/$$$$$$$ /$$   /$$ /$$$$$$ /$$$$$$$$
// | $$_____|_  $$_| $$$ | $|__  $$__| $$__  $| $$  | $$/$$__  $|__  $$__/
// | $$       | $$ | $$$$| $$  | $$  | $$  \ $| $$  | $| $$  \__/  | $$
// | $$$$$    | $$ | $$ $$ $$  | $$  | $$$$$$$| $$  | $|  $$$$$$   | $$
// | $$__/    | $$ | $$  $$$$  | $$  | $$__  $| $$  | $$\____  $$  | $$
// | $$       | $$ | $$\  $$$  | $$  | $$  \ $| $$  | $$/$$  \ $$  | $$
// | $$      /$$$$$| $$ \  $$  | $$  | $$  | $|  $$$$$$|  $$$$$$/  | $$
// |__/     |______|__/  \__/  |__/  |__/  |__/\______/ \______/   |__/

/// @title Fintrust Wallet
/// @author OGUBUIKE ALEX
/// @notice A contract that handles decentralized societal funding
/// @dev This contract manages donations and withdrawal of funds associated with campaigns.
/// @dev The actors are the creators, depositors and the signatories.
/// @dev A creator creates a campaign and stores three signatories within the campaign.
/// @dev After receiving donations, a creator requests withdrawal access from signatories.
/// @dev After withdraw authorization, then the creator can withdraw funds.
contract Fintrustv2 is Pausable, Ownable {
    uint256 constant MIN_AMOUNT = 500;
    uint256 constant CHARGE = 0.04 ether;
    uint256 chargeCollected;

    FintrustToken token;
    uint256 private _itemIds;

    enum State {
        Inactive,
        Active,
        TargetReached,
        Ended
    }

    enum CampaignType {
        Public,
        Individual
    }

    error InvalidAmount(uint256 amount);
    event CampaignCreated(
        uint256 indexed campaignId,
        address indexed creator,
        string url,
        uint256 timeStamp,
        CampaignType campaignType,
        uint256 amount
    );
    event Donated(
        uint256 campaignId,
        address sender,
        uint256 timestamp,
        uint256 amount
    );

    event WithDrawn(
        uint256 campaignId,
        address sender,
        uint256 timestamp,
        uint256 amount
    );

    event ChangedRequestStatus(
        address sender,
        uint256 campaignId,
        bool canWithdraw
    );

    modifier onlyEOA() {
        require(isNotContract(msg.sender), "Must use EOA");
        _;
    }

    struct Campaign {
        uint256 campaignId;
        State state;
        bool canWithdraw;
        CampaignType campaignType;
        address creator;
        uint128 createdAt;
        uint128 endedAt;
        uint256 amount;
        uint256 balance;
        uint256 deposited;
        string url;
    }

    mapping(uint256 => Campaign) public campaigns;

    constructor(address _token) {
        token = FintrustToken(_token);
    }

    /// @notice Pause the smart contract incase of an emergency
    /// @dev modifier onlyRole ensures that it can only be called by a user with the Pauser Role
    function pause() public onlyOwner {
        _pause();
    }

    /// @notice Unpause the smart contract
    /// @dev modifier onlyRole ensures that it can only be called by a user with the Pauser Role
    function unpause() public onlyOwner {
        _unpause();
    }

    /// @notice Creates a new campaign for sender
    /// @dev Requires that sender is EOA and contract is not paused
    /// @param _url IPFS Link for campaign metadata
    /// @param _amount Target amount to be generated from campaign
    function createCampaign(
        string calldata _url,
        uint256 _amount,
        CampaignType _type
    ) external onlyEOA whenNotPaused {
        //check the value of url is not 0x00 or default bytes32
        if (_amount < MIN_AMOUNT) {
            revert InvalidAmount(_amount);
        }

        _itemIds += 1;

        console.log("In here");
        //create a new campaign
        Campaign memory _campaign = Campaign({
            url: _url,
            amount: _amount,
            creator: msg.sender,
            campaignType: _type,
            createdAt: uint128(block.timestamp),
            endedAt: 0,
            balance: 0,
            deposited: 0,
            state: State.Active,
            campaignId: _itemIds,
            canWithdraw: false
        });

        campaigns[_itemIds] = _campaign;        

        emit CampaignCreated(
            _campaign.campaignId,
            msg.sender,
            _url,
            block.timestamp,
            _type,
            _amount
        );
    }

    function toggleWithdrawRequestStatus(uint256 _campaignId)
        external
        onlyOwner
    {
        Campaign storage _campaign = campaigns[_campaignId];
        _campaign.canWithdraw = !_campaign.canWithdraw;

        emit ChangedRequestStatus(
            msg.sender,
            _campaignId,
            _campaign.canWithdraw
        );
    }

    /// @notice Get all campaigns ever created
    function getAllCampaigns() external view returns (Campaign[] memory) {
        uint256 itemCount = _itemIds;
        uint256 currentIndex = 0;

        Campaign[] memory items = new Campaign[](itemCount);

        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            Campaign memory currentDispute = campaigns[currentId];
            items[currentIndex] = currentDispute;
            currentIndex += 1;
        }
        return items;
    }

    /// @notice Donate to a campaign
    /// @dev Payable function that requires that the contract is not paused
    /// @param _campaignId The campaign Id
    /// @param amount The amount to be deposited
    function donate(uint256 _campaignId, uint256 amount)
        external
        payable
        whenNotPaused
    {
        if (msg.value != amount) {
            revert("Send valid amount");
        }

        Campaign memory _campaign = campaigns[_campaignId];

        if (_campaign.state != State.Active) {
            //revert InactiveCampaign(_campaignId);
            revert("Invalid State");
        }

        if (_campaign.deposited >= _campaign.amount) {
            _campaign.state = State.TargetReached;
            //revert TargetReached(_campaignId);
            revert("Target Reached");
        }

        //Check Allowance
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Invalid token allowance");

        token.transferFrom(msg.sender, address(this), amount);

        _campaign.balance += amount;
        _campaign.deposited += amount;
        campaigns[_campaignId] = _campaign;

        emit Donated(_campaignId, msg.sender, block.timestamp, amount);
    }

    /// @notice Withdraw funds deposited to a campaign
    /// @dev Requires withdrawal charge of 0.04 MATIC
    /// @dev To be called by the creator of the context campaign
    /// @param amount The amount to be withdrawn
    /// @param _campaignId The campaign Id
    function withdraw(uint256 _campaignId, uint256 amount) external payable {
        if (CHARGE != msg.value) {
            revert("Invalid Charge");
        }

        Campaign memory _campaign = campaigns[_campaignId];

        if (msg.sender != _campaign.creator) {
            revert("unauthorized");
        }

        if (
            _campaign.state != State.Active &&
            _campaign.state != State.TargetReached
        ) {
            revert("Invalid State");
        }

        if (msg.sender != _campaign.creator) {
            revert("unauthorized");
        }

        if (!_campaign.canWithdraw) {
            revert("Cannot Withdraw");
        }

        if (_campaign.balance < amount) {
            revert("Insufficient Funds");
        }

        chargeCollected += amount;
        _campaign.canWithdraw = false;

        if (_campaign.state == State.TargetReached) {
            if (_campaign.balance - amount == 0) {
                _campaign.state = State.Ended;
            }
        }

        _campaign.balance -= amount;
        _campaign.state = State.Ended;

        emit WithDrawn(_campaignId, _campaign.creator, block.timestamp, amount);

        (bool success, ) = _campaign.creator.call{value: amount}("");

        require(success, "Withdraw Error");
    }

    function isNotContract(address _a) private view returns (bool) {
        uint256 len;
        assembly {
            len := extcodesize(_a)
        }
        if (len == 0) {
            return true;
        }

        return false;
    }
}
