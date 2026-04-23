-- ============================================================
-- Hospital Appointment System 

-- Rachel Gillespie 

-- 20118715 

-- Database Design and Implementation 

-- Databases: MySQL Implementation
-- ============================================================

USE hospital_appointment;

-- Get all appointments for a specific patient, ordered by date. 
SELECT 
    appointmentId,
    appointmentDate,
    appointmentTime,
    status,
    reasonForVisit AS 'Appointment Info'
FROM
    Appointment
WHERE
    patientId = 1
ORDER BY appointmentDate;

-- Get all appointments for a specific patient in a date range, ordered by date. 
SELECT 
    appointmentId,
    appointmentDate,
    appointmentTime,
    status,
    reasonForVisit AS 'Appointment Info'
FROM
    Appointment
WHERE
    patientId = 2
        AND appointmentDate BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY appointmentDate;

-- Get all appointments for multiple patients, ordered by date.
SELECT 
    appointmentId,
    appointmentDate,
    appointmentTime,
    status,
    reasonForVisit AS 'Appointment Info'
FROM
    Appointment
WHERE
    patientId IN (1 , 2, 3)
ORDER BY appointmentDate;

-- Get all doctors in a specific department. 
SELECT 
    doctorId,
    CONCAT(doctorFirstName, ' ', doctorLastName) AS Name
FROM
    Doctor
WHERE
    DepartmentId = 5;

-- Get all doctors in a multiple departments. 
SELECT 
    doctorId,
    CONCAT(doctorFirstName, ' ', doctorLastName) AS Name
FROM
    Doctor
WHERE
    departmentId IN (2 , 4, 6);

-- Get a patient's full medical history.
SELECT 
    CONCAT(diagnosis,
            ' ',
            treatment,
            ' ',
            recordDate) AS 'Medical History'
FROM
    MedicalRecord
WHERE
    patientId = 8
ORDER BY recordDate;

-- List all appointments with the doctor and patient names involved in that appointment. 
SELECT 
    appointmentId,
    appointmentDate,
    appointmentTime,
    status,
    CONCAT(patientFirstName, ' ', patientLastName) AS 'Patient Name',
    CONCAT(doctorFirstName, ' ', doctorLastName) AS 'Doctor Name'
FROM
    Appointment
        JOIN
    Patient ON Appointment.patientId = Patient.patientId
        JOIN
    InvolvedIn ON Appointment.appointmentId = InvolvedIn.appointmentId
        JOIN
    Doctor ON InvolvedIn.doctorId = Doctor.doctorId
ORDER BY appointmentDate;

-- Find all prescriptions for a specific patient. 
SELECT 
    prescriptionId,
    medicationName,
    notes 'Medication Notes',
    CONCAT(patientFirstName, ' ', patientLastName) AS 'Patient Name'
FROM
    Prescription
        JOIN
    Lists ON Prescription.prescriptionId = Lists.prescriptionId
        JOIN
    Appointment ON Appointment.appointmentId = Prescription.appointmentId
        JOIN
    Patient ON Appointment.patientId = Patient.patientId
WHERE
    Patient.patientId = 5
ORDER BY Appointment.appointmentDate;

-- Find all prescriptions for a specific patient (using sub-query to find patientId by name).
SELECT 
    prescriptionId,
    medicationName,
    notes 'Medication Notes',
    CONCAT(patientFirstName, ' ', patientLastName) AS 'Patient Name'
FROM
    Prescription
        JOIN
    Lists ON Prescription.prescriptionId = Lists.prescriptionId
        JOIN
    Appointment ON Appointment.appointmentId = Prescription.appointmentId
        JOIN
    Patient ON Appointment.patientId = Patient.patientId
WHERE
    Patient.patientId = (SELECT 
            patientId
        FROM
            Patient
        WHERE
            patientFirstName = 'Colm'
                AND PatientLastName = 'Dunne')
ORDER BY Appointment.appointmentDate;

