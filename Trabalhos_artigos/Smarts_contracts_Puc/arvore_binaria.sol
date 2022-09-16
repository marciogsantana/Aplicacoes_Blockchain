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

// contract busca heda contrato ordenacao

contract busca is ordenacao{

    // Observação professor na implementação do if e else tenho que fazer mais pesquisar como implementar
    // de acordo com os comhecimentos que tenho de arvore binaria
    // estou com muitos erros de sintaxe no codigo da arvore e não vair dar tempo de entregar corridigo
    // vou continuar a implementação apos a entrega 
    // vou pedir uma ajuda do Sr para terminar

    uint256 valor;
        
   // function setBusca (uint256 _valor) view returns (uint256) {


    //    valor = _valor;
    //    uint256 end = array_prova.length - 1;
    //    uint begin = 0;
        // if( begin <= fim){
                   
        //      m = (begin + end) /2
              
         
        //    if (array_prova[m] == valor){
                          
        //        return m;
        //    }           
        //    if valor < array_prova[m]{
        //        return  m;
        //    }
        //    else{
        //        return m;
        //    }  
         
       //  return valor;


          





    }
