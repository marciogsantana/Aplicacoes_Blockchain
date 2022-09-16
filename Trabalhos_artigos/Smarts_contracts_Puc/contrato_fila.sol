// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract prova{

    // estrurura de fila de inteiros usando usando array 

    uint256[] public array_prova;
    uint256 public contador;
    
    // funcao recebe um valor e adiciona no final no array
     function setArry (uint256 _valor) public{

        uint256 valor = _valor;
        array_prova.push(valor);
        contador = array_prova.length;


    }

     // funcao retorna o primeiro valor do array indice 0
     function getNumero() public view returns (uint){
                
        uint256 _valor = contador - contador;
        return array_prova[_valor];
    }






}

