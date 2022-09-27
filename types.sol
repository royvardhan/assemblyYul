//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

contract YulTypes {

    // Example 1 - Solidity
    function getNumber() external pure returns(uint) {
        return 42;
    }

    // Example 1 - Yul
    function getNumberYul() external pure returns(uint){
        uint x; // first declare the variable

        assembly {
            x := 42 // Yul doesnt have semi-colons
        }

        return x; // this will return x as 42
    }

    function getHex() external pure returns (uint256) {
        uint256 x;

        assembly {
            x := 0xa
        }

        return x;
    }

    function demoString() external pure returns(bytes32) {
        bytes32 myStr;

        assembly {
            myStr := "Hello World"
        }

        return myStr;
    }

    function representation() public pure returns(bool) {
        bool x; // uninitialized

        assembly {
            x := 1 // 1 is equal to true
        }

        return x; // x will now come back as trues   
    }
}