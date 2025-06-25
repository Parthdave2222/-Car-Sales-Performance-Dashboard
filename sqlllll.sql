show tables;

SELECT * FROM car.`car sales`;
SELECT * FROM car.sheet1;
SELECT * FROM car.car_sql;
SELECT * FROM car.car_access;

DESCRIBE `car sales`;
ALTER TABLE `car sales` MODIFY `Date` DATE;

ALTER TABLE `car sales` ADD COLUMN `Date_backup` VARCHAR(255);
UPDATE `car sales` SET `Date_backup` = `Date`;

UPDATE `car sales`
SET `Date` = STR_TO_DATE(`Date`, '%m/%d/%Y')
WHERE `Date` IS NOT NULL AND `Date` LIKE '%/%';



ALTER TABLE car.`car sales`  ADD COLUMN EnquiryDate DATE;

UPDATE car.`car sales`
SET EnquiryDate = DATE_SUB(`Date`, INTERVAL (1 + MOD(Car_id, 10)) DAY)
WHERE EnquiryDate IS NULL AND `Date` IS NOT NULL;

UPDATE `car sales`
SET EnquiryDate = DATE_SUB(`Date`, INTERVAL (1 + MOD(Car_id * 7, 10)) DAY)
WHERE EnquiryDate IS NULL 
  AND `Date` IS NOT NULL;
  
ALTER TABLE car.`car sales`  ADD COLUMN EnquiryCompany text;

UPDATE `car sales`SET EnquiryCompany = Company;

CREATE TEMPORARY TABLE company_pool AS
SELECT DISTINCT Company FROM `car sales`;

CREATE TEMPORARY TABLE target_rows AS
SELECT Car_id, Company
FROM `car sales`
ORDER BY RAND()
LIMIT 3586;

CREATE TEMPORARY TABLE update_rows AS
SELECT t.Car_id, cp.Company AS NewCompany
FROM target_rows t
JOIN company_pool cp ON cp.Company <> t.Company
ORDER BY RAND()
LIMIT 3586;



SELECT COUNT(*) FROM update_rows;

SET @rn := 0;
CREATE TEMPORARY TABLE update_rows_numbered AS
SELECT *, (@rn := @rn + 1) AS rownum
FROM update_rows;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany
WHERE u.rownum BETWEEN 1 AND 500;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany
WHERE u.rownum BETWEEN 501 AND 1000;

select count(EnquiryCompany) from car.`car sales` where EnquiryCompany != Company;




-- neww

ALTER TABLE car.`car sales`  ADD COLUMN EnquiryModel text;

/*UPDATE `car sales`
SET EnquiryCompany = Company,
    EnquiryModel = Model;
    
CREATE TEMPORARY TABLE company_model_pool AS
SELECT DISTINCT Company, Model
FROM `car sales`;

DROP TEMPORARY TABLE IF EXISTS target_rows;

CREATE TEMPORARY TABLE target_rows AS
SELECT Car_id, Company, Model
FROM `car sales`
ORDER BY RAND()
LIMIT 3586;

DROP TEMPORARY TABLE IF EXISTS update_rows_numbered;

CREATE TEMPORARY TABLE update_rows1 AS
SELECT 
    t.Car_id,
    p.Company AS NewCompany,
    p.Model AS NewModel
FROM target_rows t
JOIN company_model_pool p 
    ON p.Company <> t.Company
   AND p.Model <> t.Model
ORDER BY RAND()
LIMIT 3586;

SET @rn := 0;
CREATE TEMPORARY TABLE update_rows_numbered AS
SELECT *, (@rn := @rn + 1) AS rownum
FROM update_rows1;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 1 AND 500;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 501 AND 1000;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 1001 AND 1500;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 1501 AND 2000;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 2001 AND 2500;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 2501 AND 3000;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 3001 AND 3501;

UPDATE `car sales` AS c
JOIN update_rows_numbered AS u ON c.Car_id = u.Car_id
SET c.EnquiryCompany = u.NewCompany,
    c.EnquiryModel = u.NewModel
WHERE u.rownum BETWEEN 3502 AND 3586;


SELECT COUNT(*) 
FROM `car sales`
WHERE (EnquiryCompany <> Company OR EnquiryModel <> Model)
  AND (EnquiryCompany, EnquiryModel) NOT IN (
    SELECT Company, Model FROM `car sales`
  );*/
  
  
  
  
SELECT * FROM car.`car sales`;
select count(EnquiryCompany) from car.`car sales` where EnquiryCompany != Company;

ALTER TABLE car.`car sales`  ADD COLUMN EnquiryDealer text;

UPDATE `car sales`
SET EnquiryDealer = Dealer_name;

DROP TEMPORARY TABLE IF EXISTS company_model_dealer_pool;

CREATE TEMPORARY TABLE company_model_dealer_pool AS
SELECT DISTINCT Company, Model, Dealer_name
FROM `car sales`;

DROP TEMPORARY TABLE IF EXISTS target_rows;

CREATE TEMPORARY TABLE target_rows AS
SELECT Car_id, Company, Model, Dealer_name
FROM `car sales`
ORDER BY RAND()
LIMIT 3586;


DROP TEMPORARY TABLE IF EXISTS update_rows;
CREATE TEMPORARY TABLE update_rows AS
SELECT 
    t.Car_id,
    p.Company AS NewCompany,
    p.Model AS NewModel,
    p.Dealer_name AS NewDealer
FROM target_rows t
JOIN company_model_dealer_pool p
  ON p.Company <> t.Company
 AND p.Model <> t.Model
 AND p.Dealer_name <> t.Dealer_name
