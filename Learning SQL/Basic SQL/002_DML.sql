/* DML - Data Manipulation Language. INSERT, DELETE, UPDATE*/

use MySalesDB

-- inserting values to the table customers
INSERT INTO dbo.customers(customerName, customersurname, age, salary) 
VALUES('John', 'Herbert', 70, 1349);
INSERT INTO dbo.customers(customerName, customersurname, age, salary) 
VALUES('Peter', 'Griffin', 45, 2200);
INSERT INTO dbo.customers(customerName, customersurname, age, salary) 
VALUES('Clevelend', 'Brown', 42, 1200);
INSERT INTO dbo.customers(customerName, customersurname, age, salary) 
VALUES('Glen', 'Quagmire', 61, 2000);
INSERT INTO dbo.customers(customerName, customersurname, age, salary) 
VALUES('Joe', 'Swanson', 40, 3000);


INSERT INTO dbo.products(productName, price) 
VALUES('bat', 30);
INSERT INTO dbo.products(productName, price) 
VALUES('knife', 17.45);
INSERT INTO dbo.products(productName, price) 
VALUES('bag', 45.50);
INSERT INTO dbo.products(productName, price) 
VALUES('handstick', 62.30);


INSERT INTO dbo.employee(employeeName, workingDate, workingHours, hourlySalary)
VALUES('Consuela', GETDATE(), 40, 30);
INSERT INTO dbo.employee(employeeName, workingDate, workingHours, hourlySalary)
VALUES('Natalia', GETDATE(), 30, 30);
INSERT INTO dbo.employee(employeeName, workingDate, workingHours, hourlySalary)
VALUES('Jesse', GETDATE(), 168, 1);
INSERT INTO dbo.employee(employeeName, workingDate, workingHours, hourlySalary)
VALUES('Adam', GETDATE(), 40, 100);


INSERT INTO dbo.orders(orderDate, amount, customerID, productsID, employeeID)
VALUES(GETDATE(), 2, 2, 1, 1);
INSERT INTO dbo.orders(orderDate, amount, customerID, productsID, employeeID)
VALUES(GETDATE(), 2, 3, 2, 3);
INSERT INTO dbo.orders(orderDate, amount, customerID, productsID, employeeID)
VALUES(GETDATE(), 1, 5, 4, 2);
INSERT INTO dbo.orders(orderDate, amount, customerID, productsID, employeeID)
VALUES(GETDATE(), 5, 3, 3, 2);

-- selects every columns and every rows from the table
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM employee;

-- selecting specific columns
SELECT customerName, age, salary FROM customers;

-- updating existing row in the table employee
UPDATE employee
SET employeeName='Meg', workingDate=GETDATE(), workingHours=15, hourlySalary=2.5
WHERE employeeName='Jesse';

-- deleting the row where employee name is Adam
DELETE FROM employee
WHERE employeeName='Adam';
