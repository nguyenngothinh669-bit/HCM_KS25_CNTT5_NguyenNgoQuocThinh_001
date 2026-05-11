-- commit lại 

CREATE DATABASE hackathon_db ; 
USE hackathon_db ;

CREATE TABLE Creator (
	creator_id VARCHAR(5) PRIMARY KEY , 
    creator_name VARCHAR(100) NOT NULL , 
    creator_email VARCHAR(100) NOT NULL UNIQUE , 
    creator_phone VARCHAR(15) NOT NULL UNIQUE , 
    creator_platform VARCHAR(50) NOT NULL 
); 

CREATE TABLE Studio (
	studio_id VARCHAR(5) PRIMARY KEY, 
    studio_name VARCHAR(100) NOT NULL , 
    studio_location VARCHAR(100) NOT NULL , 
    hourly_price DECIMAL(10,2) NOT NULL ,
    studio_status VARCHAR(20) NOT NULL 
) ;  

CREATE TABLE LiveSession (
	session_id INT PRIMARY KEY AUTO_INCREMENT , 
    creator_id VARCHAR(5) NOT NULL , 
    studio_id VARCHAR(5) NOT NULL , 
    session_date DATE NOT NULL , 
    duration_hours INT NOT NULL , 
    
   CONSTRAINT fk_creator_id FOREIGN KEY (creator_id) REFERENCES Creator(creator_id) ON DELETE CASCADE ,
   CONSTRAINT fk_studio_id FOREIGN KEY (studio_id) REFERENCES Studio(studio_id) ON DELETE CASCADE 
) ; 

CREATE TABLE Payment (
	payment_id INT PRIMARY KEY AUTO_INCREMENT , 
    session_id INT , 
    payment_method VARCHAR(50) NOT NULL , 
    payment_amount DECIMAL(10,2) NOT NULL , 
    payment_date DATE NOT NULL , 
    
    CONSTRAINT fk_session_id FOREIGN KEY (session_id) REFERENCES LiveSession(session_id) ON DELETE CASCADE 
) ; 

INSERT INTO Creator (creator_id, creator_name, creator_email,creator_phone,creator_platform) 
VALUES 
('CR01','Nguyen Van A','a@live.com','0901111111','Tiktok') , 
('CR02','Tran Thi B','b@live.com','0902222222','Youtube') ,
('CR03','Le Minh C','c@live.com','0903333333','Facebook') ,
('CR04','Pham Thi D','d@live.com','0904444444','Tiktok') ,
('CR05','Vu Hoang E','e@live.com','0905555555','Shoppe live') ; 

INSERT INTO Studio (studio_id , studio_name , studio_location , hourly_price, studio_status)
VALUES 
('ST01','Studio A' , 'Ha Noi',20.00,'Available') , 
('ST02','Studio B' , 'HCM',25.00,'Available') , 
('ST03','Studio C' , 'Da Nang',30.00,'Booked') , 
('ST04','Studio D' , 'Ha Noi',22.00,'Available') , 
('ST05','Studio E' , 'Can Tho',18.00,'Maintenance') ; 

INSERT INTO LiveSession (session_id, creator_id, studio_id, session_date ,duration_hours) 
VALUES 
(1,'CR01','ST01','2025-05-01',3) ,
(2,'CR02','ST02','2025-05-02',4) ,
(3,'CR03','ST03','2025-05-03',2) ,
(4,'CR01','ST04','2025-05-04',5) ,
(5,'CR05','ST02','2025-05-05',1) ;

INSERT INTO Payment (session_id,payment_method,payment_amount,payment_date) 
VALUES 
(1,'Cash',60.00,'2025-05-01') ,
(2,'Credit Card',100.00,'2025-05-02') ,
(3,'Bank Transfer',60.00,'2025-05-03') , 
(4,'Credit Card',110.00,'2025-05-04') ,
(5,'Cash',25.00,'2025-05-05') ; 
 

UPDATE Creator 
SET creator_platform = 'Youtube' 
WHERE creator_id = 'CR03' ; 

UPDATE Studio 
SET studio_status = 'Available' 
WHERE studio_id = 'ST05' ; 

UPDATE Studio 
SET hourly_price = hourly_price * 0.9 
WHERE studio_id = 'ST05' ; 


SET SQL_SAFE_UPDATES = 0 ; 
DELETE FROM Payment 
WHERE payment_method = 'Cash' AND  payment_date < '2025-05-03'; 
SET SQL_SAFE_UPDATES = 1 ; 

SELECT * FROM Studio 
WHERE studio_status = 'Available' AND hourly_price > 20 ; 

SELECT creator_name, creator_phone 
FROM Creator 
WHERE creator_platform = 'Tiktok' ;

SELECT studio_id, studio_name, hourly_price
FROM Studio 
ORDER BY hourly_price DESC ;

SELECT * FROM Payment 
WHERE payment_method = 'Credit Card'
LIMIT 3 ; 

SELECT creator_id, creator_name
FROM Creator 
ORDER BY creator_id
LIMIT 2 OFFSET 2 ; 
-- 1 
SELECT ls.session_id, c.creator_name, st.studio_name, ls.duration_hours, p.payment_amount
FROM LiveSession ls 
JOIN Creator c ON c.creator_id = ls.creator_id 
JOIN Studio st ON st.studio_id = ls.studio_id 
JOIN Payment p ON p.session_id = ls.session_id ; 
-- 2 Liệt kê tất cả studio và số lần được sử dụng (kể cả studio chưa từng được thuê). 
SELECT st.studio_id,st.studio_name,COUNT(ls.session_id) AS SoLan
FROM Studio st
LEFT JOIN LiveSession ls On ls.studio_id= st.studio_id
GROUP BY st.studio_id,st.studio_name ;
-- 3 
SELECT payment_method , SUM(payment_amount) AS total_payment
FROM Payment 
GROUP BY payment_method ; 

-- 4
SELECT creator_id ,COUNT(session_id) AS total_sessions 
FROM LiveSession 
GROUP BY creator_id 
HAVING total_sessions >= 2 
ORDER BY total_sessions DESC  ;  

-- 5 
SELECT studio_name , hourly_price  FROM Studio 
WHERE hourly_price > (SELECT AVG(hourly_price) FROM Studio ) ; 

-- 6 Hiển thị creator_name, creator_email của những creator đã từng livestream tại Studio B.
SELECT DISTINCT  c.creator_name, c.creator_email 
FROM Creator c 
JOIN LiveSession ls ON ls.creator_id = c.creator_id 
JOIN Studio st ON ls.studio_id = st.studio_id
WHERE st.studio_name = 'Studio B' ; 


SELECT ls.session_id, c.creator_name, st.studio_name, p.payment_method, p.payment_amount
FROM LiveSession ls 
JOIN Creator c ON c.creator_id = ls.creator_id 
JOIN Studio st ON st.studio_id = ls.studio_id 
JOIN Payment p ON p.session_id = ls.session_id ;

