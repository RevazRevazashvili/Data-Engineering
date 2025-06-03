/* DDL - Data Definition Language. CREATE, ALTER, DROP*/

-- Creating the database
CREATE DATABASE MySalesDB;  -- Uncomment this if you haven't created it yet

-- Using the database
USE MySalesDB;

-- Creating the customers table
CREATE TABLE customers (
    id INT IDENTITY(1,1) NOT NULL,
    customerName VARCHAR(50) NOT NULL,
    customersurname VARCHAR(50) NOT NULL,
    age INT,
	email varchar(50),
    salary DECIMAL(10, 2),
    CONSTRAINT PK_customer PRIMARY KEY (id)
);

-- Creating the products table
CREATE TABLE products (
    productID INT IDENTITY(1,1) PRIMARY KEY,
    productName VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Creating the employee table
CREATE TABLE employee (
    employeeID INT IDENTITY(1,1) PRIMARY KEY,
    employeeName VARCHAR(50) NOT NULL,
    workingDate DATE NOT NULL,
    workingHours DECIMAL(5, 2) NOT NULL,
    hourlySalary DECIMAL(10, 2) NOT NULL
);

-- Creating the orders table
CREATE TABLE orders (
    orderID INT IDENTITY(1,1) PRIMARY KEY,
    orderDate DATE,
    amount INT NOT NULL,
    customerID INT,
    productsID INT,
    employeeID INT,
    CONSTRAINT FK_orders_customer FOREIGN KEY (customerID) REFERENCES customers(id),
    CONSTRAINT FK_orders_product FOREIGN KEY (productsID) REFERENCES products(productID),
    CONSTRAINT FK_orders_employee FOREIGN KEY (employeeID) REFERENCES employee(employeeID)
);

-- Dropping the email column from customers (only if it existed)
-- This line is now unnecessary, since the email column was removed in the table definition
ALTER TABLE customers DROP COLUMN email;

