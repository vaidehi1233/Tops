### Customers jo ya to NewYork se hai OR jinka grade > 100 nahi hai
USE hotel;

SELECT * FROM customer;
SELECT customer_id, customer_name, city, grade, salesman_id
FROM customer
WHERE city = 'NewYork'
   OR grade <= 100
   OR grade IS NULL;
   

## New York + grade > 100

SELECT customer_id, customer_name, city, grade, salesman_id
FROM customer
WHERE city = 'New York'
  AND grade > 100;
  
  
### Order number, purchase amount + achieved/unachieved %
SELECT * FROM orders;

SELECT 
    ord_id,
    purch_amt,
    (purch_amt / 6000) * 100 AS achieved_percent,
    (100 - (purch_amt / 6000) * 100) AS unachieved_percent
FROM orders
WHERE purch_amt > 6000 * 0.50;


## Total purchase amount of all orders

SELECT SUM(purch_amt) AS total_purchase_amount
FROM orders;


### Each customer ka max purchase amount

SELECT customer_id, MAX(purch_amt) AS max_purchase_amount
FROM orders
GROUP BY customer_id;

## Average product price


SELECT AVG(price) AS average_product_price
FROM products;

## Employees jinka department 'Toronto' me hai

SELECT * FROM emp_details;

SELECT first_name, last_name, employee_id, job_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location = 'Toronto'
);

use hotel;

## 8. Employees jinki salary “MK_MAN” wale employees se kam ho (but not MK_MAN)
SELECT * FROM emp_details;
SELECT emp_id_no, emp_F_name, emp_L_name, emp_dept
FROM emp_details
WHERE salary < (
    SELECT salary 
    FROM emp_details
    WHERE emp_dept = 'MK_MAN'

AND emp_dept <> 'MK_MAN');

## 9. Employees jo department 80 ya 40 me kaam karte hai (dept name bhi)

SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.department_id IN (40, 80);


## 10. Har department ka avg salary + kitne log commission le rahe hai

SELECT d.department_name,
       AVG(e.salary) AS avg_salary,
       COUNT(e.commission_pct) AS commission_emp_count
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
GROUP BY d.department_name;


## 11. Employees jinka job same hai employee 169 ke job jaisa

SELECT first_name, last_name, department_id, job_id
FROM employees
WHERE job_id = (
    SELECT job_id 
    FROM employees
    WHERE employee_id = 169
);


## 12. Salary > Average Salary

SELECT employee_id, first_name, last_name
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

## 13. Finance department wale employees

SELECT e.department_id, e.first_name, e.job_id, d.department_name
FROM employees e
JOIN departments d 
    ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';


## 14. Salary < Employee 182’s salary

SELECT first_name, last_name, salary
FROM employees
WHERE salary < (
    SELECT salary 
    FROM employees
    WHERE employee_id = 182
);


## 15. Stored Procedure: CountEmployeesByDept

DELIMITER $$

CREATE PROCEDURE CountEmployeesByDept()
BEGIN
    SELECT department_id, COUNT(*) AS total_employees
    FROM employees
    GROUP BY department_id;
END $$

DELIMITER ;


## 16. Stored Procedure: AddNewEmployee

DELIMITER $$

CREATE PROCEDURE AddNewEmployee(
    IN p_first_name VARCHAR(50),
    IN p_last_name  VARCHAR(50),
    IN p_job_id     VARCHAR(20),
    IN p_salary     DECIMAL(10,2),
    IN p_department_id INT
)
BEGIN
    INSERT INTO employees (first_name, last_name, job_id, salary, department_id)
    VALUES (p_first_name, p_last_name, p_job_id, p_salary, p_department_id);
END $$

DELIMITER ;


## 17. Stored Procedure: DeleteEmployeesByDept

DELIMITER $$

CREATE PROCEDURE DeleteEmployeesByDept(IN p_department_id INT)
BEGIN
    DELETE FROM employees
    WHERE department_id = p_department_id;
END $$

DELIMITER ;


## 18. Stored Procedure: GetTopPaidEmployees (Highest salary per dept)

DELIMITER $$

CREATE PROCEDURE GetTopPaidEmployees()
BEGIN
    SELECT e.*
    FROM employees e
    JOIN (
        SELECT department_id, MAX(salary) AS max_sal
        FROM employees
        GROUP BY department_id
    ) x
    ON e.department_id = x.department_id 
       AND e.salary = x.max_sal;
END $$

DELIMITER ;


## 19. Stored Procedure: PromoteEmployee (salary + job change)

DELIMITER $$

CREATE PROCEDURE PromoteEmployee(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2),
    IN p_new_job_id VARCHAR(20)
)
BEGIN
    UPDATE employees
    SET salary = p_new_salary,
        job_id = p_new_job_id
    WHERE employee_id = p_emp_id;
END $$

DELIMITER ;


## 20. Stored Procedure: AssignManagerToDepartment

DELIMITER $$

CREATE PROCEDURE AssignManagerToDepartment(
    IN p_department_id INT,
    IN p_manager_id INT
)
BEGIN
    UPDATE employees
    SET manager_id = p_manager_id
    WHERE department_id = p_department_id;
END $$

DELIMITER ;







