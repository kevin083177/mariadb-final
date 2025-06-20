use hospital;

-- ======================================
-- 醫生
-- ======================================
CREATE TABLE doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    phone VARCHAR(10),
    email VARCHAR(50),
    specialty VARCHAR(100),
    hire_date DATE NOT NULL
) ENGINE=InnoDB;

-- ======================================
-- 病患
-- ======================================
CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    birth_date DATE NOT NULL,
    phone VARCHAR(10) NOT NULL,
    address VARCHAR(100),
    email VARCHAR(50)
) ENGINE=InnoDB;

-- ======================================
-- 掛號
-- ======================================
CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_time DATETIME NOT NULL,
    status ENUM('已預約', '已逾期', '完成') DEFAULT '已預約',

    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
) ENGINE=InnoDB;

-- ======================================
-- 病歷
-- ======================================
CREATE TABLE medical_record (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    record_date DATE NOT NULL,

    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
) ENGINE=InnoDB;

-- ======================================
-- 藥物
-- ======================================
CREATE TABLE medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('錠劑', '膠囊', '注射液', '口服液', '貼布') CHARACTER SET utf8mb4 NOT NULL,
    description TEXT
) ENGINE=InnoDB;

-- ======================================
-- 處方籤
-- ======================================
CREATE TABLE prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dosage VARCHAR(50),
    duration VARCHAR(50),
    instructions TEXT,

    FOREIGN KEY (record_id) REFERENCES medical_record(record_id),
    FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
) ENGINE=InnoDB;

-- ======================================
-- 帳單
-- ======================================
CREATE TABLE bill (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    issue_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    status ENUM('未付款', '已付款', '已退款') DEFAULT '未付款',
    payment_method ENUM('現金', '信用卡', '健保') DEFAULT NULL,

    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
);