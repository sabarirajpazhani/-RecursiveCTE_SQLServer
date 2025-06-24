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
	select c1.CategoryID, c1.CategoryName, c1.ParentCategoryID, c2.CategoryName as Root_category from Categories c1
	left join Categories c2 on c1.CategoryID = c2.CategoryID

	union all

	select c.CategoryID, c.CategoryName, c.ParentCategoryID, s.Root_category from Categories c
	inner join SubCategory s on c.ParentCategoryID = s.CategoryID
)

select * from SubCategory 
where ParentCategoryID is not null;


/*Q3. Find Folder and All Subfolders in File System
--->>> Business Scenario <<<---
A cloud storage system wants to fetch a folder and all nested folders inside it, no matter how deep.*/
-- Create the table
CREATE TABLE Products (
    product_id INT,
    new_price INT,
    change_date DATE
);

-- Insert the data
INSERT INTO Products (product_id, new_price, change_date) VALUES
(1, 20, '2019-08-14'),
(2, 50, '2019-08-14'),
(1, 30, '2019-08-15'),
(1, 35, '2019-08-16'),
(2, 65, '2019-08-17'),
(3, 20, '2019-08-18');

select * from Products;

with lessthen16 as (
    select product_id , new_price, change_date, dense_rank() over(partition by product_id order by change_date desc) as rnk  from Products
	where change_date <='2019-08-16'
	group by product_id,new_price, change_date
)
select product_id , new_price from lessthen16
where rnk = 1 
union
select product_id, 10 from products
where change_date > '2019-08-16' and product_id not in (select Product_id from lessthen16);
