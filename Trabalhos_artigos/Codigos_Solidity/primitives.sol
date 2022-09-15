// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Primitives {
    bool public boo = true;

    uint8 public u8 = 1;
    uint public u256 = 456;
    uint public u = 123; // uint is an alias for uint256

    int8 public i8 = -1;
    int public i256 = 456;
    int public i = -123; // int is same as int256

    int public minInt = type(int).min;
    int public maxInt = type(int).max;

    address public addr = 0x0000000000000000000000000000000000000000;

    bytes1 a = 0xb5; //  [10110101]
    bytes1 b = 0x56; //  [01010110]

    bool public defaultBoo; // false
    uint public defaultUint; // 0
    int public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000
}
