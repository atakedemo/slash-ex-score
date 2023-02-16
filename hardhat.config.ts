
// hardhat.config.js

require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

const { API_URL_GOERLI, API_URL_MUMBAI,PRIVATE_KEY } = process.env;

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/** @type import('hardhat/config').HardhatUserConfig */
// etherscan以降 -> polygonscanの設定へ変更
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "goerli",
  networks: {
    mumbai: {
      url: API_URL_MUMBAI,
      accounts: [PRIVATE_KEY]
    },
    goerli: {
      url: API_URL_GOERLI,
      accounts: [PRIVATE_KEY]
   }
  },
};