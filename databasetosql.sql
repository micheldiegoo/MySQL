-- Creating Views

use db_company;

CREATE OR REPLACE VIEW leevingl AS 
SELECT Property, Company, `Current Price`, `Type Room`, `Group Room`, `Vacancy Status`
FROM db_company_21052024
WHERE Property <> 'Erin' and Landlord in ('BeLettings', 'Neil')
and `Vacancy Status` <> 'Blocked';

CREATE OR REPLACE VIEW count_vacancy_status as
SELECT Property, COUNT(`Vacancy Status`) as count_vacancy_status,
count(`Group Room`) as count_beds
from db_company_21052024
WHERE Property <> 'Erin' and Landlord in ('BeLettings', 'Neil')
and `Vacancy Status` <> 'Blocked'
group by Property;

-- Updating Columns names

ALTER TABLE db_company_21052024
RENAME COLUMN `Vacancy Status` TO vacancy_status,
RENAME COLUMN `Group Room` TO group_room,
RENAME column `Current Price` TO current_price,
RENAME column `Vacancy ID` TO vacancy_id,
RENAME column `Type Room` TO type_room,
RENAME column `Property Type` TO property_type,
RENAME column `Property` TO property, 
RENAME column Company TO company, 
RENAME column Landlord TO landlord, 
RENAME column Address TO address, 
RENAME column City TO city,
RENAME column `Room info` TO room_info, 
RENAME column Zone TO zone, 
RENAME column Eircode TO eircode;

-- Creating another View

CREATE OR REPLACE VIEW count_vacancy_status as
SELECT Property, count(vacancy_status) as count_vacancy_status, count(distinct group_room) as count_group_room
FROM db_company_21052024
WHERE Property <> 'Erin' and Landlord in ('BeLettings', 'Neil')
and vacancy_status <> 'Blocked'
group by Property;

-- UPDATING DUPLICATE VALUE

update db_company.db_company_21052024
set group_room = 'Room 1.3'
WHERE vacancy_id = 'AR42B13';

select * from db_company.db_company_21052024;


SELECT Property, group_room
from db_company.db_company_21052024
WHERE group_room not in ('Restaurant', 'School') and group_room is not null;

-- Counting beds (vacancy_id)

select property, count(vacancy_id) as beds_count
from db_company.db_company_21052024
where 
group_room NOT IN ('Restaurant', 'School') 
        AND group_room IS NOT NULL AND
        property <> 'Erin' and landlord in ('BeLettings', 'Neil')
		and vacancy_status <> 'Blocked'
group by property;


-- Creating new column, splitted after dot. Then the result will be concatenated to property column

SELECT 
    property, 
    group_room,
    SUBSTRING_INDEX(group_room, '.', 1) AS new_group_room,
    CONCAT(property, ' ', SUBSTRING_INDEX(group_room, '.', 1)) AS concatenated_column
FROM 
    db_company.db_company_21052024
WHERE 
    group_room NOT IN ('Restaurant', 'School') 
    AND group_room IS NOT NULL;
    
-- Selecting columns to be used

SELECT 
	property, vacancy_id,
	CONCAT(property, ' ', SUBSTRING_INDEX(group_room, '.', 1)) AS concatenated_column
FROM 
	db_company.db_company_21052024
WHERE 
	group_room NOT IN ('Restaurant', 'School') 
	AND group_room IS NOT NULL AND
	property <> 'Erin' and landlord in ('BeLettings', 'Neil')
	and vacancy_status <> 'Blocked';
    
-- Counting Rooms and Beds together

SELECT 
	property,
	COUNT(DISTINCT concatenated_column) AS rooms_count,
	COUNT(vacancy_id) as beds_count
FROM (
    SELECT 
        property, vacancy_id,
        CONCAT(property, ' ', SUBSTRING_INDEX(group_room, '.', 1)) AS concatenated_column
    FROM 
        db_company.db_company_21052024
    WHERE 
        group_room NOT IN ('Restaurant', 'School') 
        AND group_room IS NOT NULL AND
        property <> 'Erin' and landlord in ('BeLettings', 'Neil')
		and vacancy_status <> 'Blocked'
) AS subquery
GROUP BY 
    property;

-- Counting Properties and Vacancies per Zone

SELECT 
	zone, 
    count(distinct property) as count_properties,
	count(vacancy_id) AS count_vacancy
FROM 	
	db_company.db_company_21052024
WHERE 
	group_room NOT IN ('Restaurant', 'School') 
	AND group_room IS NOT NULL AND
	property <> 'Erin' AND landlord IN ('BeLettings', 'Neil')
	AND vacancy_status NOT IN ('Blocked', 'Return')
GROUP BY 
	zone
ORDER BY 
	zone ASC;
    
	-- Subquery
        
SELECT 
	property, landlord
FROM 	
	db_company.db_company_21052024
WHERE property IN
	(SELECT property
    FROM register_properties.register_properties21052024
    WHERE `Methode of Payment` = 'Cash')
ORDER BY landlord;


-- INNER JOIN 

SELECT
    COUNT(DISTINCT c.property) AS countingg,
    r.status
FROM 
	db_company.db_company_21052024 AS c
INNER JOIN 
	register_properties.register_properties21052024 AS r
ON 
	c.property = r.property
GROUP BY 
	r.status;

