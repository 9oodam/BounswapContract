import { ethers } from "hardhat";

async function main() {

  // 1) Data.sol
  const dataContract = await ethers.deployContract("Data", []);
  await dataContract.waitForDeployment();
  const dataAddress = dataContract.getAddress();
  // 2) InitialDeploy.sol
  const InitialDeployContract = await ethers.deployContract("InitialDeploy", [dataAddress]);
  await InitialDeployContract.waitForDeployment();

  // 3) Data contract address를 담아서 Factory.sol 배포
  const FactoryContract = await ethers.deployContract("Factory", [dataAddress, '0x0000000000000000000000000000000000000000']);
  await FactoryContract.waitForDeployment();
  // 4) WBNC, Data contract address를 담아서 Swap.sol
  const wbncAddress = await dataContract.getAllTokenAddress();
  const SwapContract = await ethers.deployContract("Swap", [dataAddress, wbncAddress[0]])
  // 5) Factory, Swap contract address 담아서 InitialProxy.sol 배포
  const factoryAddress = FactoryContract.getAddress();
  const swapAddress = SwapContract.getAddress();
  const InitialProxyContract = await ethers.deployContract("InitialProxy", [factoryAddress, swapAddress, wbncAddress[0]]);
  await InitialProxyContract.waitForDeployment();


  // ---- staking ---- 
    
    const BNCTokenAddress = wbncAddress[0]; 
    const dev0Addr = "0x0000000000000000000000000000000000000002"; 
    const dev0Percent = 1000; 
    const stakingPercent = 5000; 
    const BNCPerBlock = 1; // 1 BNC
    const startBlock = 123456; 
    const initialOwner = "0x0000000000000000000000000000000000000003"; // Owner
  
    const StakingContract = await ethers.deployContract("Staking", [
      BNCTokenAddress,
      // dataAddress,
      dev0Addr,
      dev0Percent,
      stakingPercent,
      BNCPerBlock,
      startBlock,
      initialOwner
    ]);
    await StakingContract.waitForDeployment();
    const stakingAddress = StakingContract.getAddress();
    // ------------------
  
  console.log(
    await InitialDeployContract.getAddress()
  )
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
