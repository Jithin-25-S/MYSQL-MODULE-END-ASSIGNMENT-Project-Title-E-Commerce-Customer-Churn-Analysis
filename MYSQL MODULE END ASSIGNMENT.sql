1.Data Cleaning: (5 marks)
Handling Missing Values and Outliers:
A. Impute mean for the following columns, and round off to the nearest integer if
required: WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear,
DaySinceLastOrder.

Ans;
SELECT * FROM customer_churn;
UPDATE customer_churn
SET WarehouseToHome = (
    SELECT avg_value
    FROM (
        SELECT ROUND(AVG(WarehouseToHome)) AS avg_value
        FROM customer_churn
    ) AS temp
)
WHERE WarehouseToHome IS NULL;
set sql_safe_updates=0;
UPDATE customer_churn
SET HourSpendOnApp = (
    SELECT avg_value
    FROM (
        SELECT ROUND(AVG(HourSpendOnApp)) AS avg_value
        FROM customer_churn
    ) AS temp
)
WHERE HourSpendOnApp IS NULL;
UPDATE customer_churn
SET OrderAmountHikeFromlastYear = (
    SELECT avg_value
    FROM (
        SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) AS avg_value
        FROM customer_churn
    ) AS temp
)
WHERE OrderAmountHikeFromlastYear IS NULL;
UPDATE customer_churn
SET DaySinceLastOrder = (
    SELECT avg_value
    FROM (
        SELECT ROUND(AVG(DaySinceLastOrder)) AS avg_value
        FROM customer_churn
    ) AS temp
)
WHERE DaySinceLastOrder IS NULL;


 B. Impute mode for the following columns: Tenure, CouponUsed, OrderCount

Ans:
UPDATE customer_churn
SET Tenure = (
    SELECT mode_value
    FROM (
        SELECT Tenure AS mode_value
        FROM customer_churn
        WHERE Tenure IS NOT NULL
        GROUP BY Tenure
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS temp
)
WHERE Tenure IS NULL;
UPDATE customer_churn
SET OrderCount = (
    SELECT mode_value
    FROM (
        SELECT OrderCount AS mode_value
        FROM customer_churn
        WHERE OrderCount IS NOT NULL
        GROUP BY OrderCount
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS temp
)
WHERE OrderCount IS NULL;

 C. Handle outliers in the 'WarehouseToHome' column by deleting rows where the
values are greater than 100
Ans;

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

D.Dealing with Inconsistencies:
➢ Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and
“Mobile” in the 'PreferedOrderCat' column with “Mobile Phone” to ensure
uniformity.
Ans;

UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

E. Standardize payment mode values: Replace "COD" with "Cash on Delivery" and
"CC" with "Credit Card" in the PreferredPaymentMode column.
Ans;

UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';
UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

2. Data Transformation: (3 marks)
A. Column Renaming:
➢ Rename the column "PreferedOrderCat" to "PreferredOrderCat".
➢ Rename the column "HourSpendOnApp" to "HoursSpentOnApp"

Ans;

ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;
ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

2.B. Creating New Columns:
➢ Create a new column named ‘ComplaintReceived’ with values "Yes" if the
corresponding value in the ‘Complain’ is 1, and "No" otherwise.
➢ Create a new column named 'ChurnStatus'. Set its value to “Churned” if the
corresponding value in the 'Churn' column is 1, else assign “Active”

Ans:

ALTER TABLE customer_churn
ADD ComplaintReceived VARCHAR(10);
UPDATE customer_churn
SET ComplaintReceived =
CASE
    WHEN Complain = 1 THEN 'Yes'
    ELSE 'No'
END;
ALTER TABLE customer_churn
ADD ChurnStatus VARCHAR(20);
UPDATE customer_churn
SET ChurnStatus =
CASE
    WHEN Churn = 1 THEN 'Churned'
    ELSE 'Active'
END;

2.C. Column Dropping:
➢ Drop the columns "Churn" and "Complain" fData Exploration and Analysis: (17 marks)
➢ Retrieve the count of churned and active customers from the datasetrom the table
Ans;

ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;

Data Exploration and Analysis: (17 marks)
1. Retrieve the count of churned and active customers from the dataset
Ans;

SELECT
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY ChurnStatus;

2. Display the average tenure and total cashback amount of customers who
churned
Ans;

SELECT
    AVG(Tenure) AS AverageTenure,
    SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';

3. Determine the percentage of churned customers who complained.

Ans;

SELECT
    ROUND(
        SUM(CASE WHEN ComplaintReceived = 'Yes'
                 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS ComplaintPercentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';

4. Identify the city tier with the highest number of churned customers whose
preferred order category is Laptop & Accessory
Ans;

SELECT
    CityTier,
    COUNT(*) AS CustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Churned'
AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;

5.Identify the most preferred payment mode among active customers
Ans;

SELECT
    PreferredPaymentMode,
    COUNT(*) AS CustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY CustomerCount DESC
LIMIT 1;

6.Calculate the total order amount hike from last year for customers who are single
and prefer mobile phones for ordering
Ans:


SELECT
    SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountHike
FROM customer_churn
WHERE MaritalStatus = 'Single'
AND PreferredOrderCat = 'Mobile Phone';

7.Find the average number of devices registered among customers who used UPI as
their preferred payment mode.
Ans;

SELECT
    AVG(DeviceRegistered) AS AverageDevices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';
describe customer_churn;

SELECT
    AVG(DeviceRegistered) AS AverageDevices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';
describe customer_churn;
SELECT
    AVG(NumberOfDeviceRegistered) AS AverageDevices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

8.Determine the city tier with the highest number of customers
Ans;

SELECT
    CityTier,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;

9. Identify the gender that utilized the highest number of coupons.
Ans;

SELECT
    Gender,
    SUM(CouponUsed) AS TotalCouponsUsed
FROM customer_churn
GROUP BY Gender
ORDER BY TotalCouponsUsed DESC
LIMIT 1;

10.List the number of customers and the maximum hours spent on the app in each
preferred order category.
ans;

SELECT
    PreferredOrderCat,
    COUNT(*) AS CustomerCount,
    MAX(HoursSpentOnApp) AS MaximumHours
FROM customer_churn
GROUP BY PreferredOrderCat;

11.Calculate the total order count for customers who prefer using credit cards and
have the maximum satisfaction score.
Ans:

SELECT
    SUM(OrderCount) AS TotalOrderCount
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (
    SELECT MAX(SatisfactionScore)
    FROM customer_churn
);

12. What is  the average satisfaction score of customers who have complained?

Ans;

USE ecomm;
SELECT
    AVG(SatisfactionScore) AS AverageSatisfactionScore
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

13.List the preferred order category among customers who used more than 5
coupons
Ans;

SELECT DISTINCT
    PreferredOrderCat
FROM customer_churn
WHERE CouponUsed > 5;

14. List the top 3 preferred order categories with the highest average cashback
amount.
Ans;

SELECT
    PreferredOrderCat,
    AVG(CashbackAmount) AS AverageCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AverageCashback DESC
LIMIT 3;

15. Find the preferred payment modes of customers whose average tenure is 10
months and have placed more than 500 orders
Ans;
SELECT
    PreferredPaymentMode,
    AVG(Tenure) AS AverageTenure,
    SUM(OrderCount) AS TotalOrders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10
AND SUM(OrderCount) > 500;

16. Categorize customers based on their distance from the warehouse to home such
as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km,
'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the
churn status breakdown for each distance category
Ans;

SELECT
    CASE
        WHEN WarehouseToHome <= 5
            THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10
            THEN 'Close Distance'
        WHEN WarehouseToHome <= 15
            THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,

    ChurnStatus,
    COUNT(*) AS CustomerCount

FROM customer_churn

GROUP BY DistanceCategory, ChurnStatus

ORDER BY DistanceCategory;

17. List the customer’s order details who are married, live in City Tier-1, and their
order counts are more than the average number of orders placed by all
customers.
Ans;

SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
AND CityTier = 1
AND OrderCount > (
    SELECT AVG(OrderCount)
    FROM customer_churn
);

18. a) Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the
following data:
ANS;

USE ecomm;

CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount DECIMAL(10,2)
);



INSERT INTO customer_returns
(ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);


SELECT * FROM customer_returns;

b) Display the return details along with the customer details of those who have
churned and have made complaints.
ANS;

SELECT
    cr.ReturnID,
    cr.CustomerID,
    cr.ReturnDate,
    cr.RefundAmount,
    cc.*
FROM customer_returns cr
INNER JOIN customer_churn cc
ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
AND cc.ComplaintReceived = 'Yes';


SELECT * FROM customer_churn;

SELECT * FROM customer_returns;

SELECT COUNT(*) FROM customer_churn;

SELECT ChurnStatus, COUNT(*)
FROM customer_churn
GROUP BY ChurnStatus;

SET SQL_SAFE_UPDATES = 1;