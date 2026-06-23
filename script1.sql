DROP SCHEMA IF EXISTS hospital_appointment;

-- ============================================================
-- Create the database and tables
-- ============================================================

CREATE SCHEMA IF NOT EXISTS hospital_appointment;

USE hospital_appointment;

CREATE TABLE IF NOT EXISTS Department (
    departmentId INT PRIMARY KEY,
    departmentName VARCHAR(20),
    location VARCHAR(20),
    floor INT,
    phoneExtension INT
);
        
CREATE TABLE IF NOT EXISTS Doctor (
    doctorId INT PRIMARY KEY,
    doctorFirstName VARCHAR(20),
    doctorLastName VARCHAR(20),
    specialisation VARCHAR(20),
    yearsOfExperience INT,
    departmentId INT,
    CONSTRAINT FK_departmentId FOREIGN KEY (DepartmentId)
        REFERENCES Department (departmentId)
        ON UPDATE CASCADE ON DELETE SET NULL
);
        
CREATE TABLE IF NOT EXISTS DoctorEmail (
    doctorId INT NOT NULL,
    emailAddress VARCHAR(255) NOT NULL,
    PRIMARY KEY (doctorId , emailAddress),
    CONSTRAINT FK_DoctorEmail_doctorId FOREIGN KEY (doctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DoctorPhone (
    doctorId INT NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    PRIMARY KEY (doctorId , phoneNumber),
    CONSTRAINT FK_DoctorPhone_doctorId FOREIGN KEY (doctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DoctorQualification (
    doctorId INT NOT NULL,
    qualification VARCHAR(20) NOT NULL,
    PRIMARY KEY (doctorId , qualification),
    CONSTRAINT FK_DoctorQualification_doctorId FOREIGN KEY (doctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Refers (
    referringDoctorId INT NOT NULL,
    referredDoctorId INT NOT NULL,
    PRIMARY KEY (referringDoctorId , referredDoctorId),
    CONSTRAINT FK_Refers_referringDoctorId FOREIGN KEY (referringDoctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Refers_referredDoctorId FOREIGN KEY (referredDoctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Patient (
    patientId INT PRIMARY KEY,
    patientFirstName VARCHAR(20),
    patientLastName VARCHAR(20),
    dateOfBirth DATE,
    gender VARCHAR(15),
    bloodType VARCHAR(10),
    registrationDate DATE
);

CREATE TABLE IF NOT EXISTS PatientEmail (
    patientId INT NOT NULL,
    emailAddress VARCHAR(50) NOT NULL,
    PRIMARY KEY (patientId , emailAddress),
    CONSTRAINT FK_PatientEmail_patientId FOREIGN KEY (patientId)
        REFERENCES Patient (patientId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PatientPhone (
    patientId INT NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    PRIMARY KEY (patientId , phoneNumber),
    CONSTRAINT FK_PatientPhone_patientId FOREIGN KEY (patientId)
        REFERENCES Patient (patientId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Has (
    doctorId INT NOT NULL,
    patientId INT NOT NULL,
    PRIMARY KEY (doctorId , patientId),
    CONSTRAINT FK_doctortId FOREIGN KEY (doctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_patientId FOREIGN KEY (patientId)
        REFERENCES Patient (patientId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MedicalRecord (
    patientId INT NOT NULL,
    doctorId INT,
    recordDate DATE NOT NULL,
    diagnosis TINYTEXT,
    treatment TINYTEXT,
    PRIMARY KEY (patientId , recordDate),
    CONSTRAINT FK_MedicalRecord_patientId FOREIGN KEY (patientId)
        REFERENCES Patient (patientId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_MedicalRecord_doctorId FOREIGN KEY (doctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE SET NULL
);
        
CREATE TABLE IF NOT EXISTS Appointment (
    appointmentId INT PRIMARY KEY,
    appointmentDate DATE,
    appointmentTime TIME,
    status VARCHAR(20),
    CONSTRAINT chk_status CHECK (status IN ('Pending' , 'Confirmed', 'Cancelled')),
    reasonForVisit TINYTEXT,
    notes TINYTEXT,
    patientId INT,
    CONSTRAINT FK_Appointment_patientId FOREIGN KEY (patientId)
        REFERENCES Patient (patientId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS InvolvedIn (
    doctorId INT NOT NULL,
    appointmentId INT NOT NULL,
    roles VARCHAR(50),
    PRIMARY KEY (doctorId , appointmentId),
    CONSTRAINT FK_InvolvedIn_doctorId FOREIGN KEY (doctorId)
        REFERENCES Doctor (doctorId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_InvolvedIn_appointmentId FOREIGN KEY (appointmentId)
        REFERENCES Appointment (appointmentId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
        
CREATE TABLE IF NOT EXISTS Prescription (
    prescriptionId INT NOT NULL,
    appointmentId INT NOT NULL,
    PRIMARY KEY (prescriptionId),
    CONSTRAINT FK_Prescription_appointmentId FOREIGN KEY (appointmentId)
        REFERENCES Appointment (appointmentId)
        ON UPDATE CASCADE ON DELETE CASCADE
);
        
CREATE TABLE IF NOT EXISTS Medication (
    medicationName VARCHAR(50) NOT NULL PRIMARY KEY,
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50)
);
        
CREATE TABLE IF NOT EXISTS Lists (
    prescriptionId INT NOT NULL,
    medicationName VARCHAR(50) NOT NULL,
    notes VARCHAR(255),
    PRIMARY KEY (prescriptionId , medicationName),
    CONSTRAINT FK_Lists_prescriptionId FOREIGN KEY (prescriptionId)
        REFERENCES Prescription (prescriptionId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Lists_medicationName FOREIGN KEY (medicationName)
        REFERENCES Medication (medicationName)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ============================================================
-- Populate tables with records
-- ============================================================
-- ------------------------------------------------------------
-- Department
-- ------------------------------------------------------------
INSERT INTO Department (departmentId, departmentName, location, floor, phoneExtension) VALUES
(1, 'Cardiology',    'Block A', 2, 2101),
(2, 'Orthopaedics',  'Block B', 1, 2201),
(3, 'Neurology',     'Block A', 3, 2301),
(4, 'Oncology',      'Block C', 4, 2401),
(5, 'Paediatrics',   'Block D', 1, 2501),
(6, 'Dermatology',   'Block B', 2, 2601),
(7, 'Radiology',     'Block C', 1, 2701),
(8, 'Gastroenterol', 'Block D', 3, 2801),
(9, 'Endocrinology', 'Block A', 4, 2901),
(10,'Emergency',     'Block E', 0, 2001);
 
-- ------------------------------------------------------------
-- Doctor
-- ------------------------------------------------------------
INSERT INTO Doctor (doctorId, doctorFirstName, doctorLastName, specialisation, yearsOfExperience, departmentId) VALUES
(1,  'Seamus',   'O\'Brien',    'Cardiology',     18, 1),
(2,  'Aoife',    'Murphy',      'Cardiology',      9, 1),
(3,  'Ciarán',   'Walsh',       'Orthopaedics',   14, 2),
(4,  'Siobhán',  'Kelly',       'Neurology',      21, 3),
(5,  'Pádraig',  'Byrne',       'Oncology',       16, 4),
(6,  'Niamh',    'Fitzgerald',  'Paediatrics',     7, 5),
(7,  'Eoin',     'O\'Sullivan', 'Dermatology',    11, 6),
(8,  'Róisín',   'Doherty',     'Radiology',      13, 7),
(9,  'Declan',   'Ryan',        'Gastroenterol',  10, 8),
(10, 'Fionnuala','Quinn',       'Endocrinology',   8, 9);
 
-- ------------------------------------------------------------
-- DoctorEmail
-- ------------------------------------------------------------
INSERT INTO DoctorEmail (doctorId, emailAddress) VALUES
(1,  'seamus.obrien@stvincentshospital.ie'),
(2,  'aoife.murphy@stvincentshospital.ie'),
(3,  'ciaran.walsh@stvincentshospital.ie'),
(4,  'siobhan.kelly@stvincentshospital.ie'),
(5,  'padraig.byrne@stvincentshospital.ie'),
(6,  'niamh.fitzgerald@stvincentshospital.ie'),
(7,  'eoin.osullivan@stvincentshospital.ie'),
(8,  'roisin.doherty@stvincentshospital.ie'),
(9,  'declan.ryan@stvincentshospital.ie'),
(10, 'fionnuala.quinn@stvincentshospital.ie');
 
-- ------------------------------------------------------------
-- DoctorPhone
-- ------------------------------------------------------------
INSERT INTO DoctorPhone (doctorId, phoneNumber) VALUES
(1,  '+353 1 221 4401'),
(2,  '+353 1 221 4402'),
(3,  '+353 1 221 4403'),
(4,  '+353 1 221 4404'),
(5,  '+353 1 221 4405'),
(6,  '+353 1 221 4406'),
(7,  '+353 1 221 4407'),
(8,  '+353 1 221 4408'),
(9,  '+353 1 221 4409'),
(10, '+353 1 221 4410');
 
-- ------------------------------------------------------------
-- DoctorQualification
-- ------------------------------------------------------------
INSERT INTO DoctorQualification (doctorId, qualification) VALUES
(1,  'MB BCh BAO'),
(1,  'FRCPI'),
(2,  'MB BCh BAO'),
(3,  'MCh Orth'),
(4,  'MD'),
(4,  'FRCPI'),
(5,  'MB BCh BAO'),
(5,  'FFRRCSI'),
(6,  'MB BCh BAO'),
(7,  'MB BCh BAO'),
(8,  'FFRRCSI'),
(9,  'MB BCh BAO'),
(10, 'MB BCh BAO');
 
-- ------------------------------------------------------------
-- Refers
-- ------------------------------------------------------------
INSERT INTO Refers (referringDoctorId, referredDoctorId) VALUES
(1, 8),
(2, 4),
(3, 8),
(4, 5),
(5, 8),
(6, 10),
(7, 1),
(9, 1),
(10, 9),
(2, 9);
 
-- ------------------------------------------------------------
-- Patient
-- ------------------------------------------------------------
INSERT INTO Patient (patientId, patientFirstName, patientLastName, dateOfBirth, gender, bloodType, registrationDate) VALUES
(1,  'Colm',      'Dunne',       '1978-03-14', 'Male',   'A+',  '2021-06-01'),
(2,  'Mairéad',   'Brennan',     '1990-11-22', 'Female', 'O+',  '2020-02-15'),
(3,  'Tomás',     'Gallagher',   '1965-07-08', 'Male',   'B-',  '2019-09-10'),
(4,  'Sinéad',    'O\'Connor',   '1985-01-30', 'Female', 'AB+', '2022-03-22'),
(5,  'Fergal',    'McCarthy',    '1952-05-19', 'Male',   'O-',  '2018-11-05'),
(6,  'Áine',      'Riordan',     '2001-08-03', 'Female', 'A-',  '2023-01-18'),
(7,  'Brendan',   'Doyle',       '1971-12-11', 'Male',   'B+',  '2020-07-30'),
(8,  'Caitlín',   'Ní Mháille',  '1994-04-25', 'Female', 'O+',  '2021-12-09'),
(9,  'Ruairí',    'Flanagan',    '2010-09-17', 'Male',   'A+',  '2023-05-14'),
(10, 'Deirdre',   'Higgins',     '1968-02-28', 'Female', 'AB-', '2019-04-03');

-- ------------------------------------------------------------
-- PatientEmail
-- ------------------------------------------------------------
INSERT INTO PatientEmail (patientId, emailAddress) VALUES
(1,  'colm.dunne@gmail.com'),
(2,  'mairead.brennan@gmail.com'),
(3,  'tomas.gallagher@hotmail.com'),
(4,  'sinead.oconnor@gmail.com'),
(5,  'fergal.mccarthy@eircom.net'),
(6,  'aine.riordan@gmail.com'),
(7,  'brendan.doyle@hotmail.com'),
(8,  'caitlin.nimhaille@gmail.com'),
(9,  'ruairi.flanagan@gmail.com'),
(10, 'deirdre.higgins@eircom.net');
 
-- ------------------------------------------------------------
-- PatientPhone
-- ------------------------------------------------------------
INSERT INTO PatientPhone (patientId, phoneNumber) VALUES
(1,  '+353 87 123 4501'),
(2,  '+353 86 234 5602'),
(2,  '+353 1 496 7712'),
(3,  '+353 83 345 6703'),
(4,  '+353 87 456 7804'),
(5,  '+353 85 567 8905'),
(5,  '+353 1 402 3381'),
(6,  '+353 89 678 9006'),
(7,  '+353 87 789 0107'),
(8,  '+353 86 890 1208'),
(9,  '+353 83 901 2309'),
(10, '+353 85 012 3410');
 
-- ------------------------------------------------------------
-- Has
-- ------------------------------------------------------------
INSERT INTO Has (doctorId, patientId) VALUES
(1,  1), (1,  3), (1,  5),
(2,  2), (2,  4),
(3,  7), (3,  8),
(4,  3), (4,  10),
(5,  5), (5,  6),
(6,  9),
(7,  4), (7,  8),
(8,  2), (8,  7),
(9,  1), (9,  10),
(10, 6);
 
-- ------------------------------------------------------------
-- MedicalRecord
-- ------------------------------------------------------------
INSERT INTO MedicalRecord (patientId, doctorId, recordDate, diagnosis, treatment) VALUES
(1,  1,  '2024-01-08', 'Stable angina',              'Nitrate therapy, lifestyle changes'),
(2,  2,  '2024-01-10', 'Supraventricular tachycardia','Beta-blockers prescribed'),
(3,  3,  '2024-01-12', 'Osteoarthritis of knee',      'Physio referral, anti-inflammatories'),
(4,  4,  '2024-01-15', 'Chronic migraine',            'Triptan therapy initiated'),
(5,  5,  '2024-01-17', 'Stage II lymphoma',           'CHOP chemotherapy cycle 3'),
(6,  7,  '2024-01-19', 'Contact dermatitis',          'Topical corticosteroid cream'),
(7,  3,  '2024-01-22', 'Total hip arthroplasty',      'Post-operative physiotherapy'),
(8,  9,  '2024-01-24', 'Irritable bowel syndrome',    'Dietary modification, antispasmodics'),
(9,  6,  '2024-01-26', 'Asthma',                      'Inhaler technique review, preventer'),
(10, 10, '2024-01-29', 'Hypothyroidism',              'Levothyroxine dose adjusted'),
(1,  1,  '2024-02-05', 'Stable angina follow-up',     'Stress test normal, continue meds'),
(5,  5,  '2024-02-12', 'Lymphoma response assessment','Partial remission, continue CHOP');

-- ------------------------------------------------------------
-- Appointment
-- ------------------------------------------------------------
INSERT INTO Appointment (appointmentId, appointmentDate, appointmentTime, status, reasonForVisit, notes, patientId) VALUES
(1,  '2024-01-08', '09:00:00', 'Confirmed',  'Chest pain follow-up',       'Fasting bloods required',       1),
(2,  '2024-01-10', '10:30:00', 'Confirmed',  'Anxiety and palpitations',   'ECG on arrival',                2),
(3,  '2024-01-12', '11:00:00', 'Confirmed',  'Knee pain',                  'Bring previous X-rays',         3),
(4,  '2024-01-15', '14:00:00', 'Pending',    'Migraine assessment',        NULL,                            4),
(5,  '2024-01-17', '09:30:00', 'Confirmed',  'Chemotherapy review',        'Blood panel beforehand',        5),
(6,  '2024-01-19', '11:30:00', 'Confirmed',  'Rash on forearm',            NULL,                            6),
(7,  '2024-01-22', '15:00:00', 'Cancelled',  'Hip replacement follow-up',  'Reschedule requested',          7),
(8,  '2024-01-24', '10:00:00', 'Confirmed',  'Abdominal pain',             'Ultrasound ordered',            8),
(9,  '2024-01-26', '09:00:00', 'Confirmed',  'Paediatric check-up',        'Parent/guardian to attend',     9),
(10, '2024-01-29', '13:00:00', 'Confirmed',  'Thyroid levels',             'TSH results from GP needed',   10),
(11, '2024-02-05', '09:00:00', 'Confirmed',  'Cardiac stress test',        'Comfortable clothing',          1),
(12, '2024-02-07', '11:00:00', 'Pending',    'IBS review',                 NULL,                            2),
(13, '2024-02-09', '14:30:00', 'Confirmed',  'Post-op knee check',         'Physiotherapy notes attached',  3),
(14, '2024-02-12', '10:00:00', 'Confirmed',  'Fatigue and weight loss',    'Full bloods required',          5);
 
-- ------------------------------------------------------------
-- InvolvedIn
-- ------------------------------------------------------------
INSERT INTO InvolvedIn (doctorId, appointmentId, roles) VALUES
(1,  1,  'Lead Physician'),
(2,  2,  'Lead Physician'),
(3,  3,  'Lead Physician'),
(4,  4,  'Lead Physician'),
(5,  5,  'Lead Physician'),
(7,  6,  'Lead Physician'),
(3,  7,  'Lead Physician'),
(9,  8,  'Lead Physician'),
(6,  9,  'Lead Physician'),
(10, 10, 'Lead Physician'),
(1,  11, 'Lead Physician'),
(8,  11, 'Radiologist'),
(9,  12, 'Lead Physician'),
(3,  13, 'Lead Physician'),
(5,  14, 'Lead Physician'),
(8,  14, 'Radiologist');
 
-- ------------------------------------------------------------
-- Prescription
-- ------------------------------------------------------------
INSERT INTO Prescription (prescriptionId, appointmentId) VALUES
(1,  1),
(2,  2),
(3,  3),
(4,  4),
(5,  5),
(6,  6),
(7,  8),
(8,  9),
(9,  10),
(10, 11);
 
-- ------------------------------------------------------------
-- Medication
-- ------------------------------------------------------------
INSERT INTO Medication (medicationName, dosage, frequency, duration) VALUES
('Isosorbide Mononitrate', '20mg',   'Twice daily',  '3 months'),
('Metoprolol',             '25mg',   'Once daily',   '6 months'),
('Ibuprofen',              '400mg',  'Three daily',  '2 weeks'),
('Sumatriptan',            '50mg',   'As needed',    'Ongoing'),
('Cyclophosphamide',       '750mg',  'IV cycle',     '6 cycles'),
('Betamethasone Cream',    '0.1%',   'Twice daily',  '1 week'),
('Mebeverine',             '135mg',  'Three daily',  '1 month'),
('Salbutamol',             '100mcg', 'As needed',    'Ongoing'),
('Levothyroxine',          '75mcg',  'Once daily',   'Ongoing'),
('Aspirin',                '75mg',   'Once daily',   'Ongoing');
 
-- ------------------------------------------------------------
-- Lists
-- ------------------------------------------------------------
INSERT INTO Lists (prescriptionId, medicationName, notes) VALUES
(1,  'Isosorbide Mononitrate', 'Take after food'),
(1,  'Aspirin',                'Low-dose cardioprotective'),
(2,  'Metoprolol',             'Monitor resting heart rate'),
(3,  'Ibuprofen',              'Take with food, avoid alcohol'),
(4,  'Sumatriptan',            'Do not exceed 2 doses in 24hrs'),
(5,  'Cyclophosphamide',       'Administer with IV hydration'),
(6,  'Betamethasone Cream',    'Avoid prolonged skin contact'),
(7,  'Mebeverine',             'Take 20 mins before meals'),
(8,  'Salbutamol',             'Use spacer device'),
(9,  'Levothyroxine',          'Take on empty stomach, morning'),
(10, 'Isosorbide Mononitrate', 'Ongoing from previous script'),
(10, 'Aspirin',                'Continue low-dose');

-- ============================================================
-- Indexes
-- ============================================================
create index doctorDepartment on Doctor(departmentId);

create index patientAppointment on Appointment(patientId);

create index appointmentInfo on Appointment(appointmentDate, status);

create index appointmentInvolved on InvolvedIn(appointmentId);

create index patientMedicalRecord on MedicalRecord(patientId);

create index doctorPatient on Has(patientId);

-- ============================================================
-- Triggers
-- ============================================================
CREATE TABLE IF NOT EXISTS AppointmentStatusAudit (
    auditId        INT AUTO_INCREMENT PRIMARY KEY,
    appointmentId  INT          NOT NULL,
    oldStatus      VARCHAR(20),
    newStatus      VARCHAR(20),
    changedAt      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changedBy      VARCHAR(100) DEFAULT (USER())
);

DELIMITER $$
CREATE TRIGGER appointment_status_audit
AFTER UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO AppointmentStatusAudit (appointmentId, oldStatus, newStatus)
        VALUES (NEW.appointmentId, OLD.status, NEW.status);
    END IF;
END$$

CREATE TRIGGER flag_medical_record
AFTER UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.status = 'Confirmed' AND OLD.status <> 'Confirmed' THEN
        IF NOT EXISTS (
            SELECT 1 FROM MedicalRecord
            WHERE patientId  = NEW.patientId
              AND recordDate = NEW.appointmentDate
        ) THEN
            INSERT INTO MedicalRecord (patientId, recordDate)
            VALUES (NEW.patientId, NEW.appointmentDate);
        END IF;
    END IF;
END$$

CREATE TRIGGER prevent_self_referral
BEFORE INSERT ON Refers
FOR EACH ROW
BEGIN
    IF NEW.referringDoctorId = NEW.referredDoctorId THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A doctor cannot refer to themselves.';
    END IF;
END$$

CREATE TRIGGER validate_appointment_date_insert
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.appointmentDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment date cannot be in the past.';
    END IF;
END$$

CREATE TRIGGER validate_appointment_date_update
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.appointmentDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment date cannot be set to a past date.';
    END IF;
END$$

CREATE TRIGGER prescription_deletion_check
BEFORE DELETE ON Appointment
FOR EACH ROW
BEGIN
    DECLARE prescriptionCount INT;
 
SELECT 
    COUNT(*)
INTO prescriptionCount FROM
    Prescription
WHERE
    appointmentId = OLD.appointmentId;
 
    IF prescriptionCount > 0 THEN
        INSERT INTO AppointmentStatusAudit (appointmentId, oldStatus, newStatus)
        VALUES (
            OLD.appointmentId,
            OLD.status,
            CONCAT('DELETED — had ', prescriptionCount, ' prescription(s)')
        );
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- Views
-- ============================================================
CREATE OR REPLACE VIEW DoctorFullDetails AS
    SELECT 
        Doctor.doctorId,
        CONCAT(Doctor.doctorFirstName,
                ' ',
                Doctor.doctorLastName) AS 'Doctor Name',
        Doctor.specialisation,
        Doctor.yearsOfExperience,
        Department.departmentName,
        Department.location AS 'Department Location',
        Department.floor AS 'Department Floor',
        DoctorEmail.emailAddress,
        DoctorPhone.phoneNumber,
        DoctorQualification.qualification
    FROM
        Doctor
            LEFT JOIN
        Department ON Doctor.departmentId = Department.departmentId
            LEFT JOIN
        DoctorEmail ON Doctor.doctorId = DoctorEmail.doctorId
            LEFT JOIN
        DoctorPhone ON Doctor.doctorId = DoctorPhone.doctorId
            LEFT JOIN
        DoctorQualification ON Doctor.doctorId = DoctorQualification.doctorId;


CREATE OR REPLACE VIEW PatientSummary AS
    SELECT 
        Patient.patientId,
        CONCAT(Patient.patientFirstName,
                ' ',
                Patient.patientLastName) AS "Patient Name",
        Patient.dateOfBirth,
        Patient.gender,
        Patient.bloodType,
        Patient.registrationDate,
        PatientEmail.emailAddress,
        PatientPhone.phoneNumber,
        MedicalRecord.recordDate,
        MedicalRecord.diagnosis,
        MedicalRecord.treatment
    FROM
        Patient
            LEFT JOIN
        PatientEmail ON Patient.patientId = PatientEmail.patientId
            LEFT JOIN
        PatientPhone ON Patient.patientId = PatientPhone.patientId
            LEFT JOIN
        MedicalRecord ON Patient.patientId = MedicalRecord.patientId;


CREATE OR REPLACE VIEW UpcomingAppointments AS
    SELECT 
        Appointment.appointmentId,
        Appointment.appointmentDate,
        Appointment.appointmentTime,
        Appointment.status,
        Appointment.reasonForVisit,
        Appointment.notes,
        CONCAT(Patient.patientFirstName,
                ' ',
                Patient.patientLastName) AS "Patient Name",
        CONCAT(Doctor.doctorFirstName,
                ' ',
                Doctor.doctorLastName) AS "Doctor Name",
        InvolvedIn.roles
    FROM
        Appointment
            JOIN
        Patient ON Appointment.patientId = Patient.patientId
            JOIN
        InvolvedIn ON Appointment.appointmentId = InvolvedIn.appointmentId
            JOIN
        Doctor ON InvolvedIn.doctorId = Doctor.doctorId
    WHERE
        Appointment.appointmentDate >= CURDATE()
            AND Appointment.status IN ('Confirmed' , 'Pending')
    ORDER BY Appointment.appointmentDate , Appointment.appointmentTime;


CREATE OR REPLACE VIEW DoctorWorkload AS
    SELECT 
        Doctor.doctorId,
        CONCAT(Doctor.doctorFirstName,
                ' ',
                Doctor.doctorLastName) AS "Doctor Name",
        Doctor.specialisation,
        Department.departmentName,
        COUNT(InvolvedIn.appointmentId) AS totalAppointments
    FROM
        Doctor
            LEFT JOIN
        InvolvedIn ON Doctor.doctorId = InvolvedIn.doctorId
            LEFT JOIN
        Department ON Doctor.departmentId = Department.departmentId
    GROUP BY Doctor.doctorId , Doctor.doctorFirstName , Doctor.doctorLastName , Doctor.specialisation , Department.departmentName
    ORDER BY totalAppointments DESC;


CREATE OR REPLACE VIEW PrescriptionDetails AS
    SELECT 
        Prescription.prescriptionId,
        CONCAT(Patient.patientFirstName,
                ' ',
                Patient.patientLastName) AS "Patient Name",
        Appointment.appointmentDate,
        Appointment.appointmentTime,
        Medication.medicationName,
        Medication.dosage,
        Medication.frequency,
        Medication.duration,
        Lists.notes AS medicationNotes
    FROM
        Prescription
            JOIN
        Appointment ON Prescription.appointmentId = Appointment.appointmentId
            JOIN
        Patient ON Appointment.patientId = Patient.patientId
            JOIN
        Lists ON Prescription.prescriptionId = Lists.prescriptionId
            JOIN
        Medication ON Lists.medicationName = Medication.medicationName
    ORDER BY Appointment.appointmentDate , Prescription.prescriptionId;


CREATE OR REPLACE VIEW DepartmentRoster AS
    SELECT 
        Department.departmentId,
        Department.departmentName,
        Department.location,
        Department.floor,
        Department.phoneExtension,
        Doctor.doctorId,
        CONCAT(Doctor.doctorFirstName,
                ' ',
                Doctor.doctorLastName) AS "Doctor Name",
        Doctor.specialisation,
        Doctor.yearsOfExperience
    FROM
        Department
            LEFT JOIN
        Doctor ON Department.departmentId = Doctor.departmentId
    ORDER BY Department.departmentName , Doctor.doctorLastName;

-- ============================================================
-- Users and Privileges
-- ============================================================
CREATE USER Doctor IDENTIFIED BY 'doctor';
CREATE USER Nurse IDENTIFIED BY 'nurse';
CREATE USER DepartmentCoordinator IDENTIFIED BY 'depcoord';
CREATE USER Receptionist IDENTIFIED BY 'receptionist';
CREATE USER HospitalAdministrator IDENTIFIED BY 'admin';

-- HospitalAdministrator
GRANT ALL ON Hospital_Appointment.* TO HospitalAdministrator WITH GRANT OPTION;

-- Receptionist
GRANT SELECT, INSERT, UPDATE
    ON hospital_appointment.Appointment TO Receptionist;
GRANT SELECT
    ON hospital_appointment.Patient TO Receptionist;
GRANT SELECT
    ON hospital_appointment.PatientEmail TO Receptionist;
GRANT SELECT
    ON hospital_appointment.PatientPhone TO Receptionist;

-- DepartmentCoordinator
GRANT SELECT, INSERT, UPDATE
    ON hospital_appointment.Appointment TO DepartmentCoordinator;
GRANT SELECT
    ON hospital_appointment.Doctor TO DepartmentCoordinator;
GRANT SELECT
    ON hospital_appointment.Department TO DepartmentCoordinator;
GRANT SELECT
    ON hospital_appointment.InvolvedIn TO DepartmentCoordinator;

-- Doctor
GRANT SELECT
    ON hospital_appointment.Appointment TO Doctor;
GRANT SELECT
    ON hospital_appointment.Patient TO Doctor;
GRANT SELECT
    ON hospital_appointment.PatientEmail TO Doctor;
GRANT SELECT
    ON hospital_appointment.PatientPhone TO Doctor;
GRANT SELECT, INSERT, UPDATE
    ON hospital_appointment.MedicalRecord TO Doctor;
GRANT SELECT, INSERT, UPDATE
    ON hospital_appointment.Prescription TO Doctor;
GRANT SELECT, INSERT, UPDATE
    ON hospital_appointment.Lists TO Doctor;
GRANT SELECT
    ON hospital_appointment.Medication TO Doctor;
GRANT SELECT, INSERT
    ON hospital_appointment.Refers TO Doctor;
GRANT SELECT
    ON hospital_appointment.InvolvedIn TO Doctor;
GRANT SELECT
    ON hospital_appointment.DoctorEmail TO Doctor;
GRANT SELECT
    ON hospital_appointment.DoctorPhone TO Doctor;

-- Nurse
GRANT SELECT
    ON hospital_appointment.Appointment TO Nurse;
GRANT SELECT
    ON hospital_appointment.Patient TO Nurse;
GRANT SELECT
    ON hospital_appointment.PatientEmail TO Nurse;
GRANT SELECT
    ON hospital_appointment.PatientPhone TO Nurse;
GRANT SELECT
    ON hospital_appointment.MedicalRecord TO Nurse;
GRANT SELECT
    ON hospital_appointment.Prescription TO Nurse;
GRANT SELECT
    ON hospital_appointment.Lists TO Nurse;
GRANT SELECT
    ON hospital_appointment.Medication TO Nurse;
