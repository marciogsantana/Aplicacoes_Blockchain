// importando as dependencias 
const bip32 = require('bip32')
const bip39 = require('bip39')
const bitcoin = require('bitcoinjs-lib')

// definir a rede
// rede principal do bitcoin mainnet = bitcoin
// rede de teste testnet = testnet
// estamos usando a rede de testes para o projeto

const network = bitcoin.networks.testnet

// derivação da carteira HD (deterministic hierarchical)
// `m/49'/0'/0'/0`   derivação para rede principal
// `m/49'/1'/0'/0`   derivação para rede teste

const path = `m/49'/1'/0'/0` 

// criado a chave mnemonica para seed (palavras de senha)

let mnemonic = bip39.generateMnemonic()
const seed = bip39.mnemonicToSeedSync(mnemonic)

// criando a raiz da carteira HD

let root = bip32.fromSeed(seed, network)

// criando uma conta par de privat e public keys

let account = root.derivePath(path)
let node = account.derive(0).derive(0)

// criando o endereço 

let btcAdress = bitcoin.payments.p2pkh({
    pubkey: node.publicKey,
    network: network,
}).address

// escrevendo as informaçõe da carteira

console.log("Carteira Gerada")
console.log("Endereço: ", btcAdress)
console.log("Chave privada ", node.toWIF())   //node,toWIF para formatar a chave para ser importada para um carteira
console.log("Seed", mnemonic)





