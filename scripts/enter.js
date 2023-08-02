require("dotenv").config()

const {createAlchemyWeb3} = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(process.env.SEPOLIA_RPC)

const contract = require("../artifacts/contracts/Lottery.sol/Lottery.json")

const contractAddress = process.env.CONTRACT;
const nftContract = new web3.eth.Contract(contract.abi, contractAddress);

const account = process.env.ACCOUNT1;

async function enter() {
    // const nonce = await web3.eth.getTransactionCount(account, 'latest'); //get latest nonce
    const nonce =  (await web3.eth.getTransactionCount(account)) + 1;

    console.log({nonce})
    //the transaction
    const tx = {
        'from': account,
        'to': contractAddress,
        'nonce': nonce,
        'gas': 10000000,
        'data': nftContract.methods.enter().encodeABI(),
        'value': 10000000000000000
    };

    const signPromise = web3.eth.accounts.signTransaction(tx, process.env.PRIVATE_KEY_PLAYER)
    signPromise
        .then((signedTx) => {
            web3.eth.sendSignedTransaction(
                signedTx.rawTransaction,
                function (err, hash) {
                    if (!err) {
                        console.log(
                            "The hash of your transaction is: ",
                            hash,
                            "\nCheck Alchemy's Mempool to view the status of your transaction!"
                        )
                    } else {
                        console.log(
                            "Something went wrong when submitting your transaction:",
                            err
                        )
                    }
                }
            )
        })
        .catch((err) => {
            console.log(" Promise failed:", err)
        })
}

enter()



