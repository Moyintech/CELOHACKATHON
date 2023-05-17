// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Pharmacy {
    address payable public pharmacyOwner;
    uint public drugPrice;

    struct Order {
        address payable patient;
        string drugName;
        uint quantity;
        uint amountPaid;
        bool isDelivered;
    }

    mapping(uint => Order) public orders;
    uint public orderCount;

    event OrderPlaced(uint orderId, address patient, string drugName, uint quantity, uint amountPaid);
    event OrderDelivered(uint orderId);

    constructor() {
        pharmacyOwner = payable(msg.sender);
        drugPrice = 1 ether; // Set the price of the drug to 1 ether (can be changed later)
        orderCount = 0;
    }

    function placeOrder(string memory _drugName, uint _quantity) public payable {
        require(msg.value == drugPrice * _quantity, "Insufficient payment");

        Order memory newOrder = Order({
            patient: payable(msg.sender),
            drugName: _drugName,
            quantity: _quantity,
            amountPaid: msg.value,
            isDelivered: false
        });

        orders[orderCount] = newOrder;
        orderCount++;

        emit OrderPlaced(orderCount - 1, msg.sender, _drugName, _quantity, msg.value);
    }

    function deliverOrder(uint _orderId) public {
        require(msg.sender == pharmacyOwner, "Only pharmacy owner can deliver orders");
        require(!orders[_orderId].isDelivered, "Order has already been delivered");

        orders[_orderId].isDelivered = true;
        orders[_orderId].patient.transfer(drugPrice * orders[_orderId].quantity);

        emit OrderDelivered(_orderId);
    }

    function setDrugPrice(uint _newPrice) public {
        require(msg.sender == pharmacyOwner, "Only pharmacy owner can change drug price");

        drugPrice = _newPrice;
    }
}