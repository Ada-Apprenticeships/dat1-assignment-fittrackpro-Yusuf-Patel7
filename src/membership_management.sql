-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT 
    m.member_id,                
    m.first_name,                
    m.last_name,                 
    m.membership_type,            
    m.join_date                  
FROM 
    members m 
JOIN 
    memberships me ON m.member_id = me.member_id  
WHERE 
    me.status = 'Active';        


-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
SELECT 
    m.type,                        
    AVG(JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 24 AS avg_hours  -- Calculate average visit duration in hours
FROM 
    memberships m 
JOIN 
    attendance a ON m.member_id = a.member_id  
GROUP BY 
    m.type;                      


-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
SELECT 
    m.member_id,                 
    m.first_name,
    m.last_name,            
    m.email,                     
    me.end_date                   
FROM 
    members m 
JOIN 
    memberships me ON m.member_id = me.member_id 
WHERE 
    me.end_date BETWEEN DATE('now') AND DATE('now', '+1 year');  -- Filter for memberships expiring within this year