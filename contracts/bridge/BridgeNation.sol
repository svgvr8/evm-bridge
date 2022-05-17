//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../deps/Controller.sol";

/** What should this code do? 
- 1. Lock the token & supplies
- 2. Unlock the token supply from an authoirized member after cross-chain migration
 */

contract BridgeNation {
    // Amount that needs to be burned
    event CrossChainBurn(uint256 amount);

    // The constructor takes the CHAIN ID
    constructor(uint256[] memory chainList) public MultiBridge(chainList) {}

    // function to lock the assets in the chain A
    function lock(
        address to,
        uint256 amount,
        uint256 chain
    ) external payable override validFunding validChain(chain) {
        // Lock the GTOKEN of the above address
        uint256 lockAmount = GTOKEN.balanceOf(address(this));
        GTOKEN.safeTransferFrom(msg.sender, address(this), amount);
        lockAmount = GTOKEN.balanceOf(address(this)).sub(lockAmount);
        // ++ increases the transfer value by 1, why? for gas.
        uint256 id = crossChainTransfer++;

        outwardTransfers[id] = CrossChainTransfer(
            to,
            false,
            safe88(
                tx.gasprice,
                "Multibridge::lock: tx gas price exceeds 32 bits"
            ),
            amount,
            chain
        );

        // Optionally captured by off-chain migrator
        emit CrossChainTransferLocked(msg.sender, id);
    }

    /*/
SatelliteChain is basically the chain you will bridge to.
*/
    function unlock(
        uint256 satelliteChain,
        uint256 i,
        address to,
        uint256 amount
    ) external override onlyOperator {
        bytes32 h = keccak256(abi.encode(satelliteChain, i, to, amount));
        emit CrossChainTransferUnlocked(to, amount, satelliteChain);
    }

    function burn(uint256 amount) external onlyOperator {
        ERC20Burnable(address(GTOKEN)).burn(amount);
        emit CrossChainBurn(amount);
    }
}
