
DROP DATABASE IF EXISTS `grocery_store`;
CREATE DATABASE `grocery_store`;
USE `grocery_store`;


CREATE TABLE `products` (
  `product_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `quantity_in_stock` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`product_id`)
) AUTO_INCREMENT=11;
INSERT INTO `products` VALUES (1,'Foam Dinner Plate',70,1.21);
INSERT INTO `products` VALUES (2,'Pork - Bacon,back Peameal',49,4.65);
INSERT INTO `products` VALUES (3,'Lettuce - Romaine, Heart',38,3.35);
INSERT INTO `products` VALUES (4,'Brocolinni - Gaylan, Chinese',90,4.53);
INSERT INTO `products` VALUES (5,'Sauce - Ranch Dressing',94,1.63);
INSERT INTO `products` VALUES (6,'Petit Baguette',14,2.39);
INSERT INTO `products` VALUES (7,'Sweet Pea Sprouts',98,3.29);
INSERT INTO `products` VALUES (8,'Island Oasis - Raspberry',26,0.74);
INSERT INTO `products` VALUES (9,'Longan',67,2.26);
INSERT INTO `products` VALUES (10,'Broom - Push',6,1.09);


CREATE TABLE `employee` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birth_date` date DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` char(2) NOT NULL,
  PRIMARY KEY (`employee_id`)
) AUTO_INCREMENT=11;
INSERT INTO `employee` VALUES (1,'Babara','MacCaffrey','1986-03-28','781-932-9754','0 Sage Terrace','Waltham','MA');
INSERT INTO `employee` VALUES (2,'Ines','Brushfield','1986-04-13','804-427-9456','14187 Commercial Trail','Hampton','VA');
INSERT INTO `employee` VALUES (3,'Freddi','Boagey','1985-02-07','719-724-7869','251 Springs Junction','Colorado Springs','CO');
INSERT INTO `employee` VALUES (4,'Ambur','Roseburgh','1974-04-14','407-231-8017','30 Arapahoe Terrace','Orlando','FL');
INSERT INTO `employee` VALUES (5,'Clemmie','Betchley','1973-11-07',NULL,'5 Spohn Circle','Arlington','TX');
INSERT INTO `employee` VALUES (6,'Elka','Twiddell','1991-09-04','312-480-8498','7 Manley Drive','Chicago','IL');
INSERT INTO `employee` VALUES (7,'Ilene','Dowson','1964-08-30','615-641-4759','50 Lillian Crossing','Nashville','TN');
INSERT INTO `employee` VALUES (8,'Thacher','Naseby','1993-07-17','941-527-3977','538 Mosinee Center','Sarasota','FL');
INSERT INTO `employee` VALUES (9,'Romola','Rumgay','1992-05-23','559-181-3744','3520 Ohio Trail','Visalia','CA');
INSERT INTO `employee` VALUES (10,'Levy','Mynett','1969-10-13','404-246-3370','68 Lawn Avenue','Atlanta','GA');

INSERT INTO `employee` VALUES (1000,'admin','admin','1969-10-13','404-246-3370','admin','admin','AD');



CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL,
  `order_date` date NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_employee_idx` (`employee_id`),
  CONSTRAINT `fk_orders_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`) ON UPDATE CASCADE
) AUTO_INCREMENT=11;
INSERT INTO `orders` VALUES (1,6,'2019-01-30');
INSERT INTO `orders` VALUES (2,7,'2018-08-02');
INSERT INTO `orders` VALUES (3,8,'2017-12-01');
INSERT INTO `orders` VALUES (4,2,'2017-01-22');
INSERT INTO `orders` VALUES (5,5,'2017-08-25');
INSERT INTO `orders` VALUES (6,10,'2018-11-18');
INSERT INTO `orders` VALUES (7,2,'2018-09-22');
INSERT INTO `orders` VALUES (8,5,'2018-06-08');
INSERT INTO `orders` VALUES (9,10,'2017-07-05');
INSERT INTO `orders` VALUES (10,6,'2018-04-22');


CREATE TABLE `order_items` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `fk_order_items_products_idx` (`product_id`),
  CONSTRAINT `fk_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_order_items_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE
);
INSERT INTO `order_items` VALUES (1,4,4);
INSERT INTO `order_items` VALUES (2,1,2);
INSERT INTO `order_items` VALUES (2,4,4);
INSERT INTO `order_items` VALUES (2,6,2);
INSERT INTO `order_items` VALUES (3,3,10);
INSERT INTO `order_items` VALUES (4,3,7);
INSERT INTO `order_items` VALUES (4,10,7);
INSERT INTO `order_items` VALUES (5,2,3);
INSERT INTO `order_items` VALUES (6,1,4);
INSERT INTO `order_items` VALUES (6,2,4);
INSERT INTO `order_items` VALUES (6,3,4);
INSERT INTO `order_items` VALUES (6,5,1);
INSERT INTO `order_items` VALUES (7,3,7);
INSERT INTO `order_items` VALUES (8,5,2);
INSERT INTO `order_items` VALUES (8,8,2);
INSERT INTO `order_items` VALUES (9,6,5);
INSERT INTO `order_items` VALUES (10,1,10);
INSERT INTO `order_items` VALUES (10,9,9);


CREATE TABLE `user` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `role`     varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `EMPLOYEE` (`employee_id`) ON UPDATE CASCADE
) ;
INSERT INTO `USER` VALUES ('admin','root', 1000, 'admin');
INSERT INTO `USER` VALUES ('e001','12345', 1, 'app');


CREATE TABLE `session` (
  `cookie` varchar(64) NOT NULL,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`cookie`),
  KEY `fk_username` (`username`),
  CONSTRAINT `fk_username` FOREIGN KEY (`username`) REFERENCES `USER` (`username`) ON UPDATE CASCADE
);

SELECT * FROM user WHERE username = "admin" AND password = "root"


SELECT sum(quantity * unit_price) FROM order_items JOIN products ON order_items.product_id = products.product_id where order_id = 2 

