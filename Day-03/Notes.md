# 🗄️ SQL Study Notes

> **Topics covered:** NULL · CHAR vs VARCHAR · DELETE / TRUNCATE / DROP · JOINs (INNER, LEFT, RIGHT, FULL OUTER, CROSS, Self-Join)

---

## 📑 Table of Contents

1. [NULL — What it is & how it differs from `''` / `0`](#1-null--what-it-is--how-it-differs-from--0)
2. [CHAR vs VARCHAR](#2-char-vs-varchar)
3. [DELETE vs TRUNCATE vs DROP](#3-delete-vs-truncate-vs-drop)
4. [What is a JOIN? — INNER JOIN](#4-what-is-a-join--inner-join)
5. [LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN](#5-left-join-right-join-and-full-outer-join)
6. [CROSS JOIN](#6-cross-join)
7. [Self-Join](#7-self-join)

---

## 1. NULL — What it is & how it differs from `''` / `0`

**NULL** represents an **unknown, missing, or inapplicable value**. It is *not* a value itself — it's a marker indicating the absence of any data.

### NULL vs Empty String vs Zero

| | `NULL` | `''` (Empty String) | `0` |
|---|---|---|---|
| Meaning | Value unknown / not applicable | String of zero length (a real value) | Numeric zero (a real value) |
| Data type | Any | String only | Numeric only |
| Memory | No allocation | Allocated (empty) | Allocated |
| Comparison | Cannot use `=` or `<>` | Can use `=` | Can use `=` |

> 💡 **Example:** A customer's credit limit of `0` means *no credit*. A credit limit of `NULL` means *we don't know* what it is.

### Working with NULL

```sql
-- ❌ This does NOT work
SELECT * FROM Customers WHERE phone = NULL;

-- ✅ Correct syntax
SELECT * FROM Customers WHERE phone IS NULL;
SELECT * FROM Customers WHERE phone IS NOT NULL;
```

---

## 2. CHAR vs VARCHAR

Both store character/string data but differ in how they use storage.

| Feature | `CHAR(n)` | `VARCHAR(n)` |
|---|---|---|
| Length type | **Fixed** | **Variable** |
| Storage | Always `n` bytes (pads with spaces) | Only bytes needed (+ 1–2 overhead) |
| Performance | Slightly faster (fixed-size reads) | More storage-efficient |
| Best for | Short, fixed-length values | Variable-length text |
| Example use | Country codes, status flags (`'US'`, `'Y'`) | Names, emails, descriptions |

### Example

```sql
CREATE TABLE Users (
  CountryCode CHAR(2),       -- always 2 bytes: 'US' stored as 'US'
  UserName    VARCHAR(50),   -- uses only as many bytes as needed
  Email       VARCHAR(100)
);
```

> 💡 Use `CHAR` when all values are the same length. Use `VARCHAR` when lengths vary.

---

## 3. DELETE vs TRUNCATE vs DROP

| Feature | `DELETE` | `TRUNCATE` | `DROP` |
|---|---|---|---|
| Command type | DML | DDL | DDL |
| What is removed | Selected rows | All rows | Table + entire structure |
| `WHERE` clause | ✅ Yes | ❌ No | ❌ No |
| Rollback | ✅ Yes | ⚠️ Depends on DB | ❌ No |
| Speed | Slowest (row-by-row) | Fast | Instant |
| Keeps table structure | ✅ Yes | ✅ Yes | ❌ No |

### DELETE

Removes specific rows. Supports `WHERE` and can be rolled back.

```sql
-- Delete a specific row
DELETE FROM Customers WHERE CustomerID = 5;

-- Delete all rows (slow, but rollback-safe)
DELETE FROM Customers;
```

### TRUNCATE

Removes all rows quickly. Keeps the table structure intact.

```sql
TRUNCATE TABLE Customers;
```

### DROP

Completely removes the table (structure + data + indexes).

```sql
DROP TABLE Customers;
```

> ⚠️ **Warning:** `DROP` is irreversible. Always back up data before using it.

---

## 4. What is a JOIN? — INNER JOIN

A **JOIN** retrieves data from two or more tables based on a related column between them.

### INNER JOIN

Returns only the rows where there is a **match in both tables**. Unmatched rows are excluded entirely.

```sql
SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers
  ON Orders.CustomerID = Customers.CustomerID;
```

#### Visual representation

```
Table A     Table B
+---+       +---+
| 1 |       | 1 |  ← matched  ✅ (included)
| 2 |       | 3 |  ← no match ❌ (excluded)
| 3 |
```

---

## 5. LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN

### Visual Overview

```
LEFT JOIN          RIGHT JOIN        FULL OUTER JOIN
+--+--+            +--+--+           +--+--+
|██|  |            |  |██|           |██|██|
+--+--+            +--+--+           +--+--+
All LEFT +         All RIGHT +       All from BOTH
matched RIGHT      matched LEFT      tables
```

### LEFT JOIN

Returns **all rows from the left table** and matched rows from the right. Unmatched right rows appear as `NULL`.

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders
  ON Customers.CustomerID = Orders.CustomerID;
```

> Result includes customers **without** any orders (OrderID will be `NULL`).

### RIGHT JOIN

Returns **all rows from the right table** and matched rows from the left. Unmatched left rows appear as `NULL`.

```sql
SELECT Orders.OrderID, Employees.LastName
FROM Orders
RIGHT JOIN Employees
  ON Orders.EmployeeID = Employees.EmployeeID;
```

> `LEFT JOIN` and `RIGHT JOIN` are mirrors of each other — you can always rewrite one as the other by swapping table order.

### FULL OUTER JOIN

Returns **all rows from both tables**. `NULL` fills in where there is no match on either side.

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders
  ON Customers.CustomerID = Orders.CustomerID;
```

> ⚠️ Can return very large result sets. Use carefully on big tables.

---

## 6. CROSS JOIN

Returns the **Cartesian product** of two tables — every row from the first table combined with every row from the second.

```sql
SELECT colors.color, sizes.size
FROM colors
CROSS JOIN sizes;
```

### How it works

```
colors: Red, Blue, Green   (3 rows)
sizes:  S, M, L, XL        (4 rows)

Result: 3 × 4 = 12 rows
┌────────┬──────┐
│ Red    │  S   │
│ Red    │  M   │
│ Red    │  L   │
│ Red    │  XL  │
│ Blue   │  S   │
│  ...   │ ...  │
└────────┴──────┘
```

### Common use cases
- Generating all combinations (e.g., product size × color matrices)
- Building test/seed data
- Creating calendar or pivot-style tables

> ⚠️ No `ON` clause is used. Result grows **exponentially** — use with caution on large tables.

---

## 7. Self-Join

A **Self-Join** joins a table **to itself**. There is no special `SELF JOIN` keyword — you simply alias the same table twice.

### When to use it
- Hierarchical data (employees and their managers in one table)
- Comparing rows within the same table
- Finding pairs that share a common attribute

### Example — Employee / Manager hierarchy

```sql
SELECT
  e.name AS Employee,
  m.name AS Manager
FROM employees AS e
LEFT JOIN employees AS m
  ON e.manager_id = m.id;
```

```
employees table:
+----+---------+------------+
| id | name    | manager_id |
+----+---------+------------+
|  1 | Alice   | NULL       |  ← CEO, no manager
|  2 | Bob     | 1          |
|  3 | Charlie | 1          |
|  4 | Diana   | 2          |
+----+---------+------------+

Result:
+---------+---------+
| Employee| Manager |
+---------+---------+
| Bob     | Alice   |
| Charlie | Alice   |
| Diana   | Bob     |
| Alice   | NULL    |
+---------+---------+
```

---

## ⚡ Quick Reference — JOIN Types

| Join | Returns |
|---|---|
| `INNER JOIN` | Only matched rows from **both** tables |
| `LEFT JOIN` | All rows from **left** + matched from right (`NULL` where no match) |
| `RIGHT JOIN` | All rows from **right** + matched from left (`NULL` where no match) |
| `FULL OUTER JOIN` | All rows from **both** tables (`NULL` where no match on either side) |
| `CROSS JOIN` | Every possible combination — Cartesian product |
| `Self-Join` | A table joined to **itself** using aliases |

---

## 📚 References

- [W3Schools SQL Tutorial](https://www.w3schools.com/sql/)
- [ThoughtSpot SQL Reference](https://www.thoughtspot.com/sql)

---

*Notes compiled for SQL fundamentals study.*
