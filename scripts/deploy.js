
async function main() {
    // const ZiZiLove = await ethers.getContractFactory("ZiZiLove")

    // Start deployment, returning a promise that resolves to a contract object
   /* const myNFT = await ZiZiLove.deploy()
    await myNFT.deployed()
    console.log("Contract deployed to address:", myNFT.address)*/

    const Lottery = await ethers.getContractFactory("Lottery")

    const myContract = await Lottery.deploy();
    await myContract.deployed()
    console.log("Contract deployed to address:", myContract.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
