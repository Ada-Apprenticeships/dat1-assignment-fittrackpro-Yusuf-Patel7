-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Create your tables here

-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- 1. locations 
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    opening_hours VARCHAR(20) NOT NULL
);
-- 2. members
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    date_of_birth VARCHAR(20) NOT NULL,
    join_date VARCHAR(20) NOT NULL,
    emergency_contact_name VARCHAR(50) NOT NULL,
    emergency_contact_phone VARCHAR(20) NOT NULL 
);
-- 3. staff
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    position VARCHAR(20) NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date VARCHAR(20) NOT NULL,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON UPDATE CASCADE
    ON DELETE SET NULL
);
-- 4. equipment
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date VARCHAR(20) NOT NULL,
    last_maintenance_date VARCHAR(20) NOT NULL CHECK(last_maintenance_date >= purchase_date),
    next_maintenance_date VARCHAR(20) NOT NULL CHECK(next_maintenance_date >= last_maintenance_date),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);


-- 5. classes
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    capacity INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);
-- 6. class_schedule
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER,
    staff_id INTEGER,
    start_time VARCHAR(20) NOT NULL,
    end_time VARCHAR(20) NOT NULL CHECK(end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- 7. memberships
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    type VARCHAR(7) NOT NULL CHECK (type IN ('Basic', 'Premium')),
    start_date VARCHAR(20) NOT NULL,
    end_date VARCHAR(20) NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);
-- 8. attendance
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time VARCHAR(20) NOT NULL,
    check_out_time VARCHAR(20) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);
-- 9. class_attendance
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR(10) NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- 10. payments
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    amount REAL NOT NULL CHECK(amount > 0),
    payment_date VARCHAR(20) NOT NULL,
    payment_method VARCHAR(15) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal','Cash')),
    payment_type VARCHAR(25) NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE SET NULL
);
-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    staff_id INTEGER,
    session_date VARCHAR(10) NOT NULL,
    start_time VARCHAR(10) NOT NULL,
    end_time VARCHAR(10) NOT NULL,
    notes VARCHAR(255),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);
-- 12. member_health_metrics
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    measurement_date VARCHAR(10) NOT NULL,
    weight REAL NOT NULL,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);
-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date VARCHAR(10) NOT NULL,
    description VARCHAR(255) NOT NULL,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal

-- Make sure to delete existing database first otherwise setup will cause an error
--schema.sql 
--.read scripts/sample_data.sql