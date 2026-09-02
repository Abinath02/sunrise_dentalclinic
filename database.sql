-- Database: sunrise_dental_db
CREATE DATABASE IF NOT EXISTS sunrise_dental_db;
USE sunrise_dental_db;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'DOCTOR', 'CASHIER', 'PATIENT') NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

-- Table: appointments
CREATE TABLE IF NOT EXISTS appointments (
    appointment_number VARCHAR(20) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_number VARCHAR(15),
    email VARCHAR(100),
    dentist_name VARCHAR(100),
    treatment_type VARCHAR(100),
    appointment_date DATE,
    appointment_time TIME,
    consultation_fee DOUBLE DEFAULT 1000.0,
    treatment_cost DOUBLE DEFAULT 0.0,
    status ENUM('PENDING', 'TREATED', 'PAID', 'CANCELLED') DEFAULT 'PENDING'
);

-- Table: bills
CREATE TABLE IF NOT EXISTS bills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_number VARCHAR(20),
    patient_name VARCHAR(100),
    total_amount DOUBLE,
    bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_number) REFERENCES appointments(appointment_number)
);

-- Insert Default Admin (Password is 'admin123' hashed - normally you'd use PasswordUtil to generate this)
-- Note: Replace the hashed password with the result from your PasswordUtil if it differs.
-- For this example, I'll insert a plain text one or leave it to the user to register.
INSERT INTO users (username, password, role, full_name) VALUES ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'ADMIN', 'System Administrator');
