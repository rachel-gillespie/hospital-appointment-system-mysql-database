# 🏥 Hospital Appointment System — MySQL Database

## Project Overview
A relational database for managing hospital appointments, patients, doctors, departments, prescriptions, and medical records. The schema includes 14 tables, role-based access control, triggers for data integrity, views for common queries, and a set of sample queries demonstrating joins, aggregations, subqueries, and date functions. Built as part of a Higher Diploma in Computer Science Databases module.

## Features
- **14 tables** covering Departments, Doctors, Patients, Appointments, Prescriptions, Medical Records, and junction tables for multi-valued attributes
- **Multi-valued attributes** (emails, phone numbers, qualifications) modelled as separate tables rather than storing multiple values in a single column
- **6 triggers** — appointment status auditing, automatic medical record flagging on appointment confirmation, self-referral prevention, appointment date validation on insert and update, and prescription logging before appointment deletion
- **6 views** — DoctorFullDetails, PatientSummary, UpcomingAppointments, DoctorWorkload, PrescriptionDetails, DepartmentRoster
- **5 user roles** with role-based access control — HospitalAdministrator, Doctor, Nurse, Receptionist, DepartmentCoordinator
- **6 indexes** for query performance on commonly filtered columns
- **Sample queries** covering multi-table joins, subqueries, aggregations, HAVING, LIKE, DATE_FORMAT, TIMESTAMPDIFF, and IN/BETWEEN filters

## Tech Stack
| Category | Technology |
|---|---|
| Database | MySQL |
| Language | SQL |

## Files
| File | Description |
|---|---|
| `script1.sql` | Creates schema, tables, sample data, indexes, triggers, views, and user roles |
| `script2.sql` | Sample queries demonstrating the database capabilities |
| `Class Diagram1.jpg` | Entity relationship class diagram |
| `Assignment1ConceptualDataModel.vpp` | Visual Paradigm conceptual data model file |

## Setup Instructions

### Prerequisites
- [MySQL](https://dev.mysql.com/downloads/mysql/) installed and running
- A MySQL client such as [MySQL Workbench](https://www.mysql.com/products/workbench/) or the MySQL command line

### Installation
1. Clone the repository:
```bash
git clone https://github.com/rachel-gillespie/hospital-appointment-system-mysql-database
cd hospital-appointment-system-mysql-database
```

2. Run `script1.sql` to create the database, tables, and populate sample data:

**MySQL Workbench:** Open `script1.sql` and click Run.

**Command line:**
```bash
mysql -u root -p < script1.sql
```

## How to Run Queries
Run `script2.sql` against the `hospital_appointment` database to execute the sample queries:

**MySQL Workbench:** Open `script2.sql` and click Run.

**Command line:**
```bash
mysql -u root -p hospital_appointment < script2.sql
```

## Schema Overview

### Entities

**Department** — `departmentId`, `departmentName`, `location`, `floor`, `phoneExtension`. A department can have many doctors.

**Doctor** — `doctorId`, `firstName`, `lastName`, `specialisation`, `yearsOfExperience`, `departmentId`. A doctor may have one to two email addresses, one to three phone numbers, and one or more qualifications. A doctor can refer zero or more other doctors and be part of one or more departments.

**Patient** — `patientId`, `firstName`, `lastName`, `dateOfBirth`, `gender`, `bloodType`, `registrationDate`. A patient may have one to two email addresses and one to three phone numbers.

**Appointment** — `appointmentId`, `date`, `time`, `status`, `reasonForVisit`, `notes`. Status is constrained to Pending, Confirmed, or Cancelled. An appointment can generate zero or one prescription and involve one or more doctors.

**Prescription** — `prescriptionId`, linked to an appointment. Exists only through an appointment but has its own identifier. Lists one or more medications.

**MedicalRecord** — A weak entity dependent on Patient. Attributes: `diagnosis`, `treatment`, `date`.

**InvolvedIn** — Junction table between Doctor and Appointment, with a `roles` attribute recording each doctor's role in a given appointment.

### Logical Data Model

```
Department(departmentId, departmentName, location, floor, phoneExtension)

Doctor(doctorId, firstName, lastName, specialisation, yearsOfExperience, departmentId)
  FK: departmentId → Department(departmentId) — ON UPDATE CASCADE, ON DELETE SET NULL

DoctorEmail(doctorId, emailAddress)
  FK: doctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE

DoctorPhone(doctorId, phoneNumber)
  FK: doctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE

DoctorQualification(doctorId, qualification)
  FK: doctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE

Refers(referringDoctorId, referredDoctorId)
  FK: referringDoctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE
  FK: referredDoctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE

Patient(patientId, firstName, lastName, dateOfBirth, gender, bloodType, registrationDate)

PatientEmail(patientId, emailAddress)
  FK: patientId → Patient(patientId) — ON UPDATE CASCADE, ON DELETE CASCADE

PatientPhone(patientId, phoneNumber)
  FK: patientId → Patient(patientId) — ON UPDATE CASCADE, ON DELETE CASCADE

Has(patientId, doctorId)
  FK: patientId → Patient(patientId) — ON UPDATE CASCADE, ON DELETE CASCADE
  FK: doctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE

MedicalRecord(patientId, date, diagnosis, treatment)
  FK: patientId → Patient(patientId) — ON UPDATE CASCADE, ON DELETE CASCADE

Appointment(appointmentId, date, time, status, reasonForVisit, notes, patientId)
  FK: patientId → Patient(patientId) — ON UPDATE CASCADE, ON DELETE SET NULL

InvolvedIn(doctorId, appointmentId, roles)
  FK: doctorId → Doctor(doctorId) — ON UPDATE CASCADE, ON DELETE CASCADE
  FK: appointmentId → Appointment(appointmentId) — ON UPDATE CASCADE, ON DELETE CASCADE

Prescription(prescriptionId, appointmentId)
  FK: appointmentId → Appointment(appointmentId) — ON UPDATE CASCADE, ON DELETE CASCADE

Medication(medicationName, dosage, frequency, duration)

Lists(prescriptionId, medicationName, notes)
  FK: prescriptionId → Prescription(prescriptionId) — ON UPDATE CASCADE, ON DELETE CASCADE
  FK: medicationName → Medication(medicationName) — ON UPDATE CASCADE, ON DELETE CASCADE
```

## Sample Queries
`script2.sql` includes queries for:
- All appointments for a specific patient, ordered by date
- All doctors in a specific department
- A patient's full medical history
- All appointments with doctor and patient names
- All prescriptions for a specific patient (including a subquery variant)
- Appointment count per doctor (with HAVING filter)
- All patients a specific doctor is involved with, including their role
- Appointments within a date range
- Most prescribed medication
- All doctors and their department, ordered by department
- Patient age and total appointments using TIMESTAMPDIFF and LEFT JOIN
