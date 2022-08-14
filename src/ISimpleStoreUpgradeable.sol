interface ISimpleStoreUpgradeable {
	error INITIALIZED();
	error NOT_OWNER();
	error unsupported_proxiableUUID();
	function getImpl() external view returns (address);
	function getValue() external view returns (uint256);
	function initialize(address) external;
	function proxiableUUID() external view returns (bytes32);
	function setValue(uint256) external;
	function upgrade(address) external;
}