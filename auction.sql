CREATE DATABASE auctions;

\c auctions;

-- Drop Bids table
DROP TABLE IF EXISTS Bids;

-- Drop Lots table
DROP TABLE IF EXISTS Lots;

-- Drop Customers table
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

-- Create Lots table
CREATE TABLE Lots (
    lot_id SERIAL PRIMARY KEY,
    seller_id INT,
    lot_name VARCHAR(100),
    lot_description TEXT,
    reserve_price DECIMAL(10, 2),
    end_time TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES Customers(customer_id)
);

-- Create Bids table
CREATE TABLE Bids (
    bid_id SERIAL PRIMARY KEY,
    lot_id INT,
    customer_id INT,
    bid_amount DECIMAL(10, 2),
    bid_time TIMESTAMP,
    FOREIGN KEY (lot_id) REFERENCES Lots(lot_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample customers
INSERT INTO Customers (first_name, last_name, email, phone_number)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '555-1234'),
    ('Jane', 'Doe', 'jane.doe@example.com', '555-5678'),
    ('Michael', 'Smith', 'michael.smith@example.com', '555-7890'),
    ('Sarah', 'Johnson', 'sarah.johnson@example.com', '555-2345'),
    ('David', 'Brown', 'david.brown@example.com', '555-6789'),
    ('Jennifer', 'Davis', 'jennifer.davis@example.com', '555-1230'),
    ('Robert', 'Taylor', 'robert.taylor@example.com', '555-4567');

-- Insert sample lots
INSERT INTO Lots (seller_id, lot_name, lot_description, reserve_price, end_time)
VALUES
    (1, 'Antique Vase', 'Beautiful antique porcelain vase', 100.00, '2023-10-01 12:00:00'),
    (2, 'Rare Painting', 'A painting by a famous artist', 500.00, '2023-10-02 14:00:00'),
    (3, 'Vintage Watch', 'Rare vintage watch from the 1950s', 300.00, '2023-10-03 15:00:00'),
    (4, 'Art Deco Lamp', 'Beautiful Art Deco style lamp', 150.00, '2023-10-05 12:00:00'),
    (1, 'Rare Coins Collection', 'A collection of valuable coins', 500.00, '2023-10-06 14:00:00');

-- Insert sample bids
INSERT INTO Bids (lot_id, customer_id, bid_amount, bid_time)
VALUES
    (1, 2, 120.00, '2023-10-01 11:30:00'),
    (1, 1, 150.00, '2023-10-01 11:45:00'),
    (2, 1, 550.00, '2023-10-02 13:30:00'),
    (3, 2, 350.00, '2023-10-03 14:30:00'),
    (3, 1, 400.00, '2023-10-03 14:45:00'),
    (4, 5, 175.00, '2023-10-05 11:30:00'),
    (4, 3, 200.00, '2023-10-05 11:45:00'),
    (5, 4, 550.00, '2023-10-06 13:30:00');

SELECT * FROM Customers;
SELECT * FROM Lots;
SELECT * FROM Bids;

SELECT 
    l.lot_id,
    l.lot_name,
    l.lot_description,
    l.reserve_price,
    l.end_time,
    c.first_name AS bidder_first_name,
    c.last_name AS bidder_last_name,
    b.bid_amount
FROM 
    Lots l
JOIN 
    Bids b ON l.lot_id = b.lot_id
JOIN 
    Customers c ON b.customer_id = c.customer_id
WHERE 
    b.bid_amount = (
        SELECT 
            MAX(bid_amount)
        FROM 
            Bids
        WHERE 
            lot_id = l.lot_id
    );
