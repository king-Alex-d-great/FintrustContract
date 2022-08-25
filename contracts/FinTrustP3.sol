// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.9;

// import "./Fintrust.sol";

// /// @title Fintrust fundraiser
// /// @author OGUBUIKE ALEX
// /// @notice A contract that handles decentralized societal funding
// /// @dev This contract manages donations and withdrawal of funds.
// contract FintrustP3 is Fintrust {
//     /// @notice Get a campaign
//     /// @param creator The address of the creator of the context campaign
//     /// @param _campaignId The campaign Id
//     function getCampaign(uint256 _campaignId, address creator)
//         external
//         view
//         returns (Campaign memory)
//     {
//         return creators[creator][_campaignId];
//     }

//     /// @notice Get all camo\paigns created by an address
//     /// @param creator The address of the creator of the context campaign
//     function allCampaigns(address creator)
//         external
//         view
//         returns (Campaign[] memory)
//     {
//         return creators[creator];
//     }

//     /// @notice Get users capaign reference
//     /// @param signatory The address of the signatory
//     function allRef(address signatory)
//         external
//         view
//         returns (CampaignRef[] memory)
//     {
//         return signatories[signatory];
//     }

//     /// @notice Get all campaigns where withdawal request has been initiated
//     /// @param signatory The address of the signatory
//     function allWithdrawRequest(address signatory)
//         external
//         view
//         returns (Campaign[] memory _campaigns)
//     {
//         CampaignRef[] memory _campaignRefs = signatories[signatory];
//         uint256 index = 0;

//         for (uint256 i = 0; i < _campaignRefs.length; i++) {
//             address initiator = _campaignRefs[i].initiator;
//             uint256 id = _campaignRefs[i].id;

//             Campaign memory _campaign = creators[initiator][id];

//             if (_campaign.withdrawInitiated) {
//                 _campaigns[index] = _campaign;
//                 index += 1;
//             }
//         }
//     }

//     /// @notice Get all campaigns ever created
//     function getAllCampaigns() external view returns (Campaign[] memory) {
//         return campaigns;
//     }
// }
