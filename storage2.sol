// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract StoragePart1 {
    uint128 public C = 4;
    uint96 public D = 6;
    uint16 public E = 52;
    uint8 public F = 1;

    function readBySlot(uint256 slot) external view returns (bytes32 value) {
        assembly {
            value := sload(slot)
        }
    }

    // NEVER DO THIS IN PRODUCTION
    function writeBySlot(uint256 slot, uint256 value) external {
        assembly {
            sstore(slot, value)
        }
    }

    function getOffsetE() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := E.slot // this will load the slot of E
            offset := E.offset // this will track where exactly is E in the slot 0
        }
    }

    function readE() external view returns (uint16 e) {
        assembly {
            let value := sload(E.slot) // must load in the 32byte increments
            // Now that we have got the value of the E slot, we will shift
            // directly to it by using the Shift Right method
            // Note: We are multiplying the offset of E with 8 because 1 byte  = 8 bit
            // And E.offset returns 32 bytes. And shifting is done in bits. 
            // So finally we are specifying how many bits we want to shift from left to right
            let shifted := shr(mul(E.offset, 8), value)

            // Now we do the masking because shifted still has the value of F in its bytes32 return
            // Note that F is uint8 so we add 0xffff (FX4)

            e := and(0xffff, shifted)

        }
        
    }
    // masks can be hardcoded because variable storage slot and offsets are fixed
    // V and 00 = 00
    // V and FF = V
    // V or  00 = V
    // function arguments are always 32 bytes long under the hood
    function writeToE(uint16 newE) external {
        assembly {
            // newE = 0x000000000000000000000000000000000000000000000000000000000000000a
            let c := sload(E.slot) // slot 0
            // c = 0x0000010800000000000000000000000600000000000000000000000000000004
            let clearedE := and(
                c,
                0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            )
            // mask     = 0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            // c        = 0x0001000800000000000000000000000600000000000000000000000000000004
            // clearedE = 0x0001000000000000000000000000000600000000000000000000000000000004
            let shiftedNewE := shl(mul(E.offset, 8), newE)
            // shiftedNewE = 0x0000000a00000000000000000000000000000000000000000000000000000000
            let newVal := or(shiftedNewE, clearedE)
            // shiftedNewE = 0x0000000a00000000000000000000000000000000000000000000000000000000
            // clearedE    = 0x0001000000000000000000000000000600000000000000000000000000000004
            // newVal      = 0x0001000a00000000000000000000000600000000000000000000000000000004
            sstore(C.slot, newVal)
        }
    }


}