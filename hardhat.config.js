/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const {PRIVATE_KEY} = process.env;

module.exports = {
    solidity: "0.8.0",
    defaultNetwork: "sepolia",
    networks: {
        hardhat: {},
        matic: {
            url: "https://polygon-mainnet.g.alchemy.com/v2/5erzRBZJq6jgkXdWxOsi8S6sfeiJMdDe",
            accounts: [`0x${PRIVATE_KEY}`]
        },
        mumbai: {
            url: "https://rpc-mumbai.maticvigil.com",
            accounts: [`0x${PRIVATE_KEY}`]
        },
        sepolia: {
            url: process.env.SEPOLIA_RPC,
            accounts: [`0x${PRIVATE_KEY}`]
        }
    }
}