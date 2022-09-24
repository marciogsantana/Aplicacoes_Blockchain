// SPDX-License-Identifier: MIT
//@author Prof. Fabio Santos
// implementado por @Marcio Gomes para fins academicos
// sera usado uma stablecoin para aquisição dos tokens

pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/**
 * 
 * Implementa um token basico ERC20 para stake.
 */
contract StakingToken is ERC20, Ownable {    

    // stablecoin USDT  que será a base para aquisição dos tokens Sant
    uint256 public totalSupply_usdt;
    mapping (address=> uint256) public BalanceOf_stablecoin;
    address public  owner_stablecoin;
    string public name_stablecoin;
    string public symbol_stablecoin;
    mapping (address=> uint256) public BalanceOf_token;

   /**
     *  criação do token e definicao do total supply .
     */
    uint256 totallSupply = 1000 * (10**uint256(decimals()));
    
    constructor() ERC20("Token sant", "SANT") {
        _mint(msg.sender, totallSupply);

        // contrucao da stabelcoin
        owner_stablecoin = msg.sender;
        totalSupply_usdt = totallSupply;   
        BalanceOf_stablecoin[owner_stablecoin] = totalSupply_usdt;
        name_stablecoin = "Stablecoin USDT";
        symbol_stablecoin = "USDT";
        

    }

    modifier dono_contrato  {

        require(msg.sender == owner_stablecoin,"Apenas o dono do contrato pode executar");
        _;

    }

    modifier investidor {

        require(msg.sender != owner_stablecoin,"o dono do contato nao pode comprar stablecoin");
        _;

    }

    event Compra(address indexed _from, uint256 _value);
    //event Approval(address indexed _owner, address indexed _spender, uint256 _value);
   
      
    /**
     *  Nós geralmente precisamos saber quem são todos os stakeholders.
     */
    address[] internal stakeholders;

    /**
     * Os stakes para cada stakeholder.
     */
    mapping(address => uint256) internal stakes;

    /**
     *  As recompensas acumuladas para cada um stakeholder.
     */
    mapping(address => uint256) internal rewards;
  
    
     
     // compra da stablecoin que sera usada como base para aquisicao do token
   
    function compraStablecoin ( uint256 _valor) public investidor {

        require(_valor != 0, "saldo insuficiente");
        BalanceOf_stablecoin[msg.sender] = BalanceOf_stablecoin[msg.sender] + _valor;
        emit Compra(msg.sender, _valor);

    }

    // compra do token usando a stablecoin 
    // o valor da stablecoin é acumalado na piscina ligado ao dono do contrato

    function compraToken(uint256 numTokens) public investidor returns (bool) {
        require(numTokens != 0, "saldo insuficiente");
        BalanceOf_token[msg.sender] =  BalanceOf_token[msg.sender] + numTokens;
        BalanceOf_stablecoin[msg.sender] = BalanceOf_stablecoin[msg.sender] - numTokens;
        BalanceOf_stablecoin[owner_stablecoin] = BalanceOf_stablecoin[owner_stablecoin]+numTokens;
        emit Compra(msg.sender, numTokens);
        return true;
    }

    // ---------- STAKES ----------

    /**
     *  Um metodo para um stakeholder criar um stake.
     * @param _stake O tamanho do stake para ser criado.
     */
     //

     function createStake(uint256 _stake) investidor
        public
    {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] = _stake;
    }


    /**
     *  Um metodo para um stakeholder remover um stake.
     * @param _stake O tamanho do stake para ser removido.
     */
    function removeStake(uint256 _stake) investidor
        public
    {
        stakes[msg.sender] = stakes[msg.sender] - _stake;
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    /**
     *  A metodo para recuperar o stake para um stakeholder.
     * @param _stakeholder O stakeholder interessado para recuperar o stake.
     * @return uint256 A quantidade de wei staked.
     */
    function stakeOf(address _stakeholder) investidor
        public
        view
        returns(uint256)
    {
        return stakes[_stakeholder];
    }

    /**
     *  Um metodo para agregar os stakes de todos os stakeholders.
     * @return uint256 os stakes agregados de todos os stakeholders.
     */
    function totalStakes() dono_contrato
        public
        view
        returns(uint256)
    {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes + stakes[stakeholders[s]];
        }
        return _totalStakes;
    }

    // ---------- STAKEHOLDERS ----------

    /**
     *  Um metodo para checar se um address e de um stakeholder.
     * @param _address O address para verificar.
     * @return bool, uint256 Se o endereço e de um stakeholder, 
     * e se assim for sua posição no array de stakeholders.
     */
    function isStakeholder(address _address) dono_contrato
        public
        view
        returns(bool, uint256)
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]){ 
                return (true, s);
            }
        }
        return (false, 0);
    }
    /**
     *  Um metodo para adicionar um stakeholder.
     * @param _stakeholder O stakeholder para adicionar.
     */
    function addStakeholder(address _stakeholder)
        public
    {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder){ 
            stakeholders.push(_stakeholder);
        }
    }
    /**
     *  Um metodo para remover um stakeholder.
     * @param _stakeholder O stakeholder para remover.
     */
    function removeStakeholder(address _stakeholder)
        public
    {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        } 
    }

    // ---------- RECOMPENSAS ----------
    
    /**
     *  Um método para permitir que um stakeholder verifique suas recompensas.
     * @param _stakeholder o stakeholder para verificar as recompensas dele.
     */
    function rewardOf(address _stakeholder) 
        public
        view
        returns(uint256)
    {
        return rewards[_stakeholder];
    }

    /**
     *  Um metodo para agregar as recompensas de todos stakeholders.
     * @return uint256 As recomensas agregadas de todos os stakeholders.
     */
    function totalRewards()
        public
        view
        returns(uint256)
    {
        uint256 _totalRewards = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalRewards = _totalRewards + rewards[stakeholders[s]];
        }
        return _totalRewards;
    }

    /** 
     *  Um simples metodo que calcula a recompensa para cada stakeholder.
     * @param _stakeholder O stakeholder para calcular a recompesa dele.
     */
    function calculateReward(address _stakeholder)
        public
        view
        returns(uint256)
    {
        return stakes[_stakeholder] / 100;
    }
    /**
     *  Um metodo para distribuir as recompensas para todos stakeholders.
     */
    function distributeRewards() 
        public
        onlyOwner
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            address stakeholder = stakeholders[s];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder] + reward;
        }
    }
    /**
     *  Um método para permitir que um stakeholders retire seus Stakes.
     */
     function withdrawStake() 
        public
    {
        uint256 reward = rewards[msg.sender] + stakes[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }

    /**
     *  Um método para permitir que um stakeholders retire suas recompensas.
     */
    function withdrawReward() 
        public
    {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }
    
}
