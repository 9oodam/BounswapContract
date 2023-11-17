import { ethers } from "hardhat";

async function main() {

  // Data.sol
  const dataContract = await ethers.deployContract("Data", []);
  await dataContract.waitForDeployment();
  const dataAddress = await dataContract.getAddress();
  // Factory.sol
  const FactoryContract = await ethers.deployContract("Factory", [dataAddress, '0x0000000000000000000000000000000000000000']);
  await FactoryContract.waitForDeployment();
  const factoryAddress = await FactoryContract.getAddress();
  // PoolConnector.sol
  const PoolConnectorContract = await ethers.deployContract("PoolConnector", [dataAddress, factoryAddress]);
  await PoolConnectorContract.waitForDeployment();
  const poolConnectorAddress = await PoolConnectorContract.getAddress();
  // InitialDeploy.sol
  const InitialDeployContract = await ethers.deployContract("InitialDeploy", [dataAddress, factoryAddress, poolConnectorAddress]);
  await InitialDeployContract.waitForDeployment();

  // 발행된 토큰들의 배열 [wbnc, gov, eth, usdt, bnb]
  const tokenAddressArr = await dataContract.getAllTokenAddress();
  // 배포된 페어들의 배열 [wbnc-eth, wbnc-usdt, wbnc-bnb]
  const pairAddressArr = await dataContract.getAllPairAddress();

  // 4) WBNC, Data contract address를 담아서 Swap.sol
  const SwapContract = await ethers.deployContract("Swap", [dataAddress, tokenAddressArr[0]])
  const swapAddress = await SwapContract.getAddress();

  // 5) Factory, Swap contract address 담아서 Pair.sol 배포 (== InitialProxy를 Pair로 변경)
  const PairContract = await ethers.deployContract("InitialProxy", [factoryAddress, swapAddress, tokenAddressArr[0]]);
  await PairContract.waitForDeployment();

  // 6) Governance
  const GovContract = await ethers.deployContract("Governance", [tokenAddressArr[1]]);
  await GovContract.waitForDeployment();

  // 7) Staking
  // const StakingContract = await ethers.deployContract("Staking", [])
  

  console.log(
    tokenAddressArr,
    pairAddressArr
  )
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
