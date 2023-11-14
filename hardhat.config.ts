import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ethers";
import "hardhat-deploy";
import "hardhat-docgen";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    // localhost: {
    //   url: "http://127.0.0.1:8545/",
    // },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.DEPLOYER as string],
      // chainId: 11155111,
    },
    bounce: {
      url: 'https://network.bouncecode.net/',
      accounts: [process.env.DEPLOYER as string],
      chainId: 18328,
    }
  },
  docgen: {
    path: './docs',
    clear: true,
  }
};

export default config;