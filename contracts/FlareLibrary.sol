// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IFlareContractRegistry {
    function getContractAddressByName(string calldata _name) external view returns(address);
}

interface IWNat {
    function depositTo(address recipient) external payable;
}

library FlareLibrary {
    IFlareContractRegistry private constant flareContractRegistry =
        IFlareContractRegistry(0xaD67FE66660Fb8dFE9d6b1b4240d8650e30F6019);

    function getWNat() internal view returns (IWNat) {
        return IWNat(flareContractRegistry.getContractAddressByName("WNat"));
    }
}
