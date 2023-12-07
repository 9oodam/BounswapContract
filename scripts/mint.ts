import { ethers } from "hardhat";

async function main() {

  const GovToken = await ethers.getContractAt("Token", "0x50DAa4D206Fbe5696Ea3424372EB7159F7F23014");
  const govAmount = ethers.parseEther("1.0");
  GovToken._burn("0x84497C1CFf5D54FD6C28ABf7df2857B69c2599ea", govAmount)

  // const StakingContract = await ethers.getContractAt("Staking", "0x8d11bA6576E25149009E9136Dd85899136fDc904")
  // StakingContract.addStakingPool(10000, "0x0E32cE79feCaa0d75f25eAEA43AD3e2f3F375088", 30);

  // const StkToken = await ethers.getContractAt("Pool", "0x0E32cE79feCaa0d75f25eAEA43AD3e2f3F375088");
  // const stkAmount = ethers.parseEther("10.0");
  // StkToken._mint("0xB549242F0B9ed80F636B5ba19aa206b70832e212", stkAmount);

  // const EthToken = await ethers.getContractAt("Token", "0x29E9cF8ef1C63eA518BC2F7D7401B85B47755c50");
  // const UsdtToken = await ethers.getContractAt("Token", "0x53DB75EAD5aC22FB63527D0957dB686300cE1569");
  // const BnbToken = await ethers.getContractAt("Token", "0xDe699F3525b22f4af88d748fB6fB701861926945");
  // const amount = ethers.parseEther("10.0");
  // EthToken._mint("0x84497C1CFf5D54FD6C28ABf7df2857B69c2599ea", amount);
  // UsdtToken._mint("0x84497C1CFf5D54FD6C28ABf7df2857B69c2599ea", amount);
  // BnbToken._mint("0x84497C1CFf5D54FD6C28ABf7df2857B69c2599ea", amount);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
