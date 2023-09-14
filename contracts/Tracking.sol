//SPDX-License-Identifier: UNLICENSED
//Aniket

pragma solidity ^0.8.19;

contract Tracking {
    enum ShipmenStatus { PENDING, IN_TRANSIT, DELIVERED}

    struct Shipment{
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliveryTime;
        uint256 distance;
        uint256 price;
        ShipmenStatus status;
        bool isPaid;
    }

    mapping(address => Shipment[]) public shipments;
    uint256 public shipmentCount;

    struct TypeShipment{
        address sender;
        address receiver;
        uint256 pickupTime;
        uint256 deliveryTime;
        uint256 distance;
        uint256 price;
        ShipmenStatus status;
        bool isPaid;
    }

    TypeShipment[] typeShipments;

    event ShipmentCreated(address indexed sender, address indexed receiver, uint256 pickupTime, uint256 deliveryTime, uint256 distance, uint256 price);
    event ShipmentInTransit(address indexed sender, address indexed receiver, uint256 pickupTime);
    event ShipmentDelivered(address indexed sender, address indexed receiver, uint256 deliveryTime);
    event ShipmentPaid(address indexed sender, address indexed receiver, uint256 price);

    constructor() {
        shipmentCount = 0;
    }

    function createShipment(address _receiver, uint256 _pickupTime, uint256 _distance, uint256 _price) public payable{
        require(msg.value == _price, "Payment amount must match to price.");

        Shipment memory shipment = Shipment(msg.sender, _receiver, _pickupTime, 0, _distance, _price, ShipmenStatus.PENDING, false);

        shipments[msg.sender].push(shipment);
        shipmentCount++;

        typeShipments.push(TypeShipment(msg.sender, _receiver, _pickupTime, 0, _distance, _price, ShipmenStatus.PENDING, false));

        emit ShipmentCreated(msg.sender, _receiver, _pickupTime, 0, _distance, _price);
    }

    function startShipment(address _sender, address _receiver, uint256 _index) public {
        Shipment storage shipment = shipments[_sender][_index];
        TypeShipment storage typeShipment = typeShipments[_index];

        require(shipment.receiver == _receiver, "Receiver address does not match.");
        require(shipment.status == ShipmenStatus.PENDING, "Shipment is already in transit.");

        shipment.status = ShipmenStatus.IN_TRANSIT;
        typeShipment.status = ShipmenStatus.IN_TRANSIT;

        emit ShipmentInTransit(_sender, _receiver, shipment.pickupTime);
    }

    function completeShipment(address _sender, address _receiver, uint256 _index) public {
        Shipment storage shipment = shipments[_sender][_index];
        TypeShipment storage typeShipment = typeShipments[_index];

        require(shipment.receiver == _receiver, "Receiver address does not match.");
        require(shipment.status == ShipmenStatus.IN_TRANSIT, "Shipment is not in transit.");
        require(!shipment.isPaid, "Shipment is already paid.");

        shipment.status = ShipmenStatus.DELIVERED;
        typeShipment.status = ShipmenStatus.DELIVERED;
        typeShipment.deliveryTime = block.timestamp;
        shipment.deliveryTime = block.timestamp;

        uint256 amount = shipment.price;

        payable(shipment.sender).transfer(amount);

        shipment.isPaid = true;
        typeShipment.isPaid = true;

        emit ShipmentDelivered(_sender, _receiver, shipment.deliveryTime); 
        emit ShipmentPaid(_sender, _receiver, shipment.price);
    }

    function getShipment(address _sender, uint256 _index) public view returns (address, address, uint256, uint256, uint256, uint256, ShipmenStatus, bool){
        Shipment memory shipment = shipments[_sender][_index];
        return (shipment.sender, shipment.receiver, shipment.pickupTime, shipment.deliveryTime, shipment.distance, shipment.price, shipment.status, shipment.isPaid);
    }

    function getShipmentCount(address _sender) public view returns (uint256){
        return shipments[_sender].length;
    }

    function getAllTransactions() public view returns (TypeShipment[] memory){
        return typeShipments;
    }
}