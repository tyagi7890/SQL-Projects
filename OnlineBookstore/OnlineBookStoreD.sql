-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
USE OnlineBookstore;

-- Create Tables
-- DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
Book_ID INT PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT);

-- DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
Customer_ID INT PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(20),
City VARCHAR(50),
Country VARCHAR(200));

-- DROP TABLE IF EXISTS orders;
CREATE TABLE Orders(
Order_ID INT PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Total_Amount NUMERIC(10,2));

-- Add a column named “quantity” to the Orders table.
ALTER TABLE Orders ADD COLUMN Quantity INT AFTER Order_Date;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- import Data into Books Table
Show variables like 'secure_file_priv';

LOAD DATA INFILE  "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Books.csv"
INTO TABLE Books
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock);

-- Import Data Customers Table
LOAD DATA INFILE  "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv"
INTO TABLE Customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Customer_ID, Name, Email, Phone, City, Country);

-- Import Data into Orders Table
LOAD DATA INFILE  "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv"
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);

-- 1) Retrieve all books in the  'Fiction'  genre:
SELECT * FROM Books
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950 :
SELECT * FROM Books
WHERE Published_Year>1950;

-- 3) List all customers from the canada :
SELECT * FROM Customers
 WHERE trim(Country) = "Canada";

-- 4) Show orders placed in November 2023 :
SELECT * FROM Orders 
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available :
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6) Find the details of the most expensive book :
SELECT * FROM Books 
ORDER BY Price DESC  
LIMIT 1 ;

-- 7) Show all customers who ordered more than 1 quantity of a book :
SELECT * FROM Orders
WHERE Quantity >1;

-- 8) Retrieve all the Orders where the total amount exceeds $20 :
SELECT * FROM Orders
WHERE Total_Amount>20;

-- 9) List all  genres available in the books tables :
SELECT DISTINCT Genre FROM Books;

-- 10) Find the book with the lowest stock :
SELECT * FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders :
SELECT SUM(Total_Amount) AS Revenue
FROM Orders;


-- OTHER QUESTIONS :

-- 1) Retrieve the total number of books sold for each genre :
SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the 'Fantasy' genre : 
SELECT AVG (Price) AS Average_Price
FROM Books 
WHERE Genre = 'Fantasy'; 

-- 3) List customer's who have placed at least two orders : 
SELECT o.customer_id, c.name, COUNT(o.Order_ID) AS Order_COUNT
FROM orders o
JOIN customers c ON o.customer_ID=c.customer_id
GROUP BY o.customer_id, c.name 
HAVING COUNT(Order_ID) >= 2;

-- 4) Find the most frequently ordered book :
SELECT o.Book_id, b.title, COUNT(o.order_id) AS Order_Count
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY Order_Count DESC LIMIT 1;

-- 5) Show the most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE Genre='Fantasy'
ORDER BY price DESC LIMIT 3; 

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.Author, SUM(o.quantity) AS Total_Book_Sold
FROM orders o 
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;  

-- 7) List the cities where customers who spent over $30 are located :
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>30
ORDER BY total_amount;

-- 8) Find the customers who spent the most on orders :
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC LIMIT 1;

























