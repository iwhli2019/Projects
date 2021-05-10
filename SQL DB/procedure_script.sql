DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `commission_calculation`(IN in_order_year INT, IN in_commission_rate DECIMAL(4,3))
BEGIN

SELECT EMP_ID, SUM(PRICE) AS "EMPLOYEE REVENUE", (SUM(PRICE)*in_commission_rate) AS "COMMISSION AMOUNT"
FROM winery_micro_brewery.ORDER AS OD, SALES AS S
WHERE OD.ORDER_ID = S.ORDER_ID
AND YEAR(OD.ORDER_DATE) = in_order_year
GROUP BY S.EMP_ID;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `empty_null`(IN in_tbl_name VARCHAR(50), IN in_col_name VARCHAR(50))
BEGIN

SET @s=CONCAT("UPDATE ",in_tbl_name," SET ",in_col_name," = NULL WHERE ",in_col_name," = ''");
PREPARE stmt from @s;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `product_consult`(IN in_product_id VARCHAR(7))
BEGIN

SELECT DISTINCT P.*, IF(I.OUT_DATE>CURDATE(),"Y","N") AS "Stock Available"
FROM PRODUCT AS P, PRODUCT_PROCESS AS PD, INVENTORY AS I
WHERE P.PRODUCT_ID = PD.PRODUCT_ID
AND PD.LOT_NO = I.LOT_NO
AND P.PRODUCT_ID = in_product_id;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spelling_correction`(IN in_incorrect_spelling VARCHAR(50), IN in_correct_spelling VARCHAR(50))
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE c VARCHAR(100);

DECLARE cur1 CURSOR FOR
	SELECT COUNTRY FROM CUSTOMER;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur1;
read_loop: LOOP
	FETCH cur1 into c;
IF done THEN 
	LEAVE read_loop;
END IF;

IF c = in_incorrect_spelling THEN 
	UPDATE CUSTOMER
	SET COUNTRY = in_correct_spelling
    WHERE COUNTRY = c;
END IF; 

END LOOP;



END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `tax_calculation`(IN in_year INT, IN in_tax_rate DECIMAL(4,3))
BEGIN

SELECT SUM(PRICE) AS "THIS YEAR REVENUE", (SUM(PRICE)*in_tax_rate) AS "TAX AMOUNT"
FROM winery_micro_brewery.ORDER AS OD, SALES AS S
WHERE OD.ORDER_ID = S.ORDER_ID
AND YEAR(OD.SHIP_DATE) = in_year;

END$$
DELIMITER ;

