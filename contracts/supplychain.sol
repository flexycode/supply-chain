// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

contract SupplyChain {
    using Counters for Counters.Counter;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address owner;
        address[] history;
    }

    mapping(uint256 => Product) public products;
    Counters.Counter private productCount;

    event ProductCreated(uint256 id, string name, uint256 price, address owner);
    event ProductTransferred(uint256 id, address from, address to);

    constructor() {
        productCount.increment(); // Start product IDs from 1
    }

    /**
     * @dev Creates a new product.
     * @param _name The name of the product.
     * @param _price The price of the product.
     */
    function createProduct(string memory _name, uint256 _price) public {
        uint256 id = productCount.current();
        products[id] = Product(id, _name, _price, msg.sender, new address[](0));
        emit ProductCreated(id, _name, _price, msg.sender);
        productCount.increment();
    }

    /**
     * @dev Transfers a product to a new owner.
     * @param _id The ID of the product.
     * @param _to The address of the new owner.
     */
    function transferProduct(uint256 _id, address _to) public {
        require(_id <= productCount.current(), "Invalid product ID");

        Product storage product = products[_id];
        require(msg.sender == product.owner, "You are not the owner of this product");

        product.owner = _to;
        product.history.push(_to);
        emit ProductTransferred(_id, msg.sender, _to);
    }
}

