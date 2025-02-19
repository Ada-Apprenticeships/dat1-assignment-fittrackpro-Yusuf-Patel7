-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT 
    c.class_id,                               
    c.name AS class_name,                        
    s.first_name || ' ' || s.last_name AS instructor_name  -- Combine first and last name for instructor
FROM 
    classes c 
JOIN 
    class_schedule cs ON c.class_id = cs.class_id    
JOIN 
    staff s ON cs.staff_id = s.staff_id;         


-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT
    c.class_id,                                      
    c.name AS class_name,                           
    cs.start_time,                                  
    cs.end_time,                                    
    (c.capacity - COUNT(ca.member_id)) AS available_spots  -- Calculate available slots based on capacity and registrations
FROM 
    classes c 
JOIN 
    class_schedule cs ON c.class_id = cs.class_id    
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id 
WHERE 
    DATE(cs.start_time) = '2025-02-01'                
GROUP BY 
    c.class_id, cs.start_time, cs.end_time;       


-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (
    (SELECT schedule_id                           
     FROM class_schedule 
     WHERE class_id = 3                            
       AND DATE(start_time) = '2025-02-01'),       
    11,                                             
    'Registered'                                   
);            


-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance 
WHERE 
    schedule_id = 7        
    AND member_id = 2;        


-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes
SELECT 
    c.class_id,                                  
    c.name AS class_name,                           
    COUNT(ca.schedule_id) AS total_registrations     
FROM 
    classes c 
JOIN 
    class_attendance ca ON c.class_id = (
        SELECT class_id 
        FROM class_schedule 
        WHERE schedule_id = ca.schedule_id
    )
GROUP BY 
    c.class_id                                     
ORDER BY 
    total_registrations DESC                          
LIMIT 3;                                           


-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT 
    ROUND(AVG(class_count)) AS avg_classes_per_member
FROM (
    SELECT 
        member_id,
        COUNT(schedule_id) AS class_count         
    FROM 
        class_attendance 
    GROUP BY 
        member_id                                    
) AS subquery;                                     