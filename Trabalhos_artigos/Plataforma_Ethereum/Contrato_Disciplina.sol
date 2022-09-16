// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./PucCoin.sol";
import "./Contrato_Aluno.sol";

/** 
 * @title  DisciplinaPlataformaEthereumPUCMG202202
 * @dev Define regras de partcipação na disciplina Plataforma Ethereum, PUCMG
 * @author Carlos Leonardo dos S. Mendes
 */
contract DisciplinaPlataformaEthereumPUCMG202202 {

    address private professor;      // conta do professor na Ethereum
    PucCoin private token;          // token PUC

    // modificador para verificar se é professor
    modifier apenasProfessor() {
        require(msg.sender == professor, unicode"Apenas o professor pode realizar essa operação.");
        _;
    }

    // Aluno
    struct Aluno {
        string nome;            // nome do aluno
        address contrato;       // contrato de recebimento de token na Ethereum
        bool registrado;        // se já está registrado na disciplina
        bool verificado;        // se já foi verificado pelo professor
        bool resgateLiberado;   // se o resgate já foi liberado para o aluno
        bool checkinAula01;     // checkin aula01, aula02....
        bool checkinAula02;
        bool checkinAula03;
        bool checkinAula04;
        bool checkinAula05;
    }

    // Flags para indicar checkin aberto para as aulas
    bool[] private sessaoAulaAberta;

    // Alunos da disciplina 
    mapping(address => Aluno) private alunos;
    address[] private alunosRegistrados;

    // Eventos da disciplina
    event Registro(string nome, address aluno, address contrato);
    event CancelaRegistro(string nome, address aluno);
    event Checkin(string nome, address aluno, uint aula);

    // Construtor 
    constructor(PucCoin coin) {
        professor = msg.sender;
        token = coin;

        for (uint aula = 0; aula < 5; aula++) {
            sessaoAulaAberta.push(false);
        }
    }

    /* Operação de registro na disciplina */
    function registra(string memory nome, address contrato) public {
        Aluno memory aluno = alunos[msg.sender];
        require(!aluno.registrado, unicode"Aluno já está registrado na disciplina.");
        
        ContratoAlunoPUCMG202202 contratoAluno = ContratoAlunoPUCMG202202(contrato);
        address owner = contratoAluno.getProprietario();
        require(owner == msg.sender, unicode"O contrato informado não pertence ao aluno.");

        alunos[msg.sender] = Aluno({
            nome: nome,
            contrato: contrato,
            registrado: true,
            verificado: false,
            resgateLiberado: false,
            checkinAula01: false,
            checkinAula02: false,
            checkinAula03: false,
            checkinAula04: false,
            checkinAula05: false
        });

        contratoAluno.registra(token, professor);
        alunosRegistrados.push(msg.sender);

        emit Registro(nome, msg.sender, contrato);
    }

    /* Operação para cancelar o registro do aluno da disciplina */
    function cancelaRegistro(address addAluno) public apenasProfessor {
        Aluno storage aluno = alunos[addAluno];
        require(aluno.registrado, unicode"Aluno não está registrado na disciplina.");
        require(!aluno.resgateLiberado, unicode"Não é possível cancelar o registro. O resgate já foi liberado.");
 
        aluno.registrado = false;
        ContratoAlunoPUCMG202202 contratoAluno = ContratoAlunoPUCMG202202(aluno.contrato);
        contratoAluno.cancelaRegistro();

        // Retira do arranjo de alunos registrados
        for (uint i=0; i<alunosRegistrados.length; i++) {
            if (alunosRegistrados[i] == addAluno) {
                alunosRegistrados[i] = alunosRegistrados[alunosRegistrados.length-1];
                alunosRegistrados.pop();
                break;
            }
        }

        emit CancelaRegistro(aluno.nome, addAluno);
    }

    /* Retorna alunos registrados na disciplina */
    function retornaAlunosRegistrados() public view returns(Aluno[] memory) {
        Aluno[] memory _alunos = new Aluno[](alunosRegistrados.length);
        for (uint i=0; i<alunosRegistrados.length; i++) {
             address addAluno = alunosRegistrados[i];
             Aluno memory aluno = alunos[addAluno];
             _alunos[i] = aluno;
        }
        return _alunos;
    }

    /* Confirma o aluno na disciplina */
    function confirmaAluno(address addAluno) public apenasProfessor {
        Aluno storage aluno = alunos[addAluno];
        require(aluno.registrado, unicode"Aluno não está registrado na disciplina.");
        require(!aluno.verificado, unicode"O aluno já foi confirmado na disciplina.");

        aluno.verificado = true;
    }

    /* Confirma todos os alunos registrados */
    function confirmaTodosAlunos() public apenasProfessor {
        for (uint i=0; i<alunosRegistrados.length; i++) {
            address addAluno = alunosRegistrados[i];
            Aluno storage aluno = alunos[addAluno];
            aluno.verificado = true;
        }        
    }

    /* Libera resgate de tokens no contrato do aluno */
    function liberaResgate(address addAluno) public apenasProfessor {
        Aluno memory aluno = alunos[addAluno];
        require(aluno.registrado, unicode"Aluno não está registrado na disciplina.");
        require(!aluno.resgateLiberado, unicode"O resgate já foi liberado.");

        ContratoAlunoPUCMG202202 contratoAluno = ContratoAlunoPUCMG202202(aluno.contrato);
        contratoAluno.liberaResgate();
    }

    /* Transfere PUCs para o contrato do aluno */
    function transferePucs(uint256 qtde, address addAluno) public apenasProfessor {
        Aluno memory aluno = alunos[addAluno];
        if (aluno.registrado && aluno.verificado) {
            token.transferFrom(professor, aluno.contrato, qtde);
        }
    }

    /* Transfere PUCs para os contratos de todos os alunos */
    function transferePucs(uint256 qtde) public apenasProfessor {
        for (uint i=0; i<alunosRegistrados.length; i++) {
            transferePucs(qtde, alunosRegistrados[i]);
        }        
    }

    /* Abre sessão da aula para checkin */
    function abrirSessaoDeAula(uint aula) public apenasProfessor {
        require(aula < 5, unicode"Número inválido para a aula.");
        sessaoAulaAberta[aula] = true;
    }

    /* Fechar sessão da aula para checkin */
    function fecharSessaoDeAula(uint aula) public apenasProfessor {
        require(aula < 5, unicode"Número inválido para a aula.");
        sessaoAulaAberta[aula] = false;
    }

    /* Realiza checkin na aula */
    function checkin(uint aula) private {
        require(aula < 5, unicode"Número inválido para a aula.");

        Aluno storage  aluno = alunos[msg.sender];
        require(aluno.registrado, unicode"Aluno não está registrado na disciplina.");
        require(aluno.verificado, unicode"Aluno ainda não foi verificado pelo professor.");
        require(sessaoAulaAberta[aula], unicode"Sessão de aula não está aberta para checkin.");
        
        if (aula == 0) {
            require(!aluno.checkinAula01, unicode"Aluno já fez checkin.");
            aluno.checkinAula01 = true;
        }
        else if (aula == 1) {
            require(!aluno.checkinAula02, unicode"Aluno já fez checkin.");
            aluno.checkinAula02 = true;
        }
        else if (aula == 2) {
            require(!aluno.checkinAula03, unicode"Aluno já fez checkin."); 
            aluno.checkinAula03 = true;
        }
        else if (aula == 3) {
            require(!aluno.checkinAula04, unicode"Aluno já fez checkin.");
            aluno.checkinAula04 = true;
        }
        else if (aula == 4) {
            require(!aluno.checkinAula05, unicode"Aluno já fez checkin.");
            aluno.checkinAula05 = true;
        }

        // Transfere 1 PUC para o contrato do aluno
        token.transferFrom(professor, aluno.contrato, 1 * (10**uint256(token.decimals())));

        emit Checkin(aluno.nome, msg.sender, aula);
    }

    /* Checkin aula 01 */
    function checkinAula01() public {
        checkin(0);
    }

    /* Checkin aula 02 */
    function checkinAula02() public {
        checkin(1);
    }

    /* Checkin aula 03 */
    function checkinAula03() public {
        checkin(2);
    }

    /* Checkin aula 04 */
    function checkinAula04() public {
        checkin(3);
    }   

    /* Checkin aula 05 */
    function checkinAula05() public {
        checkin(4);
    }           
}