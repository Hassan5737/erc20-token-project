// SPDX-License-Identifier: MIT
pragma solidity ^0.8.31;

import "forge-std/Test.sol";
import "../src/Hassan.sol";
import "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HassanTest is Test {
    Hassan public token;
    address public owner;
    address public alice;
    address public bob;

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        token = new Hassan("Hassan", "HSN");
    }

    //constructor
    function test_constructor_setsName() public view {
        assertEq(token.name(), "Hassan");
    }
    function test_constructor_setsSymbol() public view {
        assertEq(token.symbol(), "HSN");
    }

    function test_constructor_setsOwner() public view {
        assertEq(token.owner(), owner);
    }
    
    function test_constructor_zeroInitialSupply() public view {
        assertEq(token.totalSupply(), 0);
    }

    function test_decimals() public view {
        assertEq(token.decimals(), 18);
    }

    // mint
    function test_mint_asOwner() public {
        token.mint(alice, 1000 ether);
        assertEq(token.balanceOf(alice), 1000 ether);
        assertEq(token.totalSupply(), 1000 ether);
    }

    function test_mint_toMultipleAddresses() public {
        token.mint(alice, 500 ether);
        token.mint(bob, 300 ether);
        assertEq(token.balanceOf(alice), 500 ether);
        assertEq(token.balanceOf(bob), 300 ether);
        assertEq(token.totalSupply(), 800 ether);
    }

    function test_mint_revertIfOwner() public {
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice )
        );
        token.mint(alice, 1000 ether);
    }

    function test_mint_revertIfMintToZeroAddress () public {
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0)));
            token.mint(address(0), 1000 ether);
    }

    //  transfer
    function test_transfer_success() public {
        token.mint(alice, 1000e18);
        vm.prank(alice);
        bool ok = token.transfer(bob, 400e18);
        assertTrue(ok);
        assertEq(token.balanceOf(alice), 600e18);
        assertEq(token.balanceOf(bob), 400e18);
    }

    function test_transfer_revertInsufficientBalance() public {
        token.mint(alice, 100e18);
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientBalance.selector, alice, 100e18, 200e18
            )
        );
        token.transfer(bob, 200e18);
    }

    function test_transfer_revertToZeroAddress() public {
        token.mint(alice, 100e18);
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0))
        );
        token.transfer(address(0), 50e18);
    }

    function test_transfer_emitsEvent() public {
        token.mint(alice, 100e18);
        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit IERC20.Transfer(alice, bob, 50e18);
        token.transfer(bob, 50e18);
    }

}