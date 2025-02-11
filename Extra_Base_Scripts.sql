CREATE TABLE customer_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_type VARCHAR(255) NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(255) NOT NULL,
    customer_address VARCHAR(255) NOT NULL,
    order_date VARCHAR(255) NOT NULL,
    order_time VARCHAR(255) NOT NULL,
    order_status VARCHAR(255) NOT NULL,
    order_total VARCHAR(255) NOT NULL,
    order_details TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    misc TEXT NOT NULL
);


CREATE TABLE customer_order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NULL,
    item_id VARCHAR(255) NULL,
    item_name VARCHAR(255) NOT NULL,
    item_price VARCHAR(255) NOT NULL,
    item_quantity VARCHAR(255) NOT NULL,
    item_total VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    misc TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES customer_orders(id) ON DELETE CASCADE
);

INSERT INTO customer_orders (id, order_type, customer_name, customer_phone, customer_address, order_date, order_time, order_status, order_total, order_details, created_at, updated_at, misc) VALUES
(1, 'Online', 'John Doe', '123-456-7890', '123 Main St, City', '2025-02-01', '14:30:00', 'New', '$75.50', 'Order includes multiple items', NOW(), NOW(), 'Misc data'),
(2, 'Pickup', 'Jane Smith', '234-567-8901', '456 Oak St, City', '2025-02-02', '10:15:00', 'Processed', '$42.75', 'Order includes multiple items', NOW(), NOW(), 'Misc data'),
(3, 'Delivery', 'Michael Johnson', '345-678-9012', '789 Pine St, City', '2025-02-03', '16:45:00', 'Delivering', '$99.99', 'Order includes multiple items', NOW(), NOW(), 'Misc data'),
(4, 'In-Store', 'Emily Davis', '456-789-0123', '321 Elm St, City', '2025-02-04', '11:00:00', 'Delivered', '$58.20', 'Order includes multiple items', NOW(), NOW(), 'Misc data'),
(5, 'Online', 'John Doe', '123-456-7890', '123 Main St, City', '2025-02-05', '09:30:00', 'New', '$120.45', 'Order includes multiple items', NOW(), NOW(), 'Misc data');


INSERT INTO customer_order_details (id, order_id, item_id, item_name, item_price, item_quantity, item_total, created_at, updated_at, misc) VALUES
(1, 1, '4362', 'Bread', '$2.0', '3', '$6.0', NOW(), NOW(), 'Misc data'),
(2, 1, '8822', 'Apple', '$1.5', '1', '$1.5', NOW(), NOW(), 'Misc data'),
(3, 1, '5949', 'Eggs', '$4.0', '3', '$12.0', NOW(), NOW(), 'Misc data'),
(4, 1, '7701', 'Rice', '$8.0', '1', '$8.0', NOW(), NOW(), 'Misc data'),
(5, 2, '5226', 'Eggs', '$4.0', '1', '$4.0', NOW(), NOW(), 'Misc data'),
(6, 2, '6653', 'Milk', '$3.5', '2', '$7.0', NOW(), NOW(), 'Misc data'),
(7, 3, '1122', 'Chicken', '$10.0', '2', '$20.0', NOW(), NOW(), 'Misc data'),
(8, 3, '3321', 'Rice', '$8.0', '1', '$8.0', NOW(), NOW(), 'Misc data'),
(9, 3, '7745', 'Apple', '$1.5', '5', '$7.5', NOW(), NOW(), 'Misc data'),
(10, 4, '8812', 'Eggs', '$4.0', '2', '$8.0', NOW(), NOW(), 'Misc data'),
(11, 4, '9993', 'Milk', '$3.5', '1', '$3.5', NOW(), NOW(), 'Misc data'),
(12, 4, '1234', 'Chicken', '$10.0', '1', '$10.0', NOW(), NOW(), 'Misc data'),
(13, 5, '4444', 'Bread', '$2.0', '4', '$8.0', NOW(), NOW(), 'Misc data'),
(14, 5, '5555', 'Rice', '$8.0', '2', '$16.0', NOW(), NOW(), 'Misc data'),
(15, 5, '6666', 'Apple', '$1.5', '10', '$15.0', NOW(), NOW(), 'Misc data');