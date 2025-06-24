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


/*Q4. Bill of Materials (BOM)
Business Scenario:
A manufacturing company wants to list all components used to build a product, including sub-components and their components.*/
CREATE TABLE BillOfMaterials (
    PartID INT,
    PartName VARCHAR(50),
    ParentPartID INT
);

INSERT INTO BillOfMaterials VALUES
-- Top-level product
(1, 'Bicycle', NULL),

-- Components of Bicycle
(2, 'Frame', 1),
(3, 'Wheel Set', 1),
(4, 'Handlebar Set', 1),

-- Components of Frame
(5, 'Metal Tubes', 2),
(6, 'Welding Material', 2),

-- Components of Wheel Set
(7, 'Front Wheel', 3),
(8, 'Rear Wheel', 3),

-- Sub-components of Wheels
(9, 'Rim', 7),
(10, 'Spokes', 7),
(11, 'Hub', 7),
(12, 'Rim', 8),
(13, 'Spokes', 8),
(14, 'Hub', 8),

-- Components of Handlebar Set
(15, 'Handlebar', 4),
(16, 'Brake Levers', 4),
(17, 'Grips', 4);

select * from  BillOfMaterials;

with products as (
	select partID, PartName, ParentPartID, PartName as rootPart from BillOfMaterials
	where partID = 1

	union all

	select b1.partID, b1.PartName, b1.ParentPartID, b.rootPart from BillOfMaterials b1
	inner join products b on b1.ParentPartID= b.PartID
)

select * from products
where partID != 1;
