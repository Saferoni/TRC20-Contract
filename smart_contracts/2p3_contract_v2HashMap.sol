// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Transaction {
    address payable public sender;
    address payable public receiver;
    bool public senderConfirmed;
    bool public receiverConfirmed;
    uint public balance;
    mapping (string => Deal) private deals; // storage

    constructor() {
        sender = payable(msg.sender);
        receiver = _receiver;
        balance = msg.value;
    }

    // Struct
    struct Deal {
        address sender;
        uint amount;
        uint timestamp;
        address recipient;
        bool senderConfirmed;
        bool recipientConfirmed;
        string transactionInformation; // может бить как отдельний обект с условиями на будущее (продукт срок цена)
    }
    
    function confirmSender() external onlySender(msg.sender) {
        senderConfirmed = true;
    }
    
    
    function confirmReceiver() public {
        require(msg.sender == receiver, "Only receiver can confirm this transaction");
        receiverConfirmed = true;
       // startTransaction();
    }
    
    function startTransaction() public  {
        require(senderConfirmed == true && receiverConfirmed == true, "Both sender and receiver must confirm the transaction");
        receiver.transfer(address(this).balance);
    }

    //добавить опеляцию от обоих
    // добавить старт транзакции по рещениям(н


    modifier onlySenser(address _to) {
        require(msg.sender == owner, "you are not an owner!");
        require(_to != address(0), "incorrect address!");
        _;
        //require(...);
    }

    //Создать масив с обектами сделки
    //создать функции 
    //1) создать сделку (записать следку в массив с уникальним ключем + тектовий контракт о чем сделка)
    //2) подтвердить сендером
    //3) подтвердить получателем
    //4) совершить транзакцию и очистить данние сделки 
    //5) Метод отмени сделки (продумать механизм отказа от сделаки!!! )
    //6) Добавить модификатори для подтерждений отпрвитель получатель
    //7) Получить статуси подтверждений по всем сделкам от оунера или получателя если в масиве несколько сделок
    //8) метод запроса баланса смарт контракта всего и по отдельности каждого
    
}