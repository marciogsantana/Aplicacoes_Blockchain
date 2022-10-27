// contracts/SmartNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// importação bibliotecas openzeppelin 
// usar extensão Juan blanco versão 00135

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SmartNFT is ERC721URIStorage, Ownable {

    // variavel para armazenar contador
    using Counters for Counters.Counter;

    //  cada token mintado seu regsitro unico será armazendo na variavel _tokenIds
    Counters.Counter private _tokenIds;


    // construtur recebe como parametros o nome e o simbolo do token

    constructor() ERC721("SmartNFT", "SMRT") {}

    // funcao publicshNFT recebe um endereco de carteira e uma url do token

    function publishNFT(address user, string memory tokenURI) public onlyOwner returns (uint256){
        _tokenIds.increment();   //  incrementa _tokenIds para não ter tokens com mesma identificação
        uint256 newItemId = _tokenIds.current(); // newItemId recebe o incremento
        _mint(user, newItemId); // minta o token na carteira com a sua identificação unica
        _setTokenURI(newItemId, tokenURI); // defini o valor unico do token com o seu endereço de url
        return newItemId;  // retorna id do token criado
    }
}
