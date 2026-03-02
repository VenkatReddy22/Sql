# SQL Learning Notes - Day 02

## 1. What is Aggregation?

**Concept:** Instead of showing every row, give a summary.

### Example Scenario
Imagine you have 10 apples. Instead of listing each apple individually, you want to know:
- How many apples?
- What is the total weight?
- What is the average weight?

### What SQL Aggregation Does
- "Don't show me every row"
- "Give me a summary"

### Example SQL
```sql
SELECT COUNT(*) FROM employees;
```
This collapses everything into **ONE number** - the total employee count.

---

## 2. What is GROUP BY?

**Concept:** Split data into groups, then apply aggregations to each group.

### Example Scenario
You have employees from:
- IT
- HR  
- Finance

Instead of asking "How many employees total?", you ask "How many employees per department?"

### Mental Model
1. Make piles (one per department)
2. Count each pile separately

### Example SQL
```sql
SELECT department, COUNT(*)
FROM employees
GROUP BY department;
```

---

## 3. Why SELECT * Doesn't Work with GROUP BY

### The Problem
When you group by department, SQL creates separate piles:
- IT
- HR
- Finance

If you then say "Also show salary", which salary should it show? There are many salaries in each pile!

### The Rule
When using `GROUP BY`, you can only select:
- ✅ The grouped column(s)
- ✅ Aggregated values (`COUNT`, `SUM`, `AVG`, etc.)

---

## 4. WHERE vs HAVING

### Mental Model: Sorting Lego Pieces

**WHERE:**
- Remove broken Lego pieces **BEFORE** sorting by color

**HAVING:**
- Sort Lego by color
- Then remove color groups that have less than 3 pieces

### Key Difference
| Keyword | Purpose | Level |
|---------|---------|-------|
| `WHERE` | Filters rows | Individual rows |
| `HAVING` | Filters groups | Groups |

### SQL Execution Order (Critical!)

```
1. FROM     → get table
2. WHERE    → remove rows
3. GROUP BY → make piles
4. HAVING   → remove piles
5. SELECT   → choose what to show
6. ORDER BY → sort result
```

**This order explains many SQL errors!**

---

## 5. What is a Window Function?

**Key Idea:** Calculate something (aggregate) **without collapsing the table**.

### Aggregation vs Window Functions

**Regular Aggregation:**
```sql
SELECT COUNT(*) FROM employees;
-- Result: 1 row (total count)
```

**Window Function:**
```sql
SELECT name,
       COUNT(*) OVER() as total_employees
FROM employees;
-- Result: All rows retained, but each row shows the total!
```

### The Difference
- **Aggregate** → collapses to fewer rows
- **Window** → keeps all rows, adds calculated values

---

## 6. What is ROW_NUMBER()?

**Concept:** Assign sequential numbers to rows based on a sort order.

### Example Scenario
Imagine students standing in a line sorted by height. `ROW_NUMBER()` gives them position numbers: 1, 2, 3, 4, etc.

### Example SQL
```sql
SELECT name,
       ROW_NUMBER() OVER (ORDER BY salary) as rank
FROM employees;
```
This assigns a ranking number to each employee based on salary.

---

## 7. How Median Works

### Understanding Median

**For odd number of values (1, 2, 3, 4, 5):**
- Middle position = (5 + 1) / 2 = 3
- Median = 3

**For even number of values (1, 2, 3, 4, 5, 6):**
- Middle positions = 3rd and 4th values
- Median = Average of 3 and 4

### Steps to Calculate Median
1. Sort values
2. Number rows with `ROW_NUMBER()` or `PERCENT_RANK()`
3. Pick the middle position(s)

### Formula
```
Odd:  Position = (N + 1) / 2
Even: Positions = N / 2 and (N / 2) + 1
```

---

## 8. What is Recursive CTE?

**Concept:** Build a result set step-by-step, starting with a base case and adding rows recursively.

### Example Scenario
- Start at 1
- Keep adding 1
- Stop at 5
- Result: 1, 2, 3, 4, 5

### Example SQL
```sql
WITH RECURSIVE nums AS (
  -- Base case: start with 1
  SELECT 1 as n
  
  UNION ALL
  
  -- Recursive case: keep adding 1
  SELECT n + 1
  FROM nums
  WHERE n < 5
)
SELECT * FROM nums;
```

**Think of it like counting with your finger, one number at a time.**

---

## 9. COUNT(*) vs COUNT(column)

### What's the Difference?

**Scenario:**
- 5 boxes total
- 3 boxes have toys
- 2 boxes are empty (NULL)

```sql
COUNT(*)      -- Returns: 5 (counts all rows)
COUNT(toy)    -- Returns: 3 (ignores NULL values)
```

### Key Point
`COUNT(column)` **ignores NULL values**, while `COUNT(*)` counts all rows.

---

## 10. Why Execution Order Matters

### ❌ This Doesn't Work

```sql
SELECT salary * 12 AS annual_salary
FROM employees
WHERE annual_salary > 50000;
```

### Why?
Because `WHERE` executes **before** `SELECT`:
- `WHERE` runs first, but `annual_salary` doesn't exist yet!
- `SELECT` is where `annual_salary` gets created

### ✅ Correct Approach

**Option 1: Repeat the calculation**
```sql
SELECT salary * 12 AS annual_salary
FROM employees
WHERE salary * 12 > 50000;
```

**Option 2: Use a subquery or CTE**
```sql
WITH salary_calc AS (
  SELECT salary * 12 AS annual_salary
  FROM employees
)
SELECT * FROM salary_calc
WHERE annual_salary > 50000;
```

### Remember
- SQL **reads top-to-bottom**
- SQL **executes logically bottom-to-top**
