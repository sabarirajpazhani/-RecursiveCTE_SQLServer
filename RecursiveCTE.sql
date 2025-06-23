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

/*2. Get Full Category/Subcategory Tree
--->>> Business Scenario <<<---
An e-commerce platform has categories and subcategories (e.g., Electronics → Mobiles → Smartphones → Android).
Show the entire path/tree of categories starting from a root category.*/
CREATE TABLE Categories (
    CategoryID INT,
    CategoryName VARCHAR(50),
    ParentCategoryID INT
);

INSERT INTO Categories VALUES
(1, 'Electronics', NULL),
(2, 'Mobiles', 1),
(3, 'Smartphones', 2),
(4, 'Android Phones', 3),
(5, 'Feature Phones', 2),
(6, 'Accessories', 1);

select * from Categories;

with SubCategory as (
	select CategoryID, CategoryName, ParentCategoryID from Categories 
	where CategoryID = 1

	union all

	select c.CategoryID, c.CategoryName, c.ParentCategoryID from Categories c
	inner join SubCategory s on c.ParentCategoryID = s.CategoryID
)

select * from SubCategory;


