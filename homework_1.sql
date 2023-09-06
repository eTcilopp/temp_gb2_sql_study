-- Drop the table if it exists
DROP TABLE IF EXISTS phones;


CREATE TABLE phones (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT,
    manufacturer TEXT,
    product_count INTEGER,
    price REAL
);

INSERT INTO phones (product_name, manufacturer, product_count, price)
VALUES
    ('iPhone 13', 'Apple', 20, 999.99),
    ('Samsung Galaxy S21', 'Samsung', 15, 799.99),
    ('Google Pixel 6', 'Google', 10, 799.00),
    ('OnePlus 9', 'OnePlus', 8, 699.00),
    ('Xiaomi Mi 11', 'Xiaomi', 12, 599.99),
    ('Sony Xperia 5 III', 'Sony', 7, 899.00),
    ('LG G8 ThinQ', 'LG', 5, 499.99),
    ('Asus ROG Phone 5', 'Asus', 6, 999.00),
    ('Nokia 9 PureView', 'Nokia', 3, 399.00),
    ('Motorola Moto G Power', 'Motorola', 9, 299.99),
    ('Huawei P40 Pro', 'Huawei', 7, 899.00),
    ('Oppo Find X3 Pro', 'Oppo', 8, 799.00),
    ('Realme GT', 'Realme', 10, 399.99),
    ('ZTE Axon 30 Ultra', 'ZTE', 4, 599.00),
    ('Lenovo Legion Phone Duel', 'Lenovo', 6, 899.00);

-- Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2

 SELECT
 	ph.product_name,
 	ph.manufacturer,
 	ph.price 
 FROM
 	phones ph
 WHERE
 	ph.product_count > 2;
 	
 -- Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
 
SELECT *
FROM 
	phones ph
WHERE 
	ph.manufacturer = 'Samsung';
	
-- 4.* С помощью SELECT-запроса с оператором LIKE / REGEXP найти:
-- 4.1.* Товары, в которых есть упоминание "Iphone"

SELECT *
FROM 
	phones ph
WHERE 
	ph.product_name like '%iphone%';

-- 4.2.* Товары, в которых есть упоминание "Samsung"
SELECT *
FROM 
	phones ph
WHERE 
	ph.product_name like '%samsung%' 
	or ph.manufacturer like '%samsung%';
	
-- 4.3.* Товары, в названии которых есть ЦИФРЫ

-- Я в SQLite, тут поставить REGEX - целая история

SELECT *
FROM 
	phones ph
WHERE 
	product_name LIKE '%0%' 
    OR product_name LIKE '%1%' 
    OR product_name LIKE '%2%' 
    OR product_name LIKE '%3%' 
    OR product_name LIKE '%4%' 
    OR product_name LIKE '%5%' 
    OR product_name LIKE '%6%' 
    OR product_name LIKE '%7%' 
    OR product_name LIKE '%8%' 
    OR product_name LIKE '%9%';

-- 4.4.* Товары, в названии которых есть ЦИФРА "8"
SELECT *
FROM 
	phones ph
WHERE 
	ph.product_name like '%8%' 
	or ph.manufacturer like '%8%';