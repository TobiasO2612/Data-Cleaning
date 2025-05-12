-- 1. creamos base de datos
CREATE database limpieza;

-- 2 Creamos un store procedure.
USE LIMPIEZA;
SELECT*
FROM clean;

DELIMITER //
CREATE PROCEDURE limp()
BEGIN
     SELECT* FROM clean;
     
END//
DELIMITER ;

CALL limp;

-- 3 Renombrar columnas
ALTER TABLE clean CHANGE COLUMN `ï»¿Id?empleado` id_emp varchar(20) null;
ALTER TABLE clean CHANGE COLUMN `gÃ©nero` Gender varchar (20) null;

SET sql_safe_updates=0;

-- 4 Buscar duplicados

SELECT id_emp, count(*) as cantidad_duplicados
from clean
group by id_emp
having count(*) >1;


select count(*) as cantidad_duplicados 
FROM (
SELECT id_emp, count(*) as cantidad_duplicados
from clean
group by id_emp
having count(*) >1

) AS subquery;

-- Renombramos nuestra tabla actual para distinguir que es la que tiene los duplicados
rename table clean to conduplicados;

-- Creamos una tabla temporal solo con los datos unicos de la tabla que tiene los duplicados
CREATE TEMPORARY TABLE temp_limpieza AS 
SELECT DISTINCT * FROM conduplicados;

-- En este paso podemos ver la cantidad de datos de cada tabla y veremos que en la temporal no aparecen los duplicados

SELECT COUNT(*) AS original from conduplicados;
SELECT COUNT(*) AS original from temp_limpieza;

CREATE TABLE clean AS SELECT * FROM temp_limpieza;
call limp();

-- Eliminamos la tabla que contiene los duplicados 
DROP TABLE conduplicados;

-- Cambiamos los valores debidos de cada columna a ingles
ALTER TABLE clean CHANGE COLUMN `apellido` Last_name varchar(50) null;
ALTER TABLE clean CHANGE COLUMN `star_date` Start_Date varchar(50) null;

-- Vemos que el cambio se ha realizado correctamente
DESCRIBE clean;

CALL limp();


SELECT Name FROM clean
WHERE LENGTH(Name) - length (trim(name)) >0;

SELECT Last_name, trim(Last_name) AS Last_name
from clean
WHERE LENGTH(Last_name) - length (trim(Last_name)) >0;

UPDATE clean SET Last_name= TRIM(Last_name) 
WHERE LENGTH(Last_name) - length (trim(Last_name)) >0;

call limp();
SELECT gender,
CASE
    WHEN gender='hombre' THEN 'male'
    WHEN gender='mujer' THEN 'female'
    else 'other'
END AS gender1
FROM limpieza;

UPDATE clean SET gender = CASE
    WHEN gender='hombre' THEN 'male'
    WHEN gender='mujer' THEN 'female'
    else 'other'
END ;

call limp();

DESCRIBE clean;

ALTER TABLE clean MODIFY COLUMN type TEXT;


-- En este caso el numero en type indica la modalidad de trabajo 1=remoto 0=hibrido . Realizamos un case para comprobar que funciona nuestro codigo
SELECT type,
CASE 
    WHEN type=1 THEN 'Remote'
    WHEN type=0 THEN 'Hybrid'
    Else 'other'
END AS ejemplo
FROM clean;

-- Actualizamos nuestra base de datos  utilizando nuestro CASE
UPDATE clean 
SET type= CASE 
    WHEN type=1 THEN 'Remote'
    WHEN type=0 THEN 'Hybrid'
    Else 'other'
END;

call limp();

SELECT salary,
             CAST(trim( REPLACE(REPLACE(salary,'$',''),',','')) AS DECIMAL(15,2)) as salary1 FROM clean;
             
UPDATE clean SET salary =CAST(trim( REPLACE(REPLACE(salary,'$',''),',','')) AS DECIMAL(15,2)) ;

ALTER TABLE clean MODIFY COLUMN salary INT NULL;

DESCRIBE clean;


SELECT birth_date from clean;


ALTER TABLE clean ADD COLUMN tempbirthdate DATE;
UPDATE clean set tempbirthdate= date_format(str_to_date(birth_date,'%m/%d/%Y'),'%Y-%m-%d');
ALTER TABLE clean DROP COLUMN birth_date;
ALTER TABLE clean CHANGE tempbirthdate Birth_Date DATE;
ALTER TABLE clean MODIFY COLUMN Birth_Date DATE AFTER Gender;


ALTER TABLE clean MODIFY COLUMN Start_Date TEXT;
UPDATE clean SET tempstartdate=str_to_date(Start_Date,'%m/%d/%Y');
ALTER TABLE clean DROP COLUMN Start_Date;
ALTER TABLE clean CHANGE tempstartdate Start_Date DATE;
ALTER TABLE clean MODIFY COLUMN Start_Date DATE AFTER area;


call limp() ;
SELECT * FROM clean
ORDER BY area asc;

SELECT*
 from clean
WHERE name IS NULL;

SELECT finish_date from clean;

SELECT finish_date, str_to_date(finish_date,'%Y-%m,%d' '%H:%i:%s') AS fecha from clean;

CALL limp()













	   

	



             
            



















    
