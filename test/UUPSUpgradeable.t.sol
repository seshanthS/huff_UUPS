// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Proxy.sol";

contract SimpleStoreTest is Test {
    /// @dev Address of the SimpleStore contract.  
    SimpleStore public simpleStoreLogic;
    SimpleStore public simpleStore;

    /// @dev Setup the testing environment.
    function setUp() public {
        simpleStoreLogic = SimpleStore(HuffDeployer.deploy("SimpleStoreUpgradeable"));
        simpleStore = SimpleStore(
            address(
                new Proxy(
                    abi.encodeWithSelector(SimpleStore.initialize.selector, address(this)),
                    address(simpleStoreLogic)
                )
            )
        );
    }

    function testProxyInit() public {
        assert(address(simpleStoreLogic) == simpleStore.getImpl());
    }

    function testproxiableUUID() public {
        assert(simpleStore.proxiableUUID() == 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7);
    }

    /// @dev Ensure that you can set and get the value.
    function testSetAndGetValue(uint256 value) public {
        simpleStore.setValue(value);
        console.log(value);
        console.log(simpleStore.getValue());
        assertEq(value, simpleStore.getValue());
    }

    function testUpgrade(uint256 value) public {
        simpleStore.setValue(value);

        address newImpl = HuffDeployer.deploy("SimpleStoreUpgradeable");
        simpleStore.upgrade(newImpl);
        assert(newImpl == simpleStore.getImpl());

        assertEq(value, simpleStore.getValue());
    }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);

    function upgrade(address newImpl) external;
    function initialize(address admin) external;
    function getImpl() external view returns (address);
    function proxiableUUID() external view returns (bytes32);
}
