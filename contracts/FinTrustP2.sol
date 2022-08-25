// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.9;


// /// @title Fintrust fundraiser
// /// @author OGUBUIKE ALEX
// /// @notice A contract that handles decentralized societal funding
// /// @dev This contract manages donations and withdrawal of funds.
// library FintrustP2  {

//     uint256 internal constant MIN_AMOUNT = 500;
//     uint256 internal constant CHARGE = 0.04 ether;    

//     error InvalidAmount(uint256 amount);
//     error InactiveCampaign(uint256 campaignId);
//     error Unauthorized(address sender);
//     error TargetReached(uint256 campaignId);
//     error InvalidState(uint256 campaignId, address creator);
//     error BadRequest(string error);

//     event CampaignCreated(uint256 indexed id, address indexed initiator);
//     event Deposit(
//         uint256 indexed id,
//         address indexed creator,
//         address indexed depositor,
//         uint256 timeStamp,
//         uint256 amount
//     );
//     event Withdraw(
//         uint256 indexed id,
//         address indexed creator,
//         uint256 indexed timeStamp,
//         uint256 amount
//     );

//     event WithdrawInitiated(
//         uint256 indexed id,
//         address indexed creator,
//         uint256 indexed timeStamp
//     );

//     event SignerConfirmed(
//         uint256 indexed id,
//         address indexed creator,
//         address indexed sender
//     );
//     event SignerRejected(
//         uint256 indexed id,
//         address indexed creator,
//         address indexed sender
//     );
// }
