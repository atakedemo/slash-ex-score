import { ethers } from "hardhat";

async function main() {
  const TargetContract = await ethers.getContractFactory("SampleNFT");
  const targetContract = await TargetContract.deploy();

  await targetContract.deployed();

  console.log(`Contract Deploy -> Success: deployed to ${targetContract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
