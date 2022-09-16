// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract prova_fila{

    // estrurura de fila de inteiros usando usando array 

    uint256[] public array_prova_fila;
    uint256 public contador_fila;
    
     // funcao para popular array
     function setArry_fila (uint256 _valor) public{

        uint256 valor = _valor;
        array_prova_fila.push(valor);
        contador_fila = array_prova_fila.length;


    }

     // funcao para retornar piemira posicao
     function getNumero_fila() public view returns (uint){
                
        uint256 _valor = contador_fila - contador_fila;
        return array_prova_fila[_valor];
    }

}

    contract prova_pilha {

    // estrurura de pilha de inteiros usando usando array 

    uint256[] public array_prova;
    uint256 public valor;
    uint256 public contador;
   
    
     // funcao recebe um valor e adiciona no final do array
     function setArray_pilha (uint256 _valor) public{

        
        array_prova.push(_valor);
        contador = array_prova.length;



    }
     
    // funcao retorno sempre o ultimo elemento do array
    function getNumero_pilha() public view returns (uint){

        
        return  array_prova[contador -1];

    }


     
    }



contract teste is prova_fila, prova_pilha {


    

}