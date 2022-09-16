// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ordenacao{

    // estrurura para receber  dados para popular o array

    uint256[] public array_prova;
    uint public tamanho;
      
     // funcao para receber dados e popular o array
     function setArry (uint256 _valor) public{

        uint256 valor = _valor;
        array_prova.push(valor);
        
        

    }
    
    // funcao para ordenadar o array usandi metodo  bubblesort
    // este metodo pode ser usado para a implementação da fila e da pilha dos exercicios 1 e 2
    function ordenaArray() public  {

        tamanho = array_prova.length;
        for(uint i=0; i<tamanho -1; i++){

            for(uint j=0; j< tamanho-1; j++){

                if(array_prova[j] > array_prova[j +1]){

                     uint valor_atual = array_prova[j];
                     array_prova[j] = array_prova[j+1];
                     array_prova[j+1] = valor_atual;
                }
            }

        }

  



    }

    // funcao que recebe um indice e retorna o elemento do array

    function getRetorno(uint256 _valor) public view returns (uint256){


        return array_prova[_valor];



    }




     
}
