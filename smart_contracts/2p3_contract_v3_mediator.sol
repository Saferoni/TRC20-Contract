// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transaction {
    address payable public senderAddres;
    address payable public receiverAddres;
    address payable public mediatorAddres;
    string contractMessage;
    string mediatorMessage;
    bool public isConfirmSender;
    bool public isConfirmReceiver;

    constructor(address payable _receiver, string memory _contractMessage, address payable _mediator) payable {
        senderAddres = payable(msg.sender);
        receiverAddres = _receiver;
        contractMessage = _contractMessage;
        mediatorAddres = _mediator;
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