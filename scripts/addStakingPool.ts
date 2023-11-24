import { ethers } from "hardhat";

async function main() {

    const StakingContract = await ethers.getContractAt("Staking", '0x');
    StakingContract.addStakingPool(100, '0x', 30);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