ORDER BY RAND()
LIMIT 3586;

DROP TEMPORARY TABLE IF EXISTS update_rows_numbered;
SET @rn := 0;
CREATE TEMPORARY TABLE update_rows_numbered AS
SELECT *, (@rn := @rn + 1) AS rownum
FROM update_rows;


UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 1 AND 500;

UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 1 AND 500;


UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 1 AND 500;


UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 1 AND 500;


UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 501 AND 1000;

UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 1001 AND 1500;

UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 1501 AND 2000;


UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 2001 AND 2500;

UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 2501 AND 3000;

UPDATE `car sales` c
JOIN update_rows_numbered u ON c.Car_id = u.Car_id
SET 
  c.EnquiryCompany = u.NewCompany,
  c.EnquiryModel = u.NewModel,
  c.EnquiryDealer = u.NewDealer
WHERE u.rownum BETWEEN 3501 AND 3800;

SELECT COUNT(*)
FROM `car sales`
WHERE (EnquiryCompany <> Company OR EnquiryModel <> Model OR EnquiryDealer <> Dealer_name)
  AND (EnquiryCompany, EnquiryModel, EnquiryDealer) NOT IN (
    SELECT Company, Model, Dealer_name FROM `car sales`
  );

UPDATE `car sales`
SET EnquiryDate = DATE_SUB(`Date`, INTERVAL FLOOR(1 + RAND() * 10) DAY)
WHERE EnquiryDate IS NULL
  AND `Date` IS NOT NULL;
  
SELECT COUNT(*)
FROM `car sales`
WHERE EnquiryDate IS NOT NULL
  AND DATEDIFF(`Date`, EnquiryDate) NOT BETWEEN 1 AND 10;
  
SELECT * FROM car.`car sales`;
show columns from car.`car sales`;


update `car sales` set  Engine = 'Double Overhead Camshaft' where Transmission = 'Auto';
update car.sheet1 set  Engine = 'Double Overhead Camshaft' where Transmission = 'Auto';

ALTER TABLE `car sales`CHANGE COLUMN `Body style` `Body_style` VARCHAR(255);

Create table CarStorage As select Car_id,Company,Model,Engine,Transmission,Color,Body_style,Dealer_Name From car.`car sales`;

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM CarStorage	
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CarStorage.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
show columns from carstorage;
select * from Carstorage;

select * from carstorage where Company='Saab';

select count(car_id) from Carstorage;

insert into Carstorage(Car_id,Company,Model,Engine,Transmission,Color,Body_style,Dealer_Name) select Car_id,Company,Model,Engine,Transmission,Color,Body_style,Dealer_Name from car.carstorage_new_3250;


update carstorage set  Engine = 'Double Overhead Camshaft' where Transmission = 'Auto';

update carstorage set  Model='Saab 9-5' where Transmission = 'Manual' And Company='Saab';
update carstorage set  Model='Saab 9-3' where Transmission = 'Auto' And Company='Saab';


SELECT * FROM car.`car sales` where Company='Saab';

update car.`car sales` set  Model='Saab 9-5' where Transmission = 'Manual' And Company='Saab';
update car.`car sales` set  Model='Saab 9-3' where Transmission = 'Auto' And Company='Saab';

SELECT * FROM car.car_access where Company='Saab';

update car.car_access set  Model='Saab 9-5' where Model='5-Sep';
update car.car_access set  Model='Saab 9-3' where Model='3-Sep';

SELECT * FROM car.`car sales`;
ALTER TABLE `car sales` ADD COLUMN Discount DECIMAL(5,2);

UPDATE `car sales`
SET Discount = CASE
    -- Last 3 days of month
    WHEN DAY(`Date`) >= DAY(LAST_DAY(`Date`)) - 2
         THEN ROUND(10 + RAND() * 2, 2)  -- 10.00 to 12.00%
    -- Special event days (Diwali, Christmas)
    WHEN DATE(`Date`) IN ('2022-10-24', '2022-12-25','2023-11-12','2023-12-31','2022-5-2','2023-4-22')
         THEN ROUND(10 + RAND() * 2, 2)
    -- All other dates
    ELSE ROUND(5 + RAND() * 4, 2)        -- 5.00 to 9.00%
END
WHERE `Date` BETWEEN '2022-01-01' AND '2023-12-31';

/*UPDATE `car sales` AS cs
JOIN (
    SELECT
        `Date`,
        Dealer_Name,
        CASE
            -- 🎉 Last 3 days of the month
            WHEN DAY(`Date`) >= DAY(LAST_DAY(`Date`)) - 2 THEN 10 + FLOOR(RAND(UNIX_TIMESTAMP(`Date` + Dealer_Name)) * 3)
            
            -- 🎄 Fixed-date events (Christmas, Independence Day, Republic Day)
            WHEN DATE_FORMAT(`Date`, '%m-%d') IN ('12-25', '08-15', '01-26') THEN 10 + FLOOR(RAND(UNIX_TIMESTAMP(`Date` + Dealer_Name)) * 3)
            
            -- 🗓️ All other days
            ELSE 5 + FLOOR(RAND(UNIX_TIMESTAMP(`Date` + Dealer_Name)) * 5)
        END AS new_discount
    FROM `car sales`
    WHERE `Date` BETWEEN '2025-01-01' AND '2028-12-31'
    GROUP BY `Date`, Dealer_Name
) AS discounts
ON cs.`Date` = discounts.`Date` AND cs.Dealer_Name = discounts.Dealer_Name
SET cs.Discount = discounts.new_discount;*/










