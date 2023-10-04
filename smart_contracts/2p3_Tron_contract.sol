// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Импорт интерфейса TRC20
interface ITRC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    // Добавьте оставшиеся методы в соответствии с интерфейсом TRC20
}

contract Transaction {
    address payable public senderAddres;
    address payable public receiverAddres;
    address payable public mediatorAddres;
    ITRC20 public usdtToken; // Адрес USDT токена на Tron
    string contractMessage;
    string mediatorMessage;
    bool public isConfirmSender;
    bool public isConfirmReceiver;

    constructor(address payable _receiver, string memory _contractMessage, address payable _mediator, address _usdtAddress) payable {
        senderAddres = payable(msg.sender);
        receiverAddres = _receiver;
        contractMessage = _contractMessage;
        mediatorAddres = _mediator;
        usdtToken = ITRC20(_usdtAddress); // Инициализация USDT токена
    }

    // подтверждения в одной публичной функции
    function confirm() public {
        if (msg.sender == senderAddres) confirmSender();
        else if (msg.sender == receiverAddres) confirmReceiver();
        else revert("Only sender or receiver can do that");
    }

    function confirmSender() private onlySender {
        isConfirmSender = true;
        if (isConfirmReceiver == true) startTransaction();
    }

   function confirmReceiver() private onlyReciver {
        isConfirmReceiver = true;
        if (isConfirmSender == true) startTransaction();
    }


    // Функции отказа
    function refused() public {
        if (msg.sender == senderAddres) refusedSender();
        else if (msg.sender == receiverAddres) refusedReceiver();
        else revert("Only sender or receiver can do that");
    }

    function refusedSender() private onlySender {
        isConfirmSender = false;
        goToFirstSupportLevel();
    }

    function refusedReceiver() private onlyReciver {
        isConfirmReceiver = false;
        goToFirstSupportLevel();
    }
    

    // функции для медиатора
    function closeContract(string memory _message) public onlyMediator {
        mediatorMessage = _message;
        senderAddres.transfer(getBalance());
    }
    function approveContract(string memory _message) public onlyMediator {
        mediatorMessage = _message;
        receiverAddres.transfer(getBalance());
    }


    // Общие функции контракта
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

        // Функция для перевода USDT
    function startTransaction(uint256 amount) private {
        require(isConfirmSender && isConfirmReceiver, "Both sender and receiver must confirm the transaction");
        require(usdtToken.transferFrom(senderAddress, receiverAddress, amount), "Transfer failed");
    }

    function startTransaction() private  {
        require(isConfirmSender == true && isConfirmReceiver == true, "Both sender and receiver must confirm the transaction");
        receiverAddres.transfer(getBalance());
    }


    modifier onlyMediator() {
        require(msg.sender == mediatorAddres, "Only mediator can confirm this");
        _;
    }

    modifier onlySender() {
        require(msg.sender == senderAddres, "Only sender can confirm this");
        _;
    }

    modifier onlyReciver() {
        require(msg.sender == receiverAddres, "Only reciver can confirm this");
        _;
    }

    function goToFirstSupportLevel() private {
       // now need send massage to mediator and only mediator can do contract 
       // in feauther will be go to AI method mediator
    }
    
}