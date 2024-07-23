import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-solhint";
import "dotenv/config";

let accounts = [
  {
    // owner
    privateKey:
      "0xc5e8f61d1ab959b397eecc0a37a6517b8e67a0e7cf1f4bce5591f3ed80199122",
    balance: "100000000000000000000000000000000",
  },
  {
    // submit
    privateKey:
      "0xd49743deccbccc5dc7baa8e69e5be03298da8688a15dd202e20f15d5e0e9a9fb",
    balance: "0",
  },
  {
    // submitSignatures
    privateKey:
      "0x23c601ae397441f3ef6f1075dcb0031ff17fb079837beadaf3c84d96c6f3e569",
    balance: "0",
  },
  {
    // signingPolicy
    privateKey:
      "0xee9d129c1997549ee09c0757af5939b2483d80ad649a0eda68e8b0357ad11131",
    balance: "0",
  },
  {
    // recipient1
    privateKey:
      "0x87630b2d1de0fbd5044eb6891b3d9d98c34c8d310c852f98550ba774480e47cc",
    balance: "0",
  },
  {
    // recipient2
    privateKey:
      "0x275cc4a2bfd4f612625204a20a2280ab53a6da2d14860c47a9f5affe58ad86d4",
    balance: "0",
  },
];

type Network = "coston" | "coston2" | "songbird" | "flare";

function getAccounts() {
  const key = process.env.DEPLOYER_PRIVATE_KEY;
  return [
    key ?? "0x0000000000000000000000000000000000000000000000000000000000000000",
  ];
}

function getRpcUrl(network: Network) {
  return `https://${network}-api.flare.network/ext/bc/C/rpc`;
}

function getApiUrl(network: Network) {
  return `https://${network}-explorer.flare.network/api`;
}

function getBrowserUrl(network: Network) {
  return `https://${network}-explorer.flare.network/`;
}

const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      accounts,
    },
    coston: {
      url: getRpcUrl("coston"),
      chainId: 16,
      accounts: getAccounts(),
    },
    coston2: {
      url: getRpcUrl("coston2"),
      chainId: 114,
      accounts: getAccounts(),
    },
    songbird: {
      url: getRpcUrl("songbird"),
      chainId: 19,
      accounts: getAccounts(),
    },
    flare: {
      url: getRpcUrl("flare"),
      chainId: 14,
      accounts: getAccounts(),
    },
  },
  solidity: {
    version: "0.8.19",
    settings: {
      metadata: {
        bytecodeHash: "none",
      },
      evmVersion: "london",
      optimizer: {
        enabled: true,
        runs: 10000,
      },
    },
  },
};

export default config;
