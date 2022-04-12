SELECT customer_name FROM customer WHERE customer_name LIKE "Ma%"; 

SELECT order_item.order_id, COUNT(DISTINCT order_item.item_id), SUM(order_item.quantity * item.unit_price) FROM (
    order_item JOIN item on order_item.item_id = item.item_id
)GROUP BY order_id;

SELECT shipment.order_id FROM (
    shipment JOIN warehouse on shipment.warehouse_id = warehouse.warehouse_id 
) WHERE warehouse.warehouse_city = "Arica";

SELECT SUM( order_item.quantity * item.unit_price) FROM (
	(SELECT order_id FROM shipment WHERE warehouse_id = 8) q
    JOIN order_item ON q.order_id = order_item.order_id
    JOIN item ON item.item_id = order_item.item_id
)GROUP BY order_item.order_id;

SELECT warehouse.warehouse_id, warehouse.warehouse_city, COUNT(shipment.order_id) FROM (
	warehouse LEFT JOIN shipment ON warehouse.warehouse_id = shipment.warehouse_id
) GROUP BY warehouse.warehouse_id;

SELECT customer.customer_name , COUNT(`ORDER`.order_id) AS "# ORDERS" FROM(
	customer LEFT JOIN `order` ON customer.customer_id = `ORDER`.order_id
) GROUP BY customer.customer_id;

SELECT * FROM item as i WHERE NOT EXISTS (
	SELECT DISTINCT item_id FROM order_item WHERE i.item_id = order_item.item_id
);