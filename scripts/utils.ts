import { ethers } from "hardhat";

module.exports.deployContract = async function (name: string, params: any) {
  console.log(`Deploying ${name}([${params}])`);

  const contract = await ethers.deployContract(name, params);

  await contract.waitForDeployment();
  const contractAddress = await contract.getAddress();

  console.log(`${name} deployed at: ${contractAddress}`);

  return contract;
};
