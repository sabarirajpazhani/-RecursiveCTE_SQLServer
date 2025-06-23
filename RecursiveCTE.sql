-------------------- >>  Recursive CTE <<------------------------
--create the table
create database RecursiveCTE ;

--user the database
use RecursiveCTE;

/*1. Find All Employees Under a Manager (Directly or Indirectly)
-->>> Business Scenario:<<<--
In a large organization, HR wants to know all employees working under a specific manager, including team leads, sub-team members, and interns reporting indirectly.*/
CREATE TABLE Employees (
    EmpID INT,
    EmpName VARCHAR(50),
    ManagerID INT
);

INSERT INTO Employees VALUES
(1, 'CEO', NULL),
(2, 'Manager A', 1),
(3, 'Manager B', 1),
(4, 'Team Lead A1', 2),
(5, 'Team Lead A2', 2),
(6, 'Dev A1', 4),
(7, 'Dev A2', 5),
(8, 'Intern', 6);

select * from Employees;

with manager as (
	select EmpID, EmpName, ManagerID from Employees 
	where ManagerID = 2

	union all

	select e.EmpID, e.EmpName, e.ManagerID from Employees e
	inner join manager m on e.ManagerID = m.EmpID
)

select *from manager;
