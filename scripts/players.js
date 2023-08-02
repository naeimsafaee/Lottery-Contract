require("dotenv").config()

const {createAlchemyWeb3} = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(process.env.SEPOLIA_RPC)

const contract = require("../artifacts/contracts/Lottery.sol/Lottery.json")

const contractAddress = process.env.CONTRACT;
const Contract = new web3.eth.Contract(contract.abi, contractAddress);

// const account = process.env.ACCOUNT1;

Contract.methods.getPlayers().call()
    .then(data => console.log(data))
    .catch(err => console.log(err));



