📘 SQL Learning – Week 1 Day 1
Foundations of SQL (MySQL)
1️⃣ What is SQL?

SQL (Structured Query Language) is a declarative language used to interact with relational databases.

Declarative means:

You describe what result you want, not how to compute it.
The database engine decides the execution plan.

Example:

SELECT * FROM employees WHERE salary > 50000;

We do not write loops or algorithms — the database optimizer handles that.

2️⃣ Database Structure

Database → Container of tables

Table → Structured data (rows + columns)

Row → Record

Column → Attribute

Similar to Excel, but optimized for millions of rows.

3️⃣ Categories of SQL Statements
DQL (Data Query Language)

SELECT

DML (Data Manipulation Language)

INSERT

UPDATE

DELETE

DDL (Data Definition Language)

CREATE

ALTER

DROP

DCL (Data Control Language)

GRANT

REVOKE

4️⃣ Core SELECT Structure
SELECT columns
FROM table
WHERE condition
ORDER BY column
LIMIT number;
Logical Execution Order:

FROM

WHERE

SELECT

ORDER BY

LIMIT

Even though SELECT is written first, it executes after filtering.

5️⃣ Basic Query Examples
Select all columns
SELECT * FROM employees;
Select specific columns
SELECT name, salary FROM employees;
Filtering
SELECT * 
FROM employees
WHERE department = 'IT';
Multiple conditions
SELECT *
FROM employees
WHERE department = 'IT'
AND salary > 85000;
Sorting
SELECT *
FROM employees
ORDER BY salary DESC;
Top N
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 2;
6️⃣ NULL Concept (Very Important)

NULL means unknown value, not:

0

Empty string

False

SQL uses 3-valued logic:

TRUE

FALSE

UNKNOWN

Example:

WHERE salary = NULL;      -- Incorrect
WHERE salary IS NULL;     -- Correct

Comparison with NULL returns UNKNOWN.

WHERE only returns rows where condition = TRUE.

7️⃣ COUNT() Aggregate Function

Aggregate functions operate on multiple rows and return a single value.

COUNT(*)

Counts all rows.

COUNT(column)

Counts only rows where column IS NOT NULL.

Example:

id	salary
1	80000
2	NULL
3	90000
COUNT(*) = 3
COUNT(salary) = 2
8️⃣ Indexes (Performance Foundation)

Without index:

Full table scan

Time complexity ≈ O(n)

With index:

B-Tree search

Time complexity ≈ O(log n) + O(k)

n = total rows

k = matching rows

Create Index
CREATE INDEX idx_department ON employees(department);
9️⃣ Composite Index
CREATE INDEX idx_dept_salary 
ON employees(department, salary);
Works best when:

Query matches leftmost columns.

Example:

WHERE department = 'IT'

WHERE department = 'IT' AND salary > 85000

Does NOT help for:

WHERE salary > 85000 (alone)

🔟 InnoDB Internal Behavior (High-Level)

In InnoDB:

Primary key = clustered index

Secondary index stores:

indexed column

primary key reference

When using secondary index:

MySQL searches index B-tree

Finds matching primary keys

Uses PK to fetch full row from data page

This is why SELECT * may require additional lookups.

1️⃣1️⃣ Why SELECT Specific Columns is Better

Avoid:

SELECT * FROM employees;

Better:

SELECT name, salary FROM employees;

Reasons:

Reduces network transfer

Reduces memory usage

Reduces I/O

Improves performance at scale

Cleaner backend design

1️⃣2️⃣ Key Takeaways

SQL is declarative

WHERE filters rows before SELECT

NULL introduces 3-valued logic

COUNT(column) ignores NULL

Indexes reduce scan time

Composite index follows leftmost rule

ORDER BY happens before LIMIT

Database optimizer chooses execution plan