//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/** What should this code do? 
- 1. Lock the token & supplies
- 2. Unlock the token supply from an authoirized member after cross-chain migration
 */

contract BridgeNation {
    event CrossChainBurn(uint256 amount);

    constructor() {}

    function lockToken() public {}

    function unlockToken() public {}
}
