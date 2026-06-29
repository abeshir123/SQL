-- view 1
-- view to count jeep wranglers by county
CREATE VIEW jeep_county AS
SELECT l.county AS Location_County, 
       CONCAT(vm.make, ' ', vm.model) AS Vehicle_Model,
       COUNT(v.DOL_vehicle_id) AS Total_Jeep_Wranglers
FROM vehicles v
JOIN vehicle_models vm ON v.model_id = vm.model_id
JOIN locations l ON v.location_id = l.location_id
WHERE vm.make = 'JEEP' AND vm.model = 'WRANGLER'
GROUP BY l.county, vm.make, vm.model;

SELECT * FROM jeep_county;

-- view two
-- calculating the average electric range by legislative district
CREATE VIEW avg_electric_range AS
SELECT l.legislative_district AS Legislative_District, 
       AVG(vce.electric_range) AS Average_Electric_Range
FROM vehicle_CAFV_eligibility vce
JOIN vehicles v ON v.cafv_eligibility_id = vce.cafv_eligibility_id
JOIN locations l ON v.location_id = l.location_id
WHERE vce.electric_range > 0 
GROUP BY l.legislative_district;

SELECT * FROM avg_electric_range;

-- view 3
-- This view counts how many people use Puget electric vehicle companies in a specific legislative district
CREATE VIEW puget_users AS
SELECT l.legislative_district AS Legislative_District, 
       COUNT(vul.DOL_vehicle_id) AS Total_Users
FROM vehicle_utilities_link vul
JOIN utilities u ON vul.utility_id = u.utility_id
JOIN vehicles v ON vul.DOL_vehicle_id = v.DOL_vehicle_id
JOIN locations l ON v.location_id = l.location_id
WHERE u.electric_utility IN ('PUGET SOUND ENERGY INC', 'CITY OF TACOMA - (WA)')
GROUP BY l.legislative_district;

SELECT * FROM puget_users;

-- view 4
-- This view counts the total number of vehicles in counties that have more than 2 vehicles
CREATE VIEW county_vehicle_count AS
SELECT l.county AS Location_County, 
       COUNT(v.DOL_vehicle_id) AS Total_Vehicles
FROM vehicles v
JOIN locations l ON v.location_id = l.location_id
WHERE l.county IN (
    SELECT l2.county
    FROM vehicles v2
    JOIN locations l2 ON v2.location_id = l2.location_id
    GROUP BY l2.county
    HAVING COUNT(v2.DOL_vehicle_id) > 2
)
GROUP BY l.county;

SELECT * FROM county_vehicle_count;

-- view 5
-- A query showing the number of vehicles across different cities in King county specifically
CREATE VIEW king_vehicle_count AS
SELECT l.city, l.county, vm.make,
COUNT(v.DOL_vehicle_id) as number_of_vehicles
FROM locations l
JOIN vehicles v ON l.location_id = v.location_id
JOIN vehicle_models vm ON v.model_id = vm.model_id
WHERE l.county = 'King'
GROUP BY l.city, l.county, vm.make
ORDER BY l.city;

SELECT * FROM king_vehicle_count;








