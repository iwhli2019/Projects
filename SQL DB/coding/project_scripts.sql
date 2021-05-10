## Data loading scripts
# Pain point 1 - Product consult (Create Procedure)
call product_consult("L01_355");
call product_consult("R18_1.5");
call product_consult("A01_650");

# Pain point 2 - Most popular product per type
SELECT COUNT(OD.PRODUCT_ID), P.PRODUCT_NAME, P.PRODUCT_TYPE
FROM ORDER_DETAILS AS OD, PRODUCT AS P
WHERE OD.PRODUCT_ID = P.PRODUCT_ID
GROUP BY P.PRODUCT_TYPE, P.PRODUCT_NAME
ORDER BY COUNT(OD.PRODUCT_ID) DESC;

# Pain point 2 - The amount of order per country
SELECT SUM(S.PRICE) AS "Sales number", C.COUNTRY
FROM SALES AS S, CUSTOMER AS C
WHERE S.CUS_ID = C.CUS_ID
GROUP BY C.COUNTRY
ORDER BY SUM(S.PRICE)DESC;

# Pain point 3 - COMMISSION (Create procedure)
call commission_calculation(2011,0.01);
call commission_calculation(2013,0.05);
call commission_calculation(2015,0.10);

# Pain point 4 - TAX (Created procedure)
call tax_calculation(2011,0.01);
call tax_calculation(2013,0.05);
call tax_calculation(2015,0.10);

# Pain point 5 - Productst that did not sold
SELECT P.PRODUCT_ID, P.PRODUCT_NAME
FROM PRODUCT AS P 
WHERE P.PRODUCT_ID NOT IN (SELECT DISTINCT OD.PRODUCT_ID FROM ORDER_DETAILS AS OD);

# pain point 6 - promoted opportunities
SELECT DISTINCT E.EMP_ID, P.DEPT_NAME, CONCAT_WS(', ', E.LAST_NAME,E.FIRST_NAME) AS "FULL NAME", E.BDAY
FROM EMPLOYEES AS E, EMP_POSITION AS EP, POSITION AS P
WHERE E.EMP_ID = EP.EMP_ID
AND P.POSITION_ID = EP.POSITION_ID
AND E.BDAY IN (SELECT MAX(BDAY)
FROM EMPLOYEES AS E, EMP_POSITION AS EP, POSITION AS P
WHERE E.EMP_ID = EP.EMP_ID
AND P.POSITION_ID = EP.POSITION_ID
AND EP.POSITION_END_DATE > CURDATE()
GROUP BY P.DEPT_NAME);

# Pain Point 7 -  Correct mispelling in country list in customer table (Create procedure)
call spelling_correction("Maxico","Mexico");
call spelling_correction("Timor_Leste","Timor Leste");
call spelling_correction("USS","USA");