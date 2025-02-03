-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

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
    location_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    opening_hours TEXT
);
-- 2. members
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    date_of_birth DATE,
    join_date DATE NOT NULL,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20)
);
-- 3. staff
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    position VARCHAR(20) NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist')),
    hire_date DATE NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 4. equipment
CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);


-- 5. classes
CREATE TABLE classes (
    class_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    capacity INT NOT NULL CHECK (capacity > 0),
    duration INTERVAL NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 6. class_schedule
CREATE TABLE class_schedule (
    schedule_id SERIAL PRIMARY KEY,
    class_id INT NOT NULL,
    date DATE NOT NULL,
    staff_id INT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- 7. memberships
CREATE TABLE membership (
    membership_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 8. attendance
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    location_id INT NOT NULL,
    check_in_time TIMESTAMP NOT NULL,
    check_out_time TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 9. class_attendance
CREATE TABLE class_attendance (
    class_attendance_id SERIAL PRIMARY KEY,
    schedule_id INT NOT NULL,
    member_id INT NOT NULL,
    attendance_status VARCHAR(20) NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 10. payments
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal')),
    payment_type VARCHAR(30) NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
    session_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    staff_id INT NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- 12. member_health_metrics
CREATE TABLE member_health_metrics (
    metric_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    measurement_date DATE NOT NULL,
    weight DECIMAL(5,2),
    body_fat_percentage DECIMAL(5,2),
    muscle_mass DECIMAL(5,2),
    bmi DECIMAL(5,2),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
    log_id SERIAL PRIMARY KEY,
    equipment_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    staff_id INT NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal