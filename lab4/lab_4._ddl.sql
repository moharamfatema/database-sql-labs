CREATE TABLE CUSTOMER (
    customer_id INT NOT NULL,
    customer_name VARCHAR(255),
    city VARCHAR(255),

    PRIMARY KEY (customer_id)
);

CREATE TABLE `ORDER` (
    order_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,

    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER (customer_id)
);

CREATE TABLE ITEM (
    item_id INT NOT NULL,
    unit_price INT,

    PRIMARY KEY (item_id)
);

CREATE TABLE ORDER_ITEM (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT,

    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES `ORDER` (order_id),
    FOREIGN KEY (item_id)  REFERENCES ITEM (item_id)
);

CREATE TABLE WAREHOUSE (
    warehouse_id INT NOT NULL,
    warehouse_city VARCHAR(255),

    PRIMARY KEY (warehouse_id)
);

CREATE TABLE SHIPMENT (
    order_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    ship_date TIMESTAMP,

    PRIMARY KEY (order_id, warehouse_id),
    FOREIGN KEY (order_id) REFERENCES `ORDER` (order_id),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id)
);