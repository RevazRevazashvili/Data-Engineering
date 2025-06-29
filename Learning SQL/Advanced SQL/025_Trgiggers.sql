-- TRIGGERS
USE MySalesDB


/*
	Triggers are special stored procedure(set of statements) that automatically
	runs in response to a specific event on a table or view.
*/

/*CREATE TABLE employeeLogs(
	logID INT IDENTITY(1,1) PRIMARY KEY,
	employeeID INT,
	logMessage VARCHAR(255),
	logDate DATE
)*/

-- Below trigger will automaticaly run after new record is added to employee table
CREATE TRIGGER trg_afterInsertEmployee ON employee
AFTER INSERT
AS
BEGIN
	INSERT INTO employeeLogs(employeeID, logMessage, logDate)
	SELECT
		employeeID,
		'New employee added = ' + CAST(employeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END

INSERT INTO employee(employeeName, workingDate, workingHours, hourlySalary, gender)
VALUES
('Barbara', GETDATE(), 5, 1500.4, 'F')

SELECT * FROM employeeLogs