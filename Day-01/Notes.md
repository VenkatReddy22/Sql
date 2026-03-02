# SQL Learning – Week 1 Day 1

## Foundations of SQL (MySQL)

---

## 1. What is SQL?

**SQL (Structured Query Language)** is a declarative language used to interact with relational databases.

### Declarative Approach

- You describe what result you want, not how to compute it
- The database engine decides the execution plan

### Example

```sql
SELECT * FROM employees WHERE salary > 50000;
```

We do not write loops or algorithms — the database optimizer handles that.

---

## 2. Database Structure

| Component | Description |
|-----------|-------------|
| **Database** | Container of tables |
| **Table** | Structured data (rows + columns) |
| **Row** | Record |
| **Column** | Attribute |

Similar to Excel, but optimized for millions of rows.

---

## 3. Categories of SQL Statements

| Category | Commands |
|----------|----------|
| **DQL** (Data Query Language) | SELECT |
| **DML** (Data Manipulation Language) | INSERT, UPDATE, DELETE |
| **DDL** (Data Definition Language) | CREATE, ALTER, DROP |
| **DCL** (Data Control Language) | GRANT, REVOKE |

---

## 4. Core SELECT Structure

```sql
SELECT columns
FROM table
WHERE condition
ORDER BY column
LIMIT number;
```

### Logical Execution Order

1. **FROM**
2. **WHERE**
3. **SELECT**
4. **ORDER BY**
5. **LIMIT**

> **Note:** Even though `SELECT` is written first, it executes after filtering.

---

## 5. Basic Query Examples

### Select all columns

```sql
SELECT * FROM employees;
```

### Select specific columns

```sql
SELECT name, salary FROM employees;
```

### Filtering

```sql
SELECT * 
FROM employees
WHERE department = 'IT';
```

### Multiple conditions

```sql
SELECT *
FROM employees
WHERE department = 'IT'
AND salary > 85000;
```

### Sorting

```sql
SELECT *
FROM employees
ORDER BY salary DESC;
```

### Top N rows

```sql
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 2;
```

---

## 6. NULL Concept (Very Important)

**NULL** means unknown value, NOT:
- `0`
- Empty string
- `False`

### SQL 3-Valued Logic

- **TRUE**
- **FALSE**
- **UNKNOWN**

### Comparison with NULL

```sql
WHERE salary = NULL;      -- ❌ Incorrect
WHERE salary IS NULL;     -- ✅ Correct
```

**Important:** Comparison with NULL returns **UNKNOWN**, and `WHERE` only returns rows where the condition evaluates to `TRUE`.

---

## 7. COUNT() Aggregate Function

**Aggregate functions** operate on multiple rows and return a single value.

### COUNT Variants

- **`COUNT(*)`** – Counts all rows
- **`COUNT(column)`** – Counts only rows where the column IS NOT NULL

### Example

| id | salary |
|----|--------|
| 1  | 80000  |
| 2  | NULL   |
| 3  | 90000  |

- `COUNT(*)` = 3
- `COUNT(salary)` = 2

---

## 8. Indexes (Performance Foundation)

### Without Index

- Full table scan
- Time complexity ≈ **O(n)**

### With Index (B-Tree)

- B-Tree search
- Time complexity ≈ **O(log n) + O(k)**
  - `n` = total rows
  - `k` = matching rows

### Create Index

```sql
CREATE INDEX idx_department ON employees(department);
```

---

## 9. Composite Index

```sql
CREATE INDEX idx_dept_salary 
ON employees(department, salary);
```

### Works Best When

- Query matches **leftmost columns**

#### Examples

```sql
WHERE department = 'IT'

WHERE department = 'IT' AND salary > 85000
```

### Does NOT Help For

```sql
WHERE salary > 85000  -- alone (not leftmost)
```

---

## 10. InnoDB Internal Behavior (High-Level)

### InnoDB Structure

- **Primary key** = clustered index
- **Secondary index** stores:
  - Indexed column
  - Primary key reference

### When Using Secondary Index

1. MySQL searches index B-tree
2. Finds matching primary keys
3. Uses PK to fetch full row from data page

> **Why it matters:** `SELECT *` may require additional lookups beyond the index.

---

## 11. Why SELECT Specific Columns is Better

### ❌ Avoid

```sql
SELECT * FROM employees;
```

### ✅ Better

```sql
SELECT name, salary FROM employees;
```

### Reasons

- Reduces network transfer
- Reduces memory usage
- Reduces I/O
- Improves performance at scale
- Cleaner backend design

---

## 12. Key Takeaways

- ✓ SQL is declarative
- ✓ `WHERE` filters rows before `SELECT`
- ✓ `NULL` introduces 3-valued logic
- ✓ `COUNT(column)` ignores NULL
- ✓ Indexes reduce scan time
- ✓ Composite index follows leftmost rule
- ✓ `ORDER BY` happens before `LIMIT`
- ✓ Database optimizer chooses execution plan

---