require('dotenv').config();

const {
  API_URL,
  API_KEY,
  PRIVATE_KEY,
  PUBLIC_KEY,
  CONTRACT_ADDRESS,
  TOKEN_URI
} = process.env;


const {
  ethers
} = require("hardhat");

const contract = require("../artifacts/contracts/SmartNFT.sol/SmartNFT.json")
// console.log(JSON.stringify(contract.abi))

const provider = new ethers.providers.AlchemyProvider(network = "goerli", API_KEY);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);
const etherInterface = new ethers.utils.Interface(contract.abi);

async function mintNFT() {
  // Get latest nonce
  const nonce = await provider.getTransactionCount(PUBLIC_KEY, 'latest');
  console.log("nonce is: ", nonce);
  // Get gas price
  const gasPrice = await provider.getGasPrice();
  console.log("gasPrice is: ", gasPrice);
  // Get network
  const network = await provider.getNetwork();
  const {
    chainId
  } = network;
  console.log("chainId is: ", chainId);
  // The transaction
  const txn = {
    from: PUBLIC_KEY,
    to: CONTRACT_ADDRESS,
    nonce: nonce,
    gasPrice: gasPrice,
    data: etherInterface.encodeFunctionData("publishNFT", [PUBLIC_KEY, TOKEN_URI])
  };
  // Estimate gas limit
  const estdGas = await provider.estimateGas(txn);
  console.log("estdGas is: ", estdGas);
  txn["gasLimit"] = estdGas;
  // Sign & Send transaction
  const signedTxn = await signer.signTransaction(txn);
  const txnReceipt = await provider.sendTransaction(signedTxn);
  await txnReceipt.wait();
  const hash = txnReceipt.hash;
  console.log("txn hash is:", hash);
  // Get transaction receipt
  const receipt = await provider.getTransactionReceipt(hash);
  console.log('transaction receipt ', receipt);
  const {
    logs
  } = receipt;
  // Get token ID
  console.log('transaction logs ', logs);
  const tokenInBigNumber = ethers.BigNumber.from(logs[0].topics[3]);
  const tokenId = tokenInBigNumber.toNumber();
  console.log("tokenId minted: ", tokenId);

}

mintNFT();