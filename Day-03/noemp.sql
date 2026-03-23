-- find dept with no employees

CREATE TABLE Emp (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Country VARCHAR(50),
    Age INT,
    Salary INT,
    department_id INT
);

INSERT INTO Emp (EmpID, Name, Country, Age, Salary, department_id)
VALUES (1, 'Shubham', 'India', 23, 30000, 101),
       (2, 'Aman', 'Australia', 21, 45000, 102),
       (3, 'Naveen', 'Sri Lanka', 24, 40000, 103),
       (5, 'Nishant', 'Spain', 22, 25000, 101);
       
       
CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    department_head VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO department (department_id, department_name, department_head, location) 
VALUES (101, 'Sales', 'Sarah', 'New York'),
       (102, 'Marketing', 'Jay', 'London'),
       (103, 'Finance', 'Lavish', 'San Francisco'),
       (104, 'Engineering', 'Kabir', 'Bangalore');



      select * from Emp;
      select * from department;
      -- select department.department_name , count(emp.Name)
      -- from Emp
      -- cross join department
      -- on emp.department_id = department.department_id;
      
      -- group by department_name;
      -- having count(emp.Name);
-- SELECT d.department_name, COUNT(e.empid) AS employee_count
-- FROM Department d
-- LEFT JOIN Emp e ON d.department_id = e.department_id
-- GROUP BY d.department_name
-- Having employee_count<1;

SELECT d.* FROM Department d LEFT JOIN Emp e ON d.department_id = e.department_id WHERE e.empid IS NULL;

      