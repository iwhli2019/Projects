CREATE DATABASE  IF NOT EXISTS `winery_micro_brewery` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `winery_micro_brewery`;
-- MySQL dump 10.13  Distrib 8.0.20, for macos10.15 (x86_64)
--
-- Host: localhost    Database: winery_micro_brewery
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AGING`
--

DROP TABLE IF EXISTS `AGING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AGING` (
  `LOT_NO` varchar(10) NOT NULL,
  `IN_DATE` date DEFAULT NULL,
  `OUT_DATE` date DEFAULT NULL,
  PRIMARY KEY (`LOT_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AGING`
--

LOCK TABLES `AGING` WRITE;
/*!40000 ALTER TABLE `AGING` DISABLE KEYS */;
INSERT INTO `AGING` VALUES ('L20003W','2000-03-25','2001-03-25'),('L20009B','2000-09-25','2001-03-24'),('L20013W','2001-03-25','2002-03-25'),('L20019B','2001-09-25','2002-03-24'),('L20023W','2002-03-25','2003-03-25'),('L20029B','2002-09-25','2003-03-24'),('L20033W','2003-03-25','2004-03-24'),('L20039B','2003-09-25','2004-03-23'),('L20043W','2004-03-25','2005-03-25'),('L20049B','2004-09-25','2005-03-24'),('L20053W','2005-03-25','2006-03-25'),('L20059B','2005-09-25','2006-03-24'),('L20063W','2006-03-25','2007-03-25'),('L20069B','2006-09-25','2007-03-24'),('L20073W','2007-03-25','2008-03-24'),('L20079B','2007-09-25','2008-03-23'),('L20083W','2008-03-25','2009-03-25'),('L20089B','2008-09-25','2009-03-24'),('L20093W','2009-03-25','2010-03-25'),('L20099B','2009-09-25','2010-03-24'),('L20103W','2010-03-25','2011-03-25'),('L20109B','2010-09-25','2011-03-24'),('L20113W','2011-03-25','2012-03-24'),('L20119B','2011-09-25','2012-03-23'),('L20123W','2012-03-25','2013-03-25'),('L20129B','2012-09-25','2013-03-24'),('L20133W','2013-03-25','2014-03-25'),('L20139B','2013-09-25','2014-03-24'),('L20143W','2014-03-25','2015-03-25'),('L20149B','2014-09-25','2015-03-24'),('L20153W','2015-03-25','2016-03-24'),('L20159B','2015-09-25','2016-03-23'),('L20163W','2016-03-25','2017-03-25'),('L20169B','2016-09-25','2017-03-24'),('L20173W','2017-03-25','2018-03-25'),('L20179B','2017-09-25','2018-03-24'),('L20183W','2018-03-25','2019-03-25'),('L20189B','2018-09-25','2019-03-24'),('L20193W','2019-03-25','2020-03-24'),('L20199B','2019-09-25','2020-03-23'),('L20203W','2020-03-25','2021-03-25'),('L20209B','2020-09-25','2021-03-10');
/*!40000 ALTER TABLE `AGING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CUSTOMER`
--

DROP TABLE IF EXISTS `CUSTOMER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CUSTOMER` (
  `CUS_ID` varchar(6) NOT NULL,
  `CUSTOMER_NAME` varchar(255) DEFAULT NULL,
  `CONTACT_FIRST_NAME` varchar(100) DEFAULT NULL,
  `CONTACT_LAST_NAME` varchar(100) DEFAULT NULL,
  `ADDRESS` varchar(500) DEFAULT NULL,
  `CITY` varchar(500) DEFAULT NULL,
  `STATE` varchar(500) DEFAULT NULL,
  `COUNTRY` varchar(500) DEFAULT NULL,
  `POSTAL_CODE` varchar(45) DEFAULT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CUSTOMER`
--

LOCK TABLES `CUSTOMER` WRITE;
/*!40000 ALTER TABLE `CUSTOMER` DISABLE KEYS */;
INSERT INTO `CUSTOMER` VALUES ('C00001','Thunderstorm Enterprises','Stone','Felicity','4099 Cunnungham Court','Troy','Michigan','USA','48083','Felicity_Stone@thunderstorm.com'),('C00002','Spreadhead Corp','Byrd','Sabrina','1896 Augusta Park','Beckley','West Virginia','USA','25801','Sabrina_Byrd@spreadhead.com'),('C00003','Thronhill Corp','Maxwell','Sana','1700 Main Street','Tukwila','Washington','USA','98168','Sana_Maxwell@thronhill.com'),('C00004',NULL,'Fisher','Elmer','442 Storsin Vista','Lautem',NULL,'Timor Leste',NULL,'Elmer_Fisher@gmail.com'),('C00005',NULL,'Whittle','Leonie','829 Ima Trafficway','Siutu',NULL,'Samoa',NULL,'Leonie_Whittle@gmail.com'),('C00006',NULL,'Hunt','May','705 Kling Club',NULL,'Aqaba','Jordan',NULL,'May_Hunt@gmail.com'),('C00007',NULL,'Medina','Haider','751 Stehr Skyway','cercle de Fahs','caïdat de Ksar Sghir','Morocco','94152','Haider_Medina@gmail.com'),('C00008',NULL,'Mccormick','Siana','693 Schoolhouse Lane','Lansdale','Pennsylvania','USA','19446','Siana_Mccormick@gmail.com'),('C00009',NULL,'Hopkins','Betty','93 N. El Dorado Drive ','Macomb','Michigan','USA','48042','Betty_Hopkins@gmail.com'),('C00010',NULL,'Nelson','Dexter','8053 N. Oak Ave','Strakville','Mississippi','USA','39759','Dexter_Nelson@gmail.com'),('C00011',NULL,'Bush','Harriet','736 Gainsway St','Camden','New Jersey','USA','8105','Harriet_Bush@gmail.com'),('C00012',NULL,'Curry','Molly','77 Oxford St. ','San Lorenzo','Carlifornia','USA','94580','Molly_Curry@gmail.com'),('C00013','Unicorn Ltd','Ferguson','Bernard','34 College Rd','Oakland Gardens','New York','USA','11364','Bernard_Ferguson@unicorn.com'),('C00014',NULL,'Barnes','Jenson','Michigan 2801','Chihuahua','Chihuahua','Mexico','31214','Jenson_Barnes@gmail.com'),('C00015',NULL,'Yang','Zack','Route Cantonale 51a','Le Bouveret','Canton du Valais','Switzerland','1897','Zack_Yang@gmail.com'),('C00016',NULL,'Ray','Sarah','Rayon 2610 norte','Nuevo leon','Monterrey','Mexico','64410','Sarah_Ray@gmail.com'),('C00017',NULL,'Luna','Euan','Avenue des Alpes 15','Montreux','Canton de Geneve','Switzerland','1820','Euan_Luna@gmail.com'),('C00018',NULL,'Thompson','John','Avenue Leopold de Reynier','Leusin','Canton de Vaud','Switzerland','1854','John_Thompson@gmail.com'),('C00019',NULL,'Wilkins','Hugh','9383 Berkshire Street','Northbrook','Illinois','USA','60062','Hugh_Wilkins@gmail.com'),('C00020','Stormeye Ltd','Vega','Zaximillian','9885 Sunset Road','Mount Prospect','Illinois','USA','60056','Zaximillian_Vega@stormeye.com'),('C00021',NULL,'Christensen','Evangeline','Reforma 1709, Nueva','Baja California','Mexicali','Mexico','21100','Evangeline_Christensen@gmail.com'),('C00022',NULL,'Avila','Savannah','306 Praire Street','Mount Juliet','Tennessee','USA','37122','Savannah_Avila@gmail.com'),('C00023',NULL,'Leonard','Gethin','105 Randall Mill Street','Beltsville','Maryland','USA','20705','Gethin_Leonard@gmail.com'),('C00024',NULL,'Doyle','Aysha','2 PTE No. 2910','Puebla','Puebla','Mexico','72140','Aysha_Doyle@gmail.com'),('C00025','Foodie Enterprises','Stevens','Haroon','2 Elmwood Dr','Ballston Spa','New York','USA','12020','Haroon_Stevens@foodie.com'),('C00026',NULL,'Gordon','Daniel','169 Marsh Lane','Bismarck','North Dakota','USA','58501','Daniel_Gordon@gmail.com'),('C00027',NULL,'Banks','Eva','Aldama No. 619 Centro','Tabasco','Villahermosa','Mexico','86000','Eva_Banks@gmail.com'),('C00028',NULL,'Hines','Penelop','53G 429, Francisco de Montejo','Yucatan','Merida','Mexico','97203','Penelop_Hines@gmail.com'),('C00029',NULL,'Ward','Kian','Benito Juarez 2_B','Las Juntas','Sonora','Guaymas','85440','Kian_Ward@gmail.com'),('C00030',NULL,'Carlson','William','Carr Tequisquiapan KM 4.5','Queretaro','San Juan del Rio','Mexico','76800','William_Carlson@gmail.com');
/*!40000 ALTER TABLE `CUSTOMER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EMP_POSITION`
--

DROP TABLE IF EXISTS `EMP_POSITION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMP_POSITION` (
  `EMP_ID` varchar(30) NOT NULL,
  `POSITION_ID` varchar(100) NOT NULL,
  `POSITION_START_DATE` date DEFAULT NULL,
  `POSITION_END_DATE` date DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`POSITION_ID`),
  KEY `fk_EMP_POSITION_POSITION1_idx` (`POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMP_POSITION`
--

LOCK TABLES `EMP_POSITION` WRITE;
/*!40000 ALTER TABLE `EMP_POSITION` DISABLE KEYS */;
INSERT INTO `EMP_POSITION` VALUES ('E00001','A1','2000-03-05','9999-12-31'),('E00002','W1','2007-03-13','2014-04-30'),('E00002','W2','2000-03-13','2007-03-12'),('E00003','W2','2010-05-23','2012-02-24'),('E00003','W4','2000-05-23','2005-05-22'),('E00004','W3','2000-07-23','2013-01-22'),('E00005','W4','2000-09-28','2015-07-17'),('E00006','W5','2000-10-05','2015-08-26'),('E00007','W5','2001-07-05','9999-12-31'),('E00008','W6','2001-11-09','9999-12-31'),('E00009','W6','2001-12-21','2013-04-20'),('E00010','W7','2002-05-01','9999-12-31'),('E00011','W7','2002-08-05','2013-02-27'),('E00012','W7','2002-12-22','9999-12-31'),('E00013','W7','2003-08-05','2013-07-23'),('E00014','W7','2003-09-18','9999-12-31'),('E00015','S1','2009-10-26','2011-01-02'),('E00015','S2','2007-10-26','2009-10-25'),('E00015','S3','2003-10-26','2007-10-25'),('E00016','S2','2006-11-20','2010-08-07'),('E00016','S3','2003-11-20','2006-11-19'),('E00017','S3','2004-01-12','2011-04-19'),('E00018','S3','2004-06-02','2011-05-22'),('E00019','S3','2004-10-12','2012-12-19'),('E00020','B1','2010-01-29','2013-02-24'),('E00020','B2','2005-01-29','2010-01-28'),('E00021','B2','2005-10-12','9999-12-31'),('E00022','B2','2007-02-13','2014-03-09'),('E00023','B2','2007-05-09','9999-12-31'),('E00024','B2','2007-07-15','9999-12-31'),('E00025','B2','2007-11-19','9999-12-31'),('E00026','F1','2008-01-15','2012-05-03'),('E00027','F1','2008-02-13','9999-12-31'),('E00028','S4','2009-03-17','2011-07-02'),('E00029','L1','2009-03-28','2011-06-30'),('E00030','L1','2009-04-03','2013-10-03'),('E00031','S2','2010-07-24','2012-06-16'),('E00032','S1','2010-12-19','9999-12-31'),('E00032','S2','2008-12-19','2010-12-18'),('E00033','S3','2011-04-05','9999-12-31'),('E00034','S3','2011-05-08','9999-12-31'),('E00035','L1','2011-06-16','9999-12-31'),('E00036','S4','2011-06-18','9999-12-31'),('E00037','W2','2017-02-09','9999-12-31'),('E00037','W4','2012-02-10','2017-02-08'),('E00038','F1','2012-04-19','9999-12-31'),('E00039','S2','2012-06-02','9999-12-31'),('E00040','S3','2012-12-05','9999-12-31'),('E00041','W3','2013-01-08','9999-12-31'),('E00042','B1','2013-02-10','9999-12-31'),('E00043','W7','2013-02-13','9999-12-31'),('E00044','W6','2013-04-06','9999-12-31'),('E00045','W7','2013-07-09','9999-12-31'),('E00046','L1','2013-09-19','9999-12-31'),('E00047','B2','2014-02-23','9999-12-31'),('E00048','W1','2014-05-01','9999-12-31'),('E00048','W2','2009-04-17','2014-04-30'),('E00049','W4','2015-07-03','9999-12-31'),('E00050','W5','2015-08-12','9999-12-31');
/*!40000 ALTER TABLE `EMP_POSITION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EMP_SALARY`
--

DROP TABLE IF EXISTS `EMP_SALARY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMP_SALARY` (
  `EMP_ID` varchar(30) NOT NULL,
  `SALARY` int DEFAULT NULL,
  `SALARY_START_DATE` date DEFAULT NULL,
  `SALARY_END_DATE` date DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMP_SALARY`
--

LOCK TABLES `EMP_SALARY` WRITE;
/*!40000 ALTER TABLE `EMP_SALARY` DISABLE KEYS */;
INSERT INTO `EMP_SALARY` VALUES ('E00001',5000,'2000-03-05','9999-12-31'),('E00002',1750,'2000-03-13','2003-03-13'),('E00003',1250,'2000-05-23','2003-05-23'),('E00004',1500,'2000-07-23','2003-07-23'),('E00005',1250,'2000-09-28','2003-09-28'),('E00006',1250,'2000-10-05','2003-10-05'),('E00007',1250,'2001-07-05','2004-07-04'),('E00008',1100,'2001-11-09','2004-11-08'),('E00009',1100,'2001-12-21','2004-12-20'),('E00010',1000,'2002-05-01','2005-04-30'),('E00011',1000,'2002-08-05','2005-08-04'),('E00012',1000,'2002-12-22','2005-12-21'),('E00013',1000,'2003-08-05','2006-08-04'),('E00014',1000,'2003-09-18','2006-09-17'),('E00015',1000,'2003-10-26','2006-10-25'),('E00016',1000,'2003-11-20','2006-11-19'),('E00017',1000,'2004-01-12','1899-12-31'),('E00018',1000,'2004-06-02','1899-12-31'),('E00019',1000,'2004-10-12','2012-12-19'),('E00020',1750,'2005-01-29','2010-01-28'),('E00021',1750,'2005-10-12','1899-12-31'),('E00022',1750,'2007-02-13','1899-12-31'),('E00023',1750,'2007-05-09','1899-12-31'),('E00024',1750,'2007-07-15','1899-12-31'),('E00025',1750,'2007-11-19','1899-12-31'),('E00026',1500,'2008-01-15','2012-05-03'),('E00027',1500,'2008-02-13','1899-12-31'),('E00028',2000,'2009-03-17','2011-07-02'),('E00029',1750,'2009-03-28','2011-06-30'),('E00030',1750,'2009-04-03','2013-10-03'),('E00031',1500,'2010-07-24','2012-06-16'),('E00032',1500,'2008-12-19','2010-12-18'),('E00033',1000,'2011-04-05','1899-12-31'),('E00034',1000,'2011-05-08','1899-12-31'),('E00035',1750,'2011-06-16','1899-12-31'),('E00036',2000,'2011-06-18','1899-12-31'),('E00037',1250,'2012-02-10','1899-12-31'),('E00038',1500,'2012-04-19','1899-12-31'),('E00039',1500,'2012-06-02','1899-12-31'),('E00040',1000,'2012-12-05','1899-12-31'),('E00041',0,'2013-01-08','1899-12-31'),('E00042',2000,'2013-02-10','1899-12-31'),('E00043',1000,'2013-02-13','1899-12-31'),('E00044',1100,'2013-04-06','1899-12-31'),('E00045',1000,'2013-07-09','1899-12-31'),('E00046',1750,'2013-09-19','1899-12-31'),('E00047',1750,'2014-02-23','1899-12-31'),('E00048',1750,'2009-04-17','1899-12-31'),('E00049',1250,'2015-07-03','1899-12-31'),('E00050',1250,'2015-08-12','1899-12-31');
/*!40000 ALTER TABLE `EMP_SALARY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EMPLOYEES`
--

DROP TABLE IF EXISTS `EMPLOYEES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMPLOYEES` (
  `EMP_ID` varchar(30) NOT NULL,
  `FIRST_NAME` varchar(100) DEFAULT NULL,
  `LAST_NAME` varchar(100) DEFAULT NULL,
  `BDAY` date DEFAULT NULL,
  `GENDER` char(1) DEFAULT NULL,
  `ADDRESS` varchar(255) DEFAULT NULL,
  `CITY` varchar(50) DEFAULT NULL,
  `POSTAL_CODE` int DEFAULT NULL,
  `COUNTRY` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMPLOYEES`
--

LOCK TABLES `EMPLOYEES` WRITE;
/*!40000 ALTER TABLE `EMPLOYEES` DISABLE KEYS */;
INSERT INTO `EMPLOYEES` VALUES ('E00001','Samantha','Groves','1988-04-21','F','72 Southampton Drive ','Garden Grove',92840,'USA'),('E00002','Michael','Bishop','1965-09-27','M','139 South Arrowhead St. ','San Diego',92115,'USA'),('E00003','Alexandra','Udinov','1973-09-02','F','9029 Berkshire Street ','Oceanside',92056,'USA'),('E00004','Carina','Miller','1990-05-01','F','739 Brickyard Dr. ','Tracy',95376,'USA'),('E00005','Harold','Finch','1987-06-29','M','8174 53rd Dr. ','Van Nuys',91406,'USA'),('E00006','Desmond','Miles','2002-03-01','M','9125 Hartford St. ','Huntington Beach',92647,'USA'),('E00007','Buffy','Summers','1963-08-13','F','109 Tarkiln Hill Street ','South Gate',90280,'USA'),('E00008','Nikita','Mears','1965-12-25','F','362 Williams Dr. ','Pittsburg',94565,'USA'),('E00009','John','Reese','1982-03-13','M','543 Strawberry Rd. ','San Francisco',94122,'USA'),('E00010','Lana','Kane','1975-09-15','F','8681 Lees Creek St. ','San Jose',95123,'USA'),('E00011','Sameen','Shaw','1992-10-27','F','8 Liberty Rd. ','Van Nuys',91405,'USA'),('E00012','Sterling','Archer','2001-05-17','M','7995 W. Tower Drive ','San Jose',95116,'USA'),('E00013','Jemma','Simmons','1965-11-08','F','806 North Lantern Road ','Los Angeles',90001,'USA'),('E00014','Morgan','Grimes','2002-09-27','M','29 Military Ave. ','Hesperia',92345,'USA'),('E00015','Jean','Grey','2001-07-27','F','578 Gates Street ','Pacoima',91331,'USA'),('E00016','Sydney','Bristow','1977-12-26','F','96 Iroquois Ave. ','Vista',92083,'USA'),('E00017','Owen','Elliot','1998-02-07','M','9286 Goldfield Rd. ','San Jose',95122,'USA'),('E00018','Daniel','Sousa','1968-03-24','M','40 Brewery St. ','Corona',92882,'USA'),('E00019','Jane','Smith','1994-12-30','F','572 Indian Summer St. ','Riverside',92503,'USA'),('E00020','Lucy','Stillman','1982-05-25','F','167 Selby Ave. ','Tulare',93274,'USA'),('E00021','Scott','Summers','2001-09-27','M','22 Andover Ave. ','San Francisco',94109,'USA'),('E00022','Leo','Fitz','1968-04-20','M','20 Amerige Drive ','Wilmington',90744,'USA'),('E00023','Angel','Jones','1978-07-10','M','967 Maple Drive ','Santa Ana',92701,'USA'),('E00024','Michael','Vaughn','1994-03-18','M','714 Rose Ave. ','Los Angeles',90006,'USA'),('E00025','Daisy','Johnson','1967-08-25','F','5 Golf Dr. ','Oxnard',93030,'USA'),('E00026','Sarah','Walker','1991-10-06','F','24 Howard St. ','Anaheim',92801,'USA'),('E00027','Chuck','Bartowski','2000-04-18','M','8015 San Pablo Dr. ','Union City',94587,'USA'),('E00028','James','Barnes','1973-09-07','M','314 Glen Eagles Dr. ','Palmdale',93550,'USA'),('E00029','Natalie','Rushman','1990-09-21','F','7928 Broad Drive ','Los Angeles',90034,'USA'),('E00030','John','Smith','1971-10-25','M','371 Buckingham Street ','Livermore',94550,'USA'),('E00031','Tony','Hunt','2002-09-17','M','8 Liberty Rd. ','Van Nuys',91405,'USA'),('E00032','Jemma','Gardner','1982-06-05','F','967 Maple Drive ','Santa Ana',92701,'USA'),('E00033','Dorothy','Holland','1992-05-13','F','5 Golf Dr. ','Oxnard',93030,'USA'),('E00034','Kimberley','Mccann','1981-12-13','F','314 Glen Eagles Dr. ','Palmdale',93550,'USA'),('E00035','Hussain','Terry','1984-09-15','M','714 Rose Ave. ','Los Angeles',90006,'USA'),('E00036','Shane','Thompson','1985-12-15','M','572 Indian Summer St. ','Riverside',92503,'USA'),('E00037','Jackson','Silva','2002-10-30','M','22 Andover Ave. ','San Francisco',94109,'USA'),('E00038','Shaun','Wyatt','1985-01-01','M','7995 W. Tower Drive ','San Jose',95116,'USA'),('E00039','Esther','Mendoza','1998-10-19','F','167 Selby Ave. ','Tulare',93274,'USA'),('E00040','Timothy','Kramer','1990-03-22','M','40 Brewery St. ','Corona',92882,'USA'),('E00041','Burce','Watts','1996-07-06','M','578 Gates Street ','Pacoima',91331,'USA'),('E00042','Iqrq','Dawson','1992-08-27','F','806 North Lantern Road ','Los Angeles',90001,'USA'),('E00043','Elsie','Valdez','1998-11-18','F','24 Howard St. ','Anaheim',92801,'USA'),('E00044','Abraham','Malone','1998-08-19','M','7928 Broad Drive ','Los Angeles',90034,'USA'),('E00045','Jay','Robbins','1998-05-31','M','9286 Goldfield Rd. ','San Jose',95122,'USA'),('E00046','Cora','Ryan','2002-01-26','F','29 Military Ave. ','Hesperia',92345,'USA'),('E00047','Niamh','Torres','1997-08-25','F','8015 San Pablo Dr. ','Union City',94587,'USA'),('E00048','Jade','Mccarthy','1999-09-17','F','371 Buckingham Street ','Livermore',94550,'USA'),('E00049','Floyd','Stewart','1997-09-03','M','96 Iroquois Ave. ','Vista',92083,'USA'),('E00050','Demi','Richards','1994-08-22','F','20 Amerige Drive ','Wilmington',90744,'USA');
/*!40000 ALTER TABLE `EMPLOYEES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `INVENTORY`
--

DROP TABLE IF EXISTS `INVENTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INVENTORY` (
  `LOT_NO` varchar(10) NOT NULL,
  `IN_DATE` date DEFAULT NULL,
  `OUT_DATE` date DEFAULT NULL,
  PRIMARY KEY (`LOT_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INVENTORY`
--

LOCK TABLES `INVENTORY` WRITE;
/*!40000 ALTER TABLE `INVENTORY` DISABLE KEYS */;
INSERT INTO `INVENTORY` VALUES ('L20003W','2001-03-26','2001-03-26'),('L20009B','2001-03-25','2001-03-25'),('L20013W','2002-03-26','2002-03-26'),('L20019B','2002-03-25','2002-03-25'),('L20023W','2003-03-26','2003-03-26'),('L20029B','2003-03-25','2003-03-25'),('L20033W','2004-03-25','2004-03-25'),('L20039B','2004-03-24','2004-03-24'),('L20043W','2005-03-26','2005-03-26'),('L20049B','2005-03-25','2005-03-25'),('L20053W','2006-03-26','2006-03-26'),('L20059B','2006-03-25','2006-03-25'),('L20063W','2007-03-26','2007-03-26'),('L20069B','2007-03-25','2007-03-25'),('L20073W','2008-03-25','2008-03-25'),('L20079B','2008-03-24','2008-03-24'),('L20083W','2009-03-26','2009-03-26'),('L20089B','2009-03-25','2009-03-25'),('L20093W','2010-03-26','2010-03-26'),('L20099B','2010-03-25','2010-03-25'),('L20103W','2011-03-26','2011-03-26'),('L20109B','2011-03-25','2011-03-25'),('L20113W','2012-03-25','2012-03-25'),('L20119B','2012-03-24','2012-03-24'),('L20123W','2013-03-26','2013-03-26'),('L20129B','2013-03-25','2013-03-25'),('L20133W','2014-03-26','2014-03-26'),('L20139B','2014-03-25','2014-03-25'),('L20143W','2015-03-26','2015-03-26'),('L20149B','2015-03-25','2015-03-25'),('L20153W','2016-03-25','2016-03-25'),('L20159B','2016-03-24','2016-03-24'),('L20163W','2017-03-26','2017-03-26'),('L20169B','2017-03-25','2017-03-25'),('L20173W','2018-03-26','2018-03-26'),('L20179B','2018-03-25','2018-03-25'),('L20183W','2019-03-26','2019-03-26'),('L20189B','2019-03-25','2019-03-25'),('L20193W','2020-03-25','2020-03-25'),('L20199B','2020-03-24','2020-03-24');
/*!40000 ALTER TABLE `INVENTORY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORDER`
--

DROP TABLE IF EXISTS `ORDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORDER` (
  `ORDER_ID` varchar(7) NOT NULL,
  `ORDER_DATE` date DEFAULT NULL,
  `REQUIRE_DATE` date DEFAULT NULL,
  `SHIP_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORDER`
--

LOCK TABLES `ORDER` WRITE;
/*!40000 ALTER TABLE `ORDER` DISABLE KEYS */;
INSERT INTO `ORDER` VALUES ('OR00001','2001-03-25','2001-04-15','2001-04-01'),('OR00002','2001-03-24','2001-04-14','2001-03-31'),('OR00003','2002-03-25','2002-04-15','2002-04-01'),('OR00004','2002-03-24','2002-04-14','2002-03-31'),('OR00005','2003-03-25','2003-04-15','2003-04-01'),('OR00006','2003-03-24','2003-04-14','2003-03-31'),('OR00007','2004-03-24','2004-04-14','2004-03-31'),('OR00008','2004-03-23','2004-04-13','2004-03-30'),('OR00009','2005-03-25','2005-04-15','2005-04-01'),('OR00010','2005-03-24','2005-04-14','2005-03-31'),('OR00011','2006-03-25','2006-04-15','2006-04-01'),('OR00012','2006-03-24','2006-04-14','2006-03-31'),('OR00013','2007-03-25','2007-04-15','2007-04-01'),('OR00014','2007-03-24','2007-04-14','2007-03-31'),('OR00015','2008-03-24','2008-04-14','2008-03-31'),('OR00016','2008-03-23','2008-04-13','2008-03-30'),('OR00017','2009-03-25','2009-04-15','2009-04-01'),('OR00018','2009-03-24','2009-04-14','2009-03-31'),('OR00019','2010-03-25','2010-04-15','2010-04-01'),('OR00020','2010-03-24','2010-04-14','2010-03-31'),('OR00021','2011-03-25','2011-04-15','2011-04-01'),('OR00022','2011-03-24','2011-04-14','2011-03-31'),('OR00023','2012-03-24','2012-04-14','2012-03-31'),('OR00024','2012-03-23','2012-04-13','2012-03-30'),('OR00025','2013-03-25','2013-04-15','2013-04-01'),('OR00026','2013-03-24','2013-04-14','2013-03-31'),('OR00027','2014-03-25','2014-04-15','2014-04-01'),('OR00028','2014-03-24','2014-04-14','2014-03-31'),('OR00029','2015-03-25','2015-04-15','2015-04-01'),('OR00030','2015-03-24','2015-04-14','2015-03-31'),('OR00031','2016-03-24','2016-04-14','2016-03-31'),('OR00032','2016-03-23','2016-04-13','2016-03-30'),('OR00033','2017-03-25','2017-04-15','2017-04-01'),('OR00034','2017-03-24','2017-04-14','2017-03-31'),('OR00035','2018-03-25','2018-04-15','2018-04-01'),('OR00036','2018-03-24','2018-04-14','2018-03-31'),('OR00037','2019-03-25','2019-04-15','2019-04-01'),('OR00038','2019-03-24','2019-04-14','2019-03-31'),('OR00039','2020-03-24','2020-04-14','2020-03-31'),('OR00040','2020-03-23','2020-04-13','2020-03-30');
/*!40000 ALTER TABLE `ORDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORDER_DETAILS`
--

DROP TABLE IF EXISTS `ORDER_DETAILS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORDER_DETAILS` (
  `ORDER_ID` varchar(7) NOT NULL,
  `PRODUCT_ID` varchar(7) NOT NULL,
  `ORDER_QUANTITY` int DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`PRODUCT_ID`),
  KEY `fk_ORDER_has_PRODUCT_PRODUCT1_idx` (`PRODUCT_ID`),
  KEY `fk_ORDER_has_PRODUCT_ORDER1_idx` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORDER_DETAILS`
--

LOCK TABLES `ORDER_DETAILS` WRITE;
/*!40000 ALTER TABLE `ORDER_DETAILS` DISABLE KEYS */;
INSERT INTO `ORDER_DETAILS` VALUES ('OR00001','W7_750',600),('OR00002','A01_355',600),('OR00003','R16_1.5',600),('OR00004','P01_650',600),('OR00005','W16_1.5',600),('OR00006','A01_650',600),('OR00007','R08_1.5',600),('OR00008','S01_650',600),('OR00009','W20_750',600),('OR00010','S01_650',600),('OR00011','R10_1.5',600),('OR00012','L01_650',600),('OR00013','W17_1.5',600),('OR00014','P01_650',600),('OR00015','W18_1.5',600),('OR00016','L01_355',600),('OR00017','R1_750',600),('OR00018','L01_650',600),('OR00019','W13_750',600),('OR00020','P01_355',600),('OR00021','R18_1.5',600),('OR00022','L01_355',600),('OR00023','R11_750',600),('OR00024','A01_650',600),('OR00025','S3_1.5',600),('OR00026','P01_355',600),('OR00027','R09_1.5',600),('OR00028','S01_355',600),('OR00029','R08_750',600),('OR00030','L01_355',600),('OR00031','R16_1.5',600),('OR00032','S01_355',600),('OR00033','R09_750',600),('OR00034','A01_650',600),('OR00035','W4_750',600),('OR00036','P01_650',600),('OR00037','R1_1.5',600),('OR00038','L01_355',600),('OR00039','R21_750',600),('OR00040','A01_650',600);
/*!40000 ALTER TABLE `ORDER_DETAILS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POSITION`
--

DROP TABLE IF EXISTS `POSITION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POSITION` (
  `POSITION_ID` varchar(10) NOT NULL,
  `POSITION` varchar(50) DEFAULT NULL,
  `DEPT_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`POSITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POSITION`
--

LOCK TABLES `POSITION` WRITE;
/*!40000 ALTER TABLE `POSITION` DISABLE KEYS */;
INSERT INTO `POSITION` VALUES ('A1','Prisident','Prisident'),('B1','Manager','Brewery'),('B2','Brewer','Brewery'),('F1','Accountant','Finance'),('L1','Technican','Lab'),('S1','Manager','Sales & Marketing'),('S2','Senior Sales','Sales & Marketing'),('S3','Sales','Sales & Marketing'),('S4','Brand Manager','Sales & Marketing'),('W1','Manager','Winery'),('W2','Assistant Manager','Winery'),('W3','Sommelier','Winery'),('W4','Winemaker','Winery'),('W5','Cellar Worker','Winery'),('W6','Grounds Supervisor','Winery'),('W7','Harvest Intern','Winery');
/*!40000 ALTER TABLE `POSITION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROCESS`
--

DROP TABLE IF EXISTS `PROCESS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROCESS` (
  `PROCESS_ID` varchar(2) NOT NULL,
  `DESCRIPTION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PROCESS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROCESS`
--

LOCK TABLES `PROCESS` WRITE;
/*!40000 ALTER TABLE `PROCESS` DISABLE KEYS */;
INSERT INTO `PROCESS` VALUES ('B1','Milling'),('B2','Mashing'),('B3','Boiling'),('B4','Fermentation'),('B5','Racking'),('B6','Inventory'),('W1','Harvesting'),('W2','Crushing'),('W3','Pressing'),('W4','Fermentation'),('W5','Clarification'),('W6','Aging'),('W7','Bottling'),('W8','Inventory');
/*!40000 ALTER TABLE `PROCESS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUCT`
--

DROP TABLE IF EXISTS `PRODUCT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCT` (
  `PRODUCT_ID` varchar(7) NOT NULL,
  `PRODUCT_NAME` varchar(45) DEFAULT NULL,
  `PRODUCT_TYPE` varchar(10) DEFAULT NULL,
  `NET_CONTENT` decimal(3,2) DEFAULT NULL,
  `ABV` decimal(3,1) DEFAULT NULL,
  `PRICE` decimal(3,1) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT`
--

LOCK TABLES `PRODUCT` WRITE;
/*!40000 ALTER TABLE `PRODUCT` DISABLE KEYS */;
INSERT INTO `PRODUCT` VALUES ('A01_355','Wheat, Barley','Ale',0.36,4.5,1.3),('A01_650','Wheat, Barley','Ale',0.65,5.4,1.0),('L01_355','Wheat, Barley','Large',0.36,4.8,1.0),('L01_650','Wheat, Barley','Large',0.65,5.9,1.1),('P01_355','Wheat, Barley','Pale Ale',0.36,4.5,0.9),('P01_650','Wheat, Barley','Pale Ale',0.65,5.9,1.8),('R01_1.5','Cabernet Sauvignon','RED',1.50,12.2,22.8),('R01_750','Cabernet Sauvignon','RED',0.75,12.4,19.3),('R02_1.5','Pinor Noir','RED',1.50,15.1,23.2),('R02_750','Pinor Noir','RED',0.75,15.0,20.8),('R03_1.5','Merlot','RED',1.50,14.8,23.7),('R03_750','Merlot','RED',0.75,13.8,19.2),('R04_1.5','Syrah/Shiraz','RED',1.50,13.8,18.3),('R04_750','Syrah/Shiraz','RED',0.75,15.0,22.2),('R05_1.5','Malbec','RED',1.50,12.2,24.3),('R05_750','Malbec','RED',0.75,13.3,24.3),('R06_1.5','Grenache','RED',1.50,13.5,21.8),('R06_750','Grenache','RED',0.75,14.1,22.7),('R07_1.5','Sangiovese','RED',1.50,12.0,23.8),('R07_750','Sangiovese','RED',0.75,11.2,24.6),('R08_1.5','Tempranilo','RED',1.50,11.8,24.4),('R08_750','Tempranilo','RED',0.75,12.2,19.5),('R09_1.5','Montepulciano','RED',1.50,15.5,18.8),('R09_750','Montepulciano','RED',0.75,14.4,19.4),('R10_1.5','Barbera','RED',1.50,12.3,19.4),('R10_750','Barbera','RED',0.75,12.9,20.3),('R11_1.5','Petite Sirah/Durif','RED',1.50,13.2,20.4),('R11_750','Petite Sirah/Durif','RED',0.75,14.5,22.2),('R12_1.5','Nebbiolo','RED',1.50,14.0,18.1),('R12_750','Nebbiolo','RED',0.75,12.7,23.4),('R13_1.5','Gamay','RED',1.50,13.6,18.7),('R13_750','Gamay','RED',0.75,15.2,22.0),('R14_1.5','Carmenere','RED',1.50,15.4,19.9),('R14_750','Carmenere','RED',0.75,13.1,18.7),('R15_1.5','Petit Verdot','RED',1.50,13.7,18.2),('R15_750','Petit Verdot','RED',0.75,14.9,18.1),('R16_1.5','Blaufrankisch','RED',1.50,13.5,20.6),('R16_750','Blaufrankisch','RED',0.75,12.6,23.0),('R17_1.5','Touriga Nacional','RED',1.50,14.2,18.8),('R17_750','Touriga Nacional','RED',0.75,13.7,18.2),('R18_1.5','Nero d\'Avola','RED',1.50,12.8,24.5),('R18_750','Nero d\'Avola','RED',0.75,12.7,22.2),('R19_1.5','Cinsault','RED',1.50,16.0,24.6),('R19_750','Cinsault','RED',0.75,11.6,22.6),('R1_1.5','Pinor Noir','ROSE',1.50,13.9,19.6),('R1_750','Pinor Noir','ROSE',0.75,13.6,18.5),('R20_1.5','Mourvedre','RED',1.50,12.9,22.1),('R20_750','Mourvedre','RED',0.75,11.8,22.3),('R21_1.5','Pinot Meunier','RED',1.50,14.6,22.5),('R21_750','Pinot Meunier','RED',0.75,14.6,19.1),('R22_1.5','Pinot Precoce','RED',1.50,11.4,21.5),('R22_750','Pinot Precoce','RED',0.75,15.2,22.2),('R2_1.5','Sauvignon Blanc','ROSE',1.50,11.0,20.0),('R2_750','Sauvignon Blanc','ROSE',0.75,13.9,24.7),('R3_1.5','Riesling','ROSE',1.50,12.0,19.2),('R3_750','Riesling','ROSE',0.75,15.2,23.4),('S01_355','Wheat, Barley','Stout',0.36,4.6,1.6),('S01_650','Wheat, Barley','Stout',0.65,5.2,1.3),('S1_1.5','Pinor Noir','SPARKLING',1.50,14.5,19.7),('S1_750','Pinor Noir','SPARKLING',0.75,12.4,24.2),('S2_1.5','Pinot Meunier','SPARKLING',1.50,12.9,22.1),('S2_750','Pinot Meunier','SPARKLING',0.75,15.2,22.7),('S3_1.5','Pinot Precoce','SPARKLING',1.50,11.8,19.9),('S3_750','Pinot Precoce','SPARKLING',0.75,14.6,25.0),('W10_1.5','Torrontes','WHITE',1.50,13.3,19.3),('W10_750','Torrontes','WHITE',0.75,14.7,24.1),('W11_1.5','Muller-Thurgau','WHITE',1.50,11.6,19.7),('W11_750','Muller-Thurgau','WHITE',0.75,11.2,21.9),('W12_1.5','Silvaner','WHITE',1.50,15.7,22.5),('W12_750','Silvaner','WHITE',0.75,11.4,20.4),('W13_1.5','Pinot Blanc','WHITE',1.50,11.0,20.8),('W13_750','Pinot Blanc','WHITE',0.75,12.3,23.8),('W14_1.5','Muscat','WHITE',1.50,13.1,23.9),('W14_750','Muscat','WHITE',0.75,13.8,22.0),('W15_1.5','Airen','WHITE',1.50,11.0,19.2),('W15_750','Airen','WHITE',0.75,13.5,21.6),('W16_1.5','Roussanne','WHITE',1.50,12.4,21.8),('W16_750','Roussanne','WHITE',0.75,11.6,22.5),('W17_1.5','Garanega','WHITE',1.50,12.9,19.0),('W17_750','Garanega','WHITE',0.75,15.6,21.7),('W18_1.5','Verdicchio','WHITE',1.50,13.0,24.1),('W18_750','Verdicchio','WHITE',0.75,11.8,21.0),('W19_1.5','Marsanne','WHITE',1.50,14.6,24.2),('W19_750','Marsanne','WHITE',0.75,15.5,21.9),('W1_1.5','Chardonnay','WHITE',1.50,15.8,20.7),('W1_750','Chardonnay','WHITE',0.75,13.5,23.5),('W20_1.5','Albarino','WHITE',1.50,13.0,21.3),('W20_750','Albarino','WHITE',0.75,15.5,20.5),('W21_1.5','Pinor Noir','WHITE',1.50,12.1,22.9),('W21_750','Pinor Noir','WHITE',0.75,13.7,23.5),('W2_1.5','Sauvignon Blanc','WHITE',1.50,14.3,23.8),('W2_750','Sauvignon Blanc','WHITE',0.75,16.0,18.5),('W3_1.5','Riesling','WHITE',1.50,15.7,21.1),('W3_750','Riesling','WHITE',0.75,14.2,22.4),('W4_1.5','Pinot Fris','WHITE',1.50,12.8,22.6),('W4_750','Pinot Fris','WHITE',0.75,15.5,19.1),('W5_1.5','Semillon','WHITE',1.50,15.2,23.1),('W5_750','Semillon','WHITE',0.75,13.6,18.5),('W6_1.5','Gewurztraminer','WHITE',1.50,12.0,23.0),('W6_750','Gewurztraminer','WHITE',0.75,13.4,20.4),('W7_1.5','Viognier','WHITE',1.50,15.2,20.4),('W7_750','Viognier','WHITE',0.75,14.9,21.0),('W8_1.5','Chenin Blanc','WHITE',1.50,15.1,18.1),('W8_750','Chenin Blanc','WHITE',0.75,13.6,19.8),('W9_1.5','Gruner Veltliner','WHITE',1.50,11.7,23.7),('W9_750','Gruner Veltliner','WHITE',0.75,12.9,20.3);
/*!40000 ALTER TABLE `PRODUCT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUCT_PROCESS`
--

DROP TABLE IF EXISTS `PRODUCT_PROCESS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCT_PROCESS` (
  `LOT_NO` varchar(10) NOT NULL,
  `PRODUCT_ID` varchar(7) DEFAULT NULL,
  `PROCESS_ID` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`LOT_NO`),
  KEY `fk_PRODUCT_PROCESS_PROCESS1_idx` (`PROCESS_ID`),
  KEY `fk_PRODUCT_PROCESS_PRODUCT1_idx` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT_PROCESS`
--

LOCK TABLES `PRODUCT_PROCESS` WRITE;
/*!40000 ALTER TABLE `PRODUCT_PROCESS` DISABLE KEYS */;
INSERT INTO `PRODUCT_PROCESS` VALUES ('L20003W','W7_750','W8'),('L20009B','A01_355','W8'),('L20013W','R16_1.5','W8'),('L20019B','P01_650','W8'),('L20023W','W16_1.5','W8'),('L20029B','A01_650','W8'),('L20033W','R08_1.5','W8'),('L20039B','S01_650','W8'),('L20043W','W20_750','W8'),('L20049B','S01_650','W8'),('L20053W','R10_1.5','W8'),('L20059B','L01_650','W8'),('L20063W','W17_1.5','W8'),('L20069B','P01_650','W8'),('L20073W','W18_1.5','W8'),('L20079B','L01_355','W8'),('L20083W','R1_750','W8'),('L20089B','L01_650','W8'),('L20093W','W13_750','W8'),('L20099B','P01_355','W8'),('L20103W','R18_1.5','W8'),('L20109B','L01_355','W8'),('L20113W','R11_750','W8'),('L20119B','A01_650','W8'),('L20123W','S3_1.5','W8'),('L20129B','P01_355','W8'),('L20133W','R09_1.5','W8'),('L20139B','S01_355','W8'),('L20143W','R08_750','W8'),('L20149B','L01_355','W8'),('L20153W','R16_1.5','W8'),('L20159B','S01_355','W8'),('L20163W','R09_750','W8'),('L20169B','A01_650','W8'),('L20173W','W4_750','W8'),('L20179B','P01_650','W8'),('L20183W','R1_1.5','W8'),('L20189B','L01_355','W8'),('L20193W','R21_750','W8'),('L20199B','A01_650','W8'),('L20203W','R14_750','W6'),('L20209B','P01_650','B5'),('L20213W','R10_1.5','W1');
/*!40000 ALTER TABLE `PRODUCT_PROCESS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SALES`
--

DROP TABLE IF EXISTS `SALES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SALES` (
  `EMP_ID` varchar(30) NOT NULL,
  `ORDER_ID` varchar(7) NOT NULL,
  `CUS_ID` varchar(6) NOT NULL,
  `PRICE` int DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`,`CUS_ID`,`ORDER_ID`),
  KEY `fk_CUSTOMER_has_ORDER_ORDER1_idx` (`ORDER_ID`),
  KEY `fk_CUSTOMER_has_ORDER_EMPLOYEES1_idx` (`EMP_ID`),
  KEY `fk_SALES_CUSTOMER1_idx` (`CUS_ID`),
  CONSTRAINT `fk_CUSTOMER_has_ORDER_ORDER1` FOREIGN KEY (`ORDER_ID`) REFERENCES `ORDER` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SALES`
--

LOCK TABLES `SALES` WRITE;
/*!40000 ALTER TABLE `SALES` DISABLE KEYS */;
INSERT INTO `SALES` VALUES ('E00015','OR00001','C00001',12624),('E00015','OR00006','C00001',588),('E00015','OR00002','C00002',792),('E00015','OR00003','C00003',12384),('E00015','OR00005','C00012',13080),('E00015','OR00004','C00016',1074),('E00015','OR00007','C00023',14652),('E00015','OR00020','C00030',546),('E00016','OR00013','C00007',11388),('E00016','OR00012','C00014',654),('E00016','OR00008','C00015',792),('E00016','OR00016','C00027',600),('E00017','OR00021','C00002',14670),('E00017','OR00018','C00010',654),('E00017','OR00009','C00011',12276),('E00017','OR00015','C00018',14472),('E00017','OR00011','C00020',11616),('E00018','OR00022','C00005',600),('E00018','OR00010','C00025',792),('E00019','OR00014','C00006',1074),('E00019','OR00019','C00008',14292),('E00019','OR00023','C00021',13302),('E00032','OR00038','C00007',600),('E00032','OR00024','C00013',588),('E00032','OR00032','C00019',942),('E00032','OR00017','C00026',11082),('E00033','OR00033','C00009',11646),('E00033','OR00031','C00024',12384),('E00033','OR00029','C00028',11700),('E00034','OR00027','C00004',11286),('E00034','OR00034','C00026',588),('E00034','OR00039','C00028',11430),('E00036','OR00037','C00001',11766),('E00036','OR00028','C00029',942),('E00039','OR00036','C00013',1074),('E00039','OR00040','C00020',588),('E00039','OR00030','C00022',600),('E00040','OR00026','C00003',546),('E00040','OR00025','C00017',11958),('E00040','OR00035','C00019',11466);
/*!40000 ALTER TABLE `SALES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WORK_PERIOD`
--

DROP TABLE IF EXISTS `WORK_PERIOD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WORK_PERIOD` (
  `EMP_ID` varchar(30) NOT NULL,
  `HIRE_DATE` date DEFAULT NULL,
  `LAST_WORKING_DATE` date DEFAULT NULL,
  PRIMARY KEY (`EMP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WORK_PERIOD`
--

LOCK TABLES `WORK_PERIOD` WRITE;
/*!40000 ALTER TABLE `WORK_PERIOD` DISABLE KEYS */;
INSERT INTO `WORK_PERIOD` VALUES ('E00001','2000-03-05','9999-12-31'),('E00002','2000-03-13','2009-05-01'),('E00003','2000-05-23','2012-02-24'),('E00004','2000-07-23','2013-01-22'),('E00005','2000-09-28','2015-07-17'),('E00006','2000-10-05','2015-08-26'),('E00007','2001-07-05','9999-12-31'),('E00008','2001-11-09','9999-12-31'),('E00009','2001-12-21','2013-04-20'),('E00010','2002-05-01','9999-12-31'),('E00011','2002-08-05','2013-02-27'),('E00012','2002-12-22','9999-12-31'),('E00013','2003-08-05','2013-07-23'),('E00014','2003-09-18','9999-12-31'),('E00015','2003-10-26','2009-01-02'),('E00016','2003-11-20','2010-08-07'),('E00017','2004-01-12','2011-04-19'),('E00018','2004-06-02','2011-05-22'),('E00019','2004-10-12','2012-12-19'),('E00020','2005-01-29','2013-02-24'),('E00021','2005-10-12','9999-12-31'),('E00022','2007-02-13','2014-03-09'),('E00023','2007-05-09','9999-12-31'),('E00024','2007-07-15','9999-12-31'),('E00025','2007-11-19','9999-12-31'),('E00026','2008-01-15','2012-05-03'),('E00027','2008-02-13','9999-12-31'),('E00028','2009-03-17','2011-07-02'),('E00029','2009-03-28','2011-06-30'),('E00030','2009-04-03','2013-10-03'),('E00031','2010-07-24','2012-06-16'),('E00032','2008-12-19','9999-12-31'),('E00033','2011-04-05','9999-12-31'),('E00034','2011-05-08','9999-12-31'),('E00035','2011-06-16','9999-12-31'),('E00036','2011-06-18','9999-12-31'),('E00037','2012-02-10','9999-12-31'),('E00038','2012-04-19','9999-12-31'),('E00039','2012-06-02','9999-12-31'),('E00040','2012-12-05','9999-12-31'),('E00041','2013-01-08','9999-12-31'),('E00042','2013-02-10','9999-12-31'),('E00043','2013-02-13','9999-12-31'),('E00044','2013-04-06','9999-12-31'),('E00045','2013-07-09','9999-12-31'),('E00046','2013-09-19','9999-12-31'),('E00047','2014-02-23','9999-12-31'),('E00048','2009-04-17','9999-12-31'),('E00049','2015-07-03','9999-12-31'),('E00050','2015-08-12','9999-12-31');
/*!40000 ALTER TABLE `WORK_PERIOD` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-15  0:00:46
