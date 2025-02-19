-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (7, 1, CURRENT_TIMESTAMP);

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT 
    DATE(check_in_time) AS visit_date,  -- Extract visit date from check-in time
    check_in_time,                       -- Include check-in time
    check_out_time                       -- Include check-out time
FROM 
    attendance 
WHERE 
    member_id = 5;                      -- Filter by member ID 5

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT 
    DAYOFWEEK(check_in_time) AS day_of_week,  -- Get the day of the week from check-in time
    COUNT(*) AS visit_count                     -- Count the number of visits for each day
FROM 
    attendance 
GROUP BY 
    DAYOFWEEK(check_in_time)                    -- Group by the day of the week
ORDER BY 
    visit_count DESC                             -- Order results by visit count in descending order
LIMIT 1;                                       -- Limit to the top result (busiest day)

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
SELECT 
    l.name AS location_name,                           -- Select location name
    AVG(daily.visit_count) AS avg_daily_attendance    -- Calculate average daily attendance
FROM 
    locations l                                       -- From locations table
JOIN 
    (SELECT 
         location_id,                                  -- Select location ID
         DATE(check_in_time) AS visit_date,           -- Extract visit date from check-in time
         COUNT(*) AS visit_count                       -- Count visits for each location on each date
     FROM 
         attendance 
     GROUP BY 
         location_id,                                  -- Group by location ID
         DATE(check_in_time)) daily                    -- Group by visit date as well
ON 
    l.location_id = daily.location_id                -- Join the subquery on location ID
GROUP BY 
    l.location_id;                                   -- Group final results by location ID