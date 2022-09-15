// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract prova{

    // estrurura de pilha de inteiros usando usando array 

    uint256[] public array_prova;
    uint256 public valor;
    uint256 public contador;
   
    
     // funcao recebe um valor e adiciona no final do array
     function setArray (uint256 _valor) public{

        
        array_prova.push(_valor);
        contador = array_prova.length;



    }
     
    // funcao retorno sempre o ultimo elemento do array
    function getNumero() public view returns (uint){

        
        return  array_prova[contador -1];

    }


     
    }
