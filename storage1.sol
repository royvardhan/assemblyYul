//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract Storage {

    uint public x = 2; // added public for the getter function // slot 0
    uint public y = 10;
    uint public z = 12;

    // Now lets look at the example where vairable are packed in the same slot
    // Use bitshifting and masks to get the value of different var from same slot
    uint128 a;
    uint128 b;

    function getSlot() external pure returns(uint slot) {
        assembly {
            slot := a.slot
            // slot := a.slot // This will return the same value
        }
    }

    // Example 1 - the normal way of changing the state variables
    function setX (uint _neVal) external {
        x = _neVal;
    }

    // Example 1 - the Yul way

    function getXYul() external view returns(bytes32 ret) {
        // Only local variable are supported
        // To use storage vairable use .slot .offset
        // .slot or say x.slot will point to the memory location of x
        // Keep in mind that x.slot will not actually return x

        // assembly {
        //     ret := x.slot  // This will return 0 because X is stored at slot 0
        // }

        assembly {
            ret := sload(x.slot) // This will load the slot where X is stored
        }
    }

    function loadSlot(uint _slot) external view returns(bytes32 ret) {
        assembly {
            ret := sload(_slot)
        }
    }

    function writeToSlot(uint _slot, uint _val) external {
        assembly {
            sstore(_slot, _val) // using sstore we are able to write to a specific slot
        }
    }

}