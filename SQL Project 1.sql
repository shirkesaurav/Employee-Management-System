-- Creating Table

Create Database Project1

use project1

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    HireDate DATE,
    Salary DECIMAL(10, 2),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    ManagerID INT,
    Location VARCHAR(100),
    Budget DECIMAL(15, 2),
    CreatedDate DATE,
    UpdatedDate DATE,
    Description TEXT
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    DepartmentID INT,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    Budget DECIMAL(15, 2),
    Description TEXT
);

-- insert the data

-- Inserting into Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, HireDate, Salary, Email, Phone) VALUES
    (1, 'John', 'Doe', 1, '2022-03-15', 60000, 'john@example.com', '123-456-7890'),
    (2, 'Jane', 'Smith', 2, '2023-01-20', 75000, 'jane@example.com', '987-654-3210'),
    (3, 'Michael', 'Johnson', 1, '2023-05-10', 55000, 'michael@example.com', '111-222-3333');

-- Inserting into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location, Budget, CreatedDate, UpdatedDate, Description) VALUES
    (1, 'Sales', 1, 'New York', 1000000, '2022-01-01', '2023-01-01', 'Sales Department Description'),
    (2, 'Marketing', 2, 'Los Angeles', 800000, '2022-02-01', '2023-02-01', 'Marketing Department Description');

-- Inserting into Projects table
INSERT INTO Projects (ProjectID, ProjectName, DepartmentID, StartDate, EndDate, Status, Budget, Description) VALUES
    (101, 'Sales Campaign', 1, '2023-04-01', '2023-06-30', 'In Progress', 500000, 'Sales Campaign Description'),
    (102, 'Product Launch', 2, '2023-03-01', '2023-05-31', 'Completed', 300000, 'Product Launch Description');

-- Retrieve all employees

select * from departments;

select * from employees;

select * from projects;

-- Retrieve employee details with their department information

select e.EmployeeID, e.FirstName, e.LastName, e.DepartmentID, d.departmentname, d.description
from project1.employees e 
inner join departments d on e.departmentid= d.departmentid;

-- Find employees with a salary greater than the average salary

SELECT FirstName, LastName, Salary 
from Employees 
where Salary > (select avg(salary) from employees);

-- Get the total budget of each department:

SELECT DEPARTMENTID, DEPARTMENTNAME, SUM(BUDGET) AS TOTALBUDGET FROM DEPARTMENTS
GROUP BY DEPARTMENTID, DEPARTMENTNAME;

-- Rank employees based on their salary within each department:

select * from employees;

SELECT EMPLOYEEID, FIRSTNAME, LASTNAME, DEPARTMENTID, SALARY, RANK() OVER (PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) AS EMPLOYEERANK
FROM EMPLOYEES;

-- Get the list of employees in the Marketing department using a CTE:

select * from departments;

select * from employees;

WITH MARKETINGDEPARTMENTEMPLOYEES AS (
SELECT E.EMPLOYEEID, E.FIRSTNAME, E.LASTNAME, E.DEPARTMENTID, D.DEPARTMENTNAME 
FROM DEPARTMENTS D
JOIN EMPLOYEES E ON D.DEPARTMENTID = E.DEPARTMENTID
WHERE D.DEPARTMENTNAME = 'MARKETING'
)
SELECT * FROM MARKETINGDEPARTMENTEMPLOYEES;

-- Create a stored procedure to retrieve employee details for a given department:

DELIMITER //

CREATE PROCEDURE GetEmployeesByDepartment(IN deptID INT)
BEGIN
    SELECT * FROM Employees WHERE DepartmentID = deptID;
END //

DELIMITER ;

CALL GetEmployeesByDepartment(1);

-- Create a trigger to log any updates on the Employees table:

DELIMITER //

CREATE TRIGGER LogEmployeeUpdate
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLog (EmployeeID, Action, LogDate)
    VALUES (NEW.EmployeeID, 'Update', NOW());
END //

DELIMITER ;

-- Display the total salary of employees in each department:

select e.departmentid,d.departmentname, sum(e.salary) as 'Total Salary'
from employees e 
inner join departments d on e.departmentid = d.departmentid
group by e.departmentid, d.departmentid;

-- Find the average salary of employees but only for those with a salary greater than 60000:

select * from employees

select round(avg(a.salary),2) as 'Average Salary above 60000' from
(select * from employees 
where salary >=60000)a;

or

SELECT AVG(CASE WHEN Salary > 60000 THEN Salary ELSE NULL END) AS AvgSalaryAbove60k
FROM Employees;

-- Retrieve the sum of the budget for each department and the overall total budget:

SELECT DepartmentID, SUM(Budget) AS DepartmentBudget
FROM Departments
GROUP BY DepartmentID WITH ROLLUP;

-- Utilize a left join to display all employees and their corresponding projects (if any):

select * from employees

select * from departments

select * from projects

select e.employeeid, e.firstname, e.lastname, e.departmentid, e.salary, e.email, e.phone, p.projectid, p. projectname, p.status
from employees e
left join projects p on e.departmentid = p.departmentid;

-- Increase the salary of all employees in the Marketing department by 10%:

select * from employees

select * from departments

with marketingemployees as 
(select e.employeeid, e.firstname, e.lastname, e.departmentid, d.departmentname, e.salary
from employees e
left join departments d on e.departmentid=d.departmentid
where d.departmentname = 'Marketing')
update employees
set salary = salary * 1.1
where employeeid in (select employeeid from marketingemployees);
select * from employees
WHERE employeeid IN (SELECT employeeid FROM MarketingEmployees);

or 

with marketingemployees as 
(select e.employeeid, e.firstname, e.lastname, e.departmentid, d.departmentname, e.salary
from employees e
left join departments d on e.departmentid=d.departmentid
where d.departmentname = 'Marketing')

select employeeid, firstname, lastname, departmentid, departmentname, salary*1.1 as UpdatedSalary
from marketingemployees

-- Display the cumulative salary earned by employees over time, ordered by hire date:

select * from employees

select employeeid, firstname, lastname, departmentid, hiredate, salary,
sum(salary) over (partition by employeeid order by hiredate) as cumulativesalary
from employees;

-- Create an index on the Email column in the Employees table to improve search performance:

create index ix_email on employees (email);

-- Drop the Projects table from the database:

DROP TABLE Projects;

-- Create a trigger that inserts a log entry every time a new employee is added to the Employees table:

DELIMITER //

CREATE TRIGGER NewEmployeeLog
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLog (EmployeeID, Action, LogDate)
    VALUES (NEW.EmployeeID, 'Insert', NOW());
END //

DELIMITER ;

-- Update the salary of employees who joined after 2023 to a fixed amount:

select * from employees

CREATE TABLE EmployeeLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    Action VARCHAR(255),
    LogDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

UPDATE employees
SET salary = 100000
WHERE YEAR(hiredate) >= 2023;






























