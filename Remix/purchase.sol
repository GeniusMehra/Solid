pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

// majorly solidity example with changes and new  functions

contract Purchasing {
    enum State {
        Created,
        Locked,
        Released,
        Inactive
    }
    address payable public buyer;
    address payable public seller;
    uint256 public value;
    State public state;

    error onlyBuyer();
    error onlySeller();
    error invalidState();
    error valueNotEven();

    event PurchaseConfirmed();
    event Aborted();
    event ItemReceived();
    event SellerRefunded();

    modifier onlyPurchaser() {
        if (msg.sender != buyer) {
            revert onlyBuyer();
        }
        _;
    }

    modifier onlyProducer() {
        if (msg.sender != seller) {
            revert onlySeller();
        }
        _;
    }

    modifier condition(bool conditions) {
        require(conditions);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
        if ((2 * value) != msg.value) {
            revert valueNotEven();
        }
    }

    function aborted() external payable onlyProducer inState(State.Created) {
        state = State.Inactive;
        emit Aborted();

        seller.transfer(address(this).balance);
    }

    function Purchase()
        external
        payable
        inState(State.Created)
        condition(msg.value == (2 * value))
    {
        buyer = payable(msg.sender);
        state = State.Locked;
        emit PurchaseConfirmed();
    }

    function Confirmed() external onlyPurchaser inState(State.Locked) {
        state = State.Released;
        buyer.transfer(value);
        emit ItemReceived();
    }

//Option to buyer and seller to cancel the order if it has not been dispatched
// As happens in Real World
    function Cancel() external onlyProducer onlyPurchaser inState(State.Locked){
        state=State.Inactive;
        buyer.transfer(2*value);
        seller.transfer(2*value);
    }

    function refundSeller() external onlyProducer inState(State.Released) {
        seller.transfer(3 * value);
        state = State.Inactive;
        emit SellerRefunded();
    }
}
