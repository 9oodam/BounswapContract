import { ethers } from "hardhat";

async function main() {

  // 1) Data.sol
  const dataContract = await ethers.deployContract("Data", []);
  await dataContract.waitForDeployment();
  const dataAddress = dataContract.getAddress();
  // 2) Data contract address를 담아서 Factory.sol 배포
  const FactoryContract = await ethers.deployContract("Factory", [dataAddress, '0x0000000000000000000000000000000000000000']);
  await FactoryContract.waitForDeployment();
  const factoryAddress = FactoryContract.getAddress();
  // 3) InitialDeploy.sol
  const InitialDeployContract = await ethers.deployContract("InitialDeploy", [dataAddress, factoryAddress]);
  await InitialDeployContract.waitForDeployment();

  // 4) WBNC, Data contract address를 담아서 Swap.sol
  const wbncAddress = await dataContract.getAllTokenAddress();
  const SwapContract = await ethers.deployContract("Swap", [dataAddress, wbncAddress[0]])
  // 5) Factory, Swap contract address 담아서 InitialProxy.sol 배포
  const swapAddress = SwapContract.getAddress();
  const InitialProxyContract = await ethers.deployContract("InitialProxy", [factoryAddress, swapAddress, wbncAddress[0]]);
  await InitialProxyContract.waitForDeployment();

  console.log(
    await InitialDeployContract.getAddress()
  )
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
