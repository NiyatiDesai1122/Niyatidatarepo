--Create Tables
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(10),
    phone_number VARCHAR(15),
    address VARCHAR(255)
);
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialty VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(255)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    appointment_time TIME
);

CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    diagnosis VARCHAR(255),
    prescription VARCHAR(255),
    visit_date DATE
);
CREATE TABLE medications (
    medication_id INT PRIMARY KEY,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    side_effects VARCHAR(255),
    manufacturer VARCHAR(100)
);


-- Insert Data
INSERT INTO patients (patient_id, patient_name, date_of_birth, gender, phone_number, address)
VALUES
    (1, 'John Smith', '1980-05-15', 'Male', '123-456-7890', '123 Main St'),
    (2, 'Emily Johnson', '1975-09-22', 'Female', '456-789-0123', '456 Elm St'),
    (3, 'Michael Brown', '1990-02-10', 'Male', '789-012-3456', '789 Oak St'),
    (4, 'Sarah Davis', '1988-11-18', 'Female', '012-345-6789', '987 Pine St'),
    (5, 'James Wilson', '1972-07-30', 'Male', '234-567-8901', '654 Maple St'),
    (6, 'Jessica Lee', '1985-04-25', 'Female', '345-678-9012', '210 Cedar St'),
    (7, 'David Garcia', '1995-09-08', 'Male', '456-789-0123', '543 Birch St');


INSERT INTO doctors (doctor_id, doctor_name, specialty, phone_number, email)
VALUES
    (1, 'Dr. Alex Lee', 'Cardiology', '123-456-7890', 'alexlee@example.com'),
    (2, 'Dr. Jessica Chen', 'Pediatrics', '456-789-0123', 'jessicachen@example.com'),
    (3, 'Dr. David Smith', 'Orthopedics', '789-012-3456', 'davidsmith@example.com'),
    (4, 'Dr. Laura Brown', 'Dermatology', '012-345-6789', 'laurabrown@example.com'),
    (5, 'Dr. Michael Wang', 'Neurology', '234-567-8901', 'michaelwang@example.com'),
    (6, 'Dr. Emily Taylor', 'Psychiatry', '345-678-9012', 'emilytaylor@example.com'),
    (7, 'Dr. Jennifer Clark', 'Oncology', '456-789-0123', 'jenniferclark@example.com');

INSERT INTO appointments (appointment_id, patient_id, doctor_id, appointment_date, appointment_time)
VALUES
    (1, 1, 1, '2023-03-01', '09:00:00'),
    (2, 2, 2, '2023-03-02', '10:00:00'),
    (3, 3, 3, '2023-03-03', '11:00:00'),
    (4, 4, 4, '2023-03-04', '12:00:00'),
    (5, 5, 5, '2023-03-05', '13:00:00'),
    (6, 6, 6, '2023-03-06', '14:00:00'),
    (7, 7, 7, '2023-03-07', '15:00:00');

INSERT INTO medical_records (record_id, patient_id, doctor_id, diagnosis, prescription, visit_date)
VALUES
    (1, 1, 1, 'High Blood Pressure', 'Lisinopril', '2023-03-01'),
    (2, 2, 2, 'Common Cold', 'Rest & Fluids', '2023-03-02'),
    (3, 3, 3, 'Sprained Ankle', 'Ibuprofen', '2023-03-03'),
    (4, 4, 4, 'Acne', 'Benzoyl Peroxide', '2023-03-04'),
    (5, 5, 5, 'Migraine', 'Sumatriptan', '2023-03-05'),
    (6, 6, 6, 'Anxiety Disorder', 'Cognitive Therapy', '2023-03-06'),
    (7, 7, 7, 'Breast Cancer', 'Chemotherapy', '2023-03-07');


INSERT INTO medications (medication_id, medication_name, dosage, side_effects, manufacturer)
VALUES
    (1, 'Lisinopril', '10 mg', 'Dizziness, Cough', 'Pfizer'),
    (2, 'Ibuprofen', '200 mg', 'Upset Stomach, Headache', 'Bayer'),
    (3, 'Benzoyl Peroxide', '5% Cream', 'Skin Dryness, Irritation', 'Johnson & Johnson'),
    (4, 'Sumatriptan', '50 mg', 'Drowsiness, Nausea', 'Novartis'),
    (5, 'Cognitive Therapy', 'N/A', 'N/A', 'N/A'),
    (6, 'Chemotherapy', 'N/A', 'Hair Loss, Nausea', 'Roche'),
    (7, 'Rest & Fluids', 'N/A', 'N/A', 'N/A');


--Query to join patients and appointments tables
SELECT p.*, a.appointment_date, a.appointment_time
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id

--Query to join medical records with patient and doctor information
SELECT m.*, p.patient_name, d.doctor_name
FROM medical_records m
JOIN patients p ON m.patient_id = p.patient_id
JOIN doctors d ON m.doctor_id = d.doctor_id

--Query to calculate the average age of patients
SELECT AVG(DATEDIFF(year, date_of_birth, GETDATE())) AS average_age
FROM patients

--Query to count the number of appointments for each doctor
SELECT d.doctor_name, COUNT(a.appointment_id) AS appointment_count
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name

--Query to rank doctors based on the number of appointments they have
SELECT doctor_name, 
       COUNT(appointment_id) AS appointment_count,
       RANK() OVER (ORDER BY COUNT(appointment_id) DESC) AS doctor_rank
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY doctor_name

--Query to find patients with multiple medical records
SELECT patient_id, COUNT(record_id) AS record_count
FROM medical_records
GROUP BY patient_id
HAVING COUNT(record_id) > 1

--Query to find doctors with the highest and lowest appointment counts
SELECT doctor_name, appointment_count
FROM (
    SELECT d.doctor_name, 
           COUNT(a.appointment_id) AS appointment_count,
           RANK() OVER (ORDER BY COUNT(a.appointment_id) DESC) AS doctor_rank
    FROM doctors d
    LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
    GROUP BY d.doctor_name
) AS ranked_doctors
WHERE doctor_rank = 1 OR doctor_rank = (SELECT COUNT(DISTINCT doctor_id) FROM doctors)



