/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require('dotenv').config({
  path: __dirname + '/.env'
});
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

const {
  API_URL,
  API_KEY,
  PRIVATE_KEY,
  ETHERSCAN_API_KEY
} = process.env;

module.exports = {
  solidity: "0.8.1",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      url: API_URL,
      accounts: [PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  }
};