-- Create table
CREATE TABLE companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100) UNIQUE
);

CREATE TABLE stocks (
    stock_id INT PRIMARY KEY,
    stock_symbol VARCHAR(10) UNIQUE,
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE stock_prices (
    price_id INT PRIMARY KEY,
    stock_id INT,
    date DATE,
    open_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    volume INT,
    FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);
-- Insert  data
INSERT INTO companies (company_id, company_name) 
VALUES 
    (1, 'Apple Inc.'),
    (2, 'Alphabet Inc.');

INSERT INTO stocks (stock_id, stock_symbol, company_id) 
VALUES 
    (1, 'AAPL', 1),  -- Apple Inc.
    (2, 'GOOGL', 2); -- Alphabet Inc.

INSERT INTO stock_prices (price_id, stock_id, date, open_price, high_price, low_price, close_price, volume) 
VALUES 
    (1, 1, '2023-01-01', 150.00, 155.00, 149.50, 153.00, 100000),  -- AAPL
    (2, 1, '2023-01-02', 153.00, 156.50, 152.00, 155.50, 120000),
    (3, 1, '2023-01-03', 156.00, 160.00, 155.50, 158.00, 110000),
    (4, 1, '2023-01-04', 158.50, 162.00, 157.50, 160.50, 130000),
    (5, 1, '2023-01-05', 161.00, 164.00, 160.50, 162.50, 140000),
    (6, 2, '2023-01-01', 2000.00, 2020.00, 1980.00, 2010.00, 50000), -- GOOGL
    (7, 2, '2023-01-02', 2010.00, 2035.00, 2005.00, 2030.00, 60000),
    (8, 2, '2023-01-03', 2020.00, 2040.00, 2010.00, 2035.00, 55000),
    (9, 2, '2023-01-04', 2040.00, 2060.00, 2035.00, 2055.00, 65000),
    (10, 2, '2023-01-05', 2055.00, 2070.00, 2045.00, 2065.00, 70000);

------------------------------------------------------------

---Calculate Average closing price for each Stock
select sp.stock_id,
	   s.stock_symbol,
	   AVG(sp.close_price) as avgcloseprice
from stock_prices sp, stocks s
where sp.stock_id =s.stock_id
group by sp.stock_id , s.stock_symbol

-- Query to find highest closing price for each stock
select sp.stock_id,
	   s.stock_symbol,
	   max(sp.high_price) as highestclosingprice
from stock_prices sp
join stocks s
on sp.stock_id = s.stock_id
group by sp.stock_id,s.stock_symbol

--Query to find stocks with closing price higher than the average closing price
SELECT stock_id, 
	   date,
	   close_price
FROM  stock_prices
WHERE close_price > (SELECT AVG(close_price) FROM stock_prices);

--Query to find stocks with closing price higher than the average closing price for each stock
select sp1.stock_id, 
	   sp1.close_price,
	   avgprice.averagecloseprice
from stock_prices sp1
join (select sp.stock_id, AVG(sp.close_price) as averagecloseprice 
		from stock_prices sp
		group by sp.stock_id) avgprice
on sp1.stock_id = avgprice.stock_id
where sp1.close_price > avgprice.averagecloseprice

--Query to  categorize stocks based on their closing price and comparing with avg price for each stock
select
    stock_id,
    date,
    close_price,
    AVG(close_price) OVER (PARTITION BY stock_id) AS avg_close_price,
    CASE
        WHEN close_price > AVG(close_price) OVER (PARTITION BY stock_id) THEN 'Above Average'
        WHEN close_price < AVG(close_price) OVER (PARTITION BY stock_id) THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS price_comparison
FROM stock_prices

--Query to rank stocks based on their closing price
SELECT stock_id, date, close_price,
       RANK() OVER (PARTITION BY stock_id ORDER BY close_price DESC) AS price_rank
FROM stock_prices;







 