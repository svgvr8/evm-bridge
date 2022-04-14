// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * Ownable Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 */
contract Controller is Ownable {
    mapping(address => bool) operator;
    /*/
Mapping = It is a reference type, not storage. 
Address is the key type here, 
and bool is the value type where we are looking the stuff up.

operator = person/address who called the txn

With mapping we are checking if the address is a whitelisted address or no.
*/
    modifier onlyOperator() {
        require(operator[msg.sender], "Only-operator");
        _;
    }

    /*/
operator is the msg.sender
*/
    constructor() public {
        operator[msg.sender] = true;
    }

    /*/
SetOperator takes the operator address and a whitelist of addresses.
and now operator is added to the whitelist which is eligible to the swap.
Now operator is set.
Mapping helped us to determine its validity

We could have used the OnlyOwner keyword lol
*/
    function setOperator(address _operator, bool _whiteList) public onlyOwner {
        operator[_operator] = _whiteList;
    }
}
