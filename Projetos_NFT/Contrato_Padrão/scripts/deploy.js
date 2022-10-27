async function main() {
  const SmartNFT = await ethers.getContractFactory("SmartNFT")
  const smart_nft = await SmartNFT.deploy()
  await smart_nft.deployed()
  console.log("Deployed contract address: ", smart_nft.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })