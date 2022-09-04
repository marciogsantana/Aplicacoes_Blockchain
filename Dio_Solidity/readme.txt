# instalação web3.js

npm install web3 --save

# acessar console node

node

# importando biblioteca

const Web3 = require('web3')

# criando uma instancia

const web3 = new Web3('http://127.0.0.1:7545')

#testando web3 (ganache)

web3.eth.getAccounts().then(console.log)

# criando uma instancia

##em outro terminal no mesmo diretório

notepad ABI.json  (criar arquivo)
colar conteudo do ABI do contrato no remix

executar:

let abi = require("./ABI.json")  // cria variavel abi com Json do ABI contract
let contract = new web3.eth.Contract(abi,"0x331e5f28A320779B707Fc0d203044a382efFa9e4") // instancia o contrato chamando a variavel abi e o endereço do contrato)

# chamando os metodos do contrato pelo terminal web3

contract.methods.nome_metodo().call().then(console.log)
