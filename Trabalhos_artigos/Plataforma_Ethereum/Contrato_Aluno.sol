// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./PucCoin.sol";

/** 
 * @title  Contrato do aluno
 * @dev Armazena os tokens PUC
 * @author Carlos Leonardo dos S. Mendes
 */
contract ContratoAlunoPUCMG202202 {

    PucCoin private token;                  // contrato do PUC token
    address private aluno;                  // conta do aluno
    address private professor;              // conta do professor na Ethereum
    address private contratoDisciplina;     // conta do contrato da disciplina

    // indica se o resgate está liberado
    bool private resgateLiberado = false;

    /* modificador para verificar se é o contrato da disciplina */
    modifier apenasContratoDisciplina() {
        require(msg.sender == contratoDisciplina, unicode"Apenas o contrato da disciplina pode realizar essa operação.");
        _;
    }

    /* modificador para verificar se é aluno */
    modifier apenasAluno() {
        require(msg.sender == aluno, unicode"Apenas o aluno dono do contrato pode realizar essa operação.");
        _;
    }

    event ResgateLiberado(address aluno, uint256 saldo);

    /* Construtor. Recebe como parâmetro o endereço do contrato da disciplina */
    constructor(address _contratoDisciplina) {
        aluno = msg.sender;
        contratoDisciplina = _contratoDisciplina;
    }

    /* Registra na disciplina */
    function registra(PucCoin _token, address _professor) public apenasContratoDisciplina {
        token = _token;
        professor = _professor;
    }

    /* Cancela registro na disciplina */
    function cancelaRegistro() public apenasContratoDisciplina {
        uint256 saldo = token.balanceOf(address(this));
        token.transfer(contratoDisciplina, saldo);
    }

    /* Libera resgate dos tokens */
    function liberaResgate() public apenasContratoDisciplina {
        resgateLiberado = true;

        uint256 saldo = token.balanceOf(address(this));
        emit ResgateLiberado(aluno, saldo);
    }

    /* Resgata os tokens do contrato */
    function resgate() public apenasAluno {
        require(resgateLiberado, unicode"O resgate não foi liberado pelo professor.");

        uint256 saldo = token.balanceOf(address(this));
        token.transfer(aluno, saldo);
    }

    /* Retorna endereço do proprietário do contrato */
    function getProprietario() public view returns (address _owner) {
        _owner = aluno;
    }
}