-- Count the number of appointments per doctor.
SELECT 
    CONCAT(DoctorFirstName, ' ', DoctorLastName) AS 'Doctor',
    COUNT(InvolvedIn.appointmentId) AS 'Number of Appointments'
FROM
    InvolvedIn
        JOIN
    Doctor ON InvolvedIn.doctorId = Doctor.doctorId
GROUP BY InvolvedIn.doctorId , Doctor.doctorFirstName , Doctor.doctorLastName
ORDER BY COUNT(InvolvedIn.appointmentId) DESC;

-- Count the number of appointments per doctor (with more than 1 appointment).
SELECT 
    CONCAT(doctorFirstName, ' ', doctorLastName) AS 'Doctor',
    COUNT(InvolvedIn.appointmentId) AS 'Number of Appointments'
FROM
    InvolvedIn
        JOIN
    Doctor ON InvolvedIn.doctorId = Doctor.doctorId
GROUP BY InvolvedIn.doctorId , Doctor.doctorFirstName , Doctor.doctorLastName
HAVING COUNT(InvolvedIn.appointmentId) > 1
ORDER BY COUNT(InvolvedIn.appointmentId) DESC;

-- Find all patients a specific doctor is involved with, including their role. 
SELECT 
    CONCAT(patientFirstName, ' ', patientLastName) AS 'Patient Name',
    InvolvedIn.roles
FROM
    Doctor
        JOIN
    InvolvedIn ON Doctor.doctorId = InvolvedIn.doctorId
        JOIN
    Appointment ON InvolvedIn.appointmentId = Appointment.appointmentId
        JOIN
    Patient ON Appointment.patientId = Patient.patientId
WHERE
    Doctor.doctorLastName = 'Kelly';

-- Get all appointments scheduled within a date range. 
SELECT 
    DATE_FORMAT(appointmentDate, '%W %M %D, %Y') AS 'Scheduled Date'
FROM
    Appointment
WHERE
    appointmentDate BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY appointmentDate;

-- Find the most prescribed medication. 
SELECT 
    medicationName, COUNT(medicationName) AS Frequency
FROM
    Lists
GROUP BY medicationName
HAVING COUNT(medicationName) >= ALL (SELECT 
        COUNT(medicationName)
    FROM
        Lists
    GROUP BY medicationName);

-- List all doctors and their department name, ordered by department. 
SELECT 
    Doctor.doctorFirstName,
    Doctor.doctorLastName,
    Department.departmentName
FROM
    Doctor
        LEFT JOIN
    Department ON Doctor.departmentId = Department.departmentId
ORDER BY Department.departmentName;

-- Find all patients with a specific blood type.
SELECT 
    patientFirstName, patientLastName, bloodType
FROM
    Patient
WHERE
    bloodType = 'O+';

-- Search for a doctor by last name.
SELECT 
    doctorFirstName, doctorLastName AS 'Name'
FROM
    Doctor
WHERE
    doctorLastName LIKE 'S%';
 
-- Find patients by partial last name
SELECT 
    patientFirstName, patientLastName, dateOfBirth
FROM
    Patient
WHERE
    patientLastName LIKE 'O%';

-- Calculate each patient's age and total appointments, including patients with no appointments
SELECT 
    CONCAT(Patient.patientFirstName,
            ' ',
            Patient.patientLastName) AS 'Patient Name',
    TIMESTAMPDIFF(YEAR,
        Patient.dateOfBirth,
        CURDATE()) AS 'Age',
    COUNT(Appointment.appointmentId) AS 'Total Appointments'
FROM
    Patient
        LEFT JOIN
    Appointment ON Patient.patientId = Appointment.patientId
GROUP BY Patient.patientId , Patient.patientFirstName , Patient.patientLastName , Patient.dateOfBirth
ORDER BY TIMESTAMPDIFF(YEAR,
    Patient.dateOfBirth,
    CURDATE()) DESC;