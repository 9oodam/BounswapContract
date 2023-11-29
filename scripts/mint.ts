import { ethers } from "hardhat";

async function main() {

    const GovToken = await ethers.getContractAt("Token", "0x512C9916d31Cb3d8f309A4556A5346B0265eF95d");
    const amount = ethers.parseEther("10.0");
    GovToken._mint("0x35BF335fef91E0ac59799850E59e598301dBC040", amount)

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
