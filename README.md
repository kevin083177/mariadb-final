# 醫療系統資料庫設計與應用

## 專題說明

我們的專題打造一套高效的醫療系統資料庫，旨在實現醫療資訊的數位化管理，提供流暢的查詢體驗。系統支援查詢掛號紀錄、看診紀錄及用藥紀錄，涵蓋醫生、病患、處方簽與藥物等資料。其中掛號功能能夠實現看診完成後，系統自動標記為「完成」。

## 資料庫規劃
### 系統功能構想
我們的醫療資訊系統以病患為核心，整合「醫師管理」、「掛號看診」、「診斷紀錄」、「處方用藥」與「自動帳單」等功能。病患可透過系統預約掛號，醫師則可記錄診斷與開立處方，並自動生成帳單以供後續付款使用。系統支援用藥管理與診斷追蹤，並透過事件排程自動處理逾期預約與補發帳單。此外，我們納入使用者角色權限、資料一致性驗證及進階查詢與報表生成功能，打造出一套高效、完整且具擴充性的醫療資料庫系統。
### 圖表
* ER 圖
    ![](https://github.com/kevin083177/mariadb-final/blob/main/src/erd.png)
*  視圖架構圖
    ![](https://github.com/kevin083177/mariadb-final/blob/main/src/vsd.png)

### 正規化
* 醫生、病患、藥物、病歷資料表均已符合 3NF，可直接參考下方 `CREATE TABLE`
* 其他表格設計過程
    * 預約(appointment)
        | 欄位 | 資料類型 | 說明 | 正規化問題 |
        |------|----------|------|------------|
        | appointment_id | INT | 主鍵 | - |
        | patient_name | VARCHAR(20) | 病患姓名 | 違反2NF：依賴patient_id |
        | patient_phone | VARCHAR(10) | 病患電話 | 違反2NF：依賴patient_id |
        | patient_address | VARCHAR(100) | 病患地址 | 違反2NF：依賴patient_id |
        | doctor_name | VARCHAR(20) | 醫生姓名 | 違反2NF：依賴doctor_id |
        | appointment_time | DATETIME | 預約時間 | - |
        | status | ENUM | 狀態 | - |

    * 處方簽(prescription)
        | 欄位 | 資料類型 | 說明 | 正規化問題 |
        |------|----------|------|------------|
        | prescription_id | INT | 主鍵 | - |
        | patient_name | VARCHAR(20) | 病患姓名 | 違反3NF：傳遞依賴 |
        | doctor_name | VARCHAR(20) | 醫生姓名 | 違反3NF：傳遞依賴 |
        | medicine_name | VARCHAR(100) | 藥物名稱 | 違反2NF：依賴medicine_id |
        | medicine_type | ENUM | 藥物類型 | 違反2NF：依賴medicine_id |
        | medicine_description | TEXT | 藥物說明 | 違反2NF：依賴medicine_id |
        | dosage | VARCHAR(50) | 劑量 | - |
        | duration | VARCHAR(50) | 療程 | - |
        | diagnosis | TEXT | 診斷 | 違反3NF：依賴record_id |
    
    * 帳單(bill)
        | 欄位 | 資料類型 | 說明 | 正規化問題 |
        |------|----------|------|------------|
        | bill_id | INT | 主鍵 | - |
        | patient_name | VARCHAR(20) | 病患姓名 | 違反3NF：傳遞依賴 |
        | patient_phone | VARCHAR(10) | 病患電話 | 違反3NF：傳遞依賴 |
        | doctor_name | VARCHAR(20) | 醫生姓名 | 違反3NF：傳遞依賴 |
        | appointment_time | DATETIME | 預約時間 | 違反3NF：傳遞依賴 |
        | diagnosis | TEXT | 診斷 | 違反3NF：傳遞依賴 |
        | medicine_list | TEXT | 藥物清單 | 違反1NF：非原子值 |
        | amount | DECIMAL(10,2) | 金額 | - |
        | status | ENUM | 付款狀態 | - |
## 資料表建立與基本操作
### CREATE TABLE
* **醫生(Doctor)**
    ```sql
    CREATE TABLE doctor (
        doctor_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(20) NOT NULL,
        gender ENUM('M', 'F') NOT NULL,
        phone VARCHAR(10),
        email VARCHAR(50),
        hire_date DATE NOT NULL
    ) ENGINE=InnoDB;
     ```
 
* **病患(Patient)**
    ```sql
    CREATE TABLE patient (
        patient_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(20) NOT NULL,
        gender ENUM('M', 'F') NOT NULL,
        birth_date DATE NOT NULL,
        phone VARCHAR(10) NOT NULL,
        address VARCHAR(100),
        email VARCHAR(50)
    ) ENGINE=InnoDB;
    ```

* **掛號(Appointment)**
    ```sql
    CREATE TABLE appointment (
        appointment_id INT AUTO_INCREMENT PRIMARY KEY,
        patient_id INT NOT NULL,
        doctor_id INT NOT NULL,
        appointment_time DATETIME NOT NULL,
        status ENUM('已預約', '已逾期', '完成') DEFAULT '已預約',

        FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
        FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
    ) ENGINE=InnoDB;
    ```
* **病歷(Medical_record)**
    ```sql
    CREATE TABLE medical_record (
        record_id INT AUTO_INCREMENT PRIMARY KEY,
        appointment_id INT NOT NULL,
        diagnosis TEXT,
        treatment TEXT,
        record_date DATE NOT NULL,

        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
    ) ENGINE=InnoDB;
    ```

* **藥物(Medicine)**
    ```sql
    CREATE TABLE medicine (
        medicine_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        type ENUM('錠劑', '膠囊', '注射液', '口服液', '貼布') CHARACTER SET utf8mb4 NOT NULL,
        description TEXT
    ) ENGINE=InnoDB;
    ```
    
* **處方籤(Prescription)**
    ```sql
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
    ```
    
* **帳單(Bill)**
    ```sql
    CREATE TABLE bill (
        bill_id INT AUTO_INCREMENT PRIMARY KEY,
        appointment_id INT NOT NULL,
        issue_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        amount DECIMAL(10, 2) NOT NULL,
        status ENUM('未付款', '已付款', '已退款') DEFAULT '未付款',
        payment_method ENUM('現金', '信用卡', '健保') DEFAULT NULL,

        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
    );
    ```
    
### INSERT INTO TABLE
[插入資料表連結](https://github.com/kevin083177/mariadb-final/blob/main/insert_value.sql)

### 索引與效能考量
- 基礎索引
    ```sql
    CREATE INDEX idx_patient_id ON appointment(patient_id);
    CREATE INDEX idx_patient_birth_date ON patient(birth_date);
    CREATE INDEX idx_doctor_id ON appointment(doctor_id);
    CREATE INDEX idx_appointment_time ON appointment(appointment_time);
    CREATE INDEX idx_medicine_name ON medicine(name);
    CREATE INDEX idx_bill_status ON bill(status);
    ```
- 效能索引
    ```sql
    CREATE INDEX idx_appointment_status_time ON appointment(status, appointment_time);
    CREATE INDEX idx_appointment_doctor_status ON appointment(doctor_id, status);
    CREATE INDEX idx_bill_status_date ON bill(status, issue_date);
    ```
## 進階 SQL 功能應用
### 複雜查詢與子查詢
- 每位醫生本月看診數量
    ```sql
    SELECT d.name AS 醫生姓名, COUNT(*) AS 本月看診數
    FROM doctor d
    JOIN appointment a ON d.doctor_id = a.doctor_id
    WHERE MONTH(a.appointment_time) = MONTH(CURRENT_DATE())
      AND YEAR(a.appointment_time) = YEAR(CURRENT_DATE())
      AND a.status = '完成'
    GROUP BY d.name;
    ```
    
- 各類型藥物開立次數統計
    ```sql
    SELECT m.type AS 藥物類型, COUNT(*) AS 開立次數
    FROM prescription p
    JOIN medicine m ON p.medicine_id = m.medicine_id
    GROUP BY m.type;
    ```

- 查詢所有欠錢的病患
    ```sql
    SELECT 
        p.patient_id AS 病患ID,
        p.name AS 病患姓名,
        COUNT(b.bill_id) AS 未付款筆數,
        SUM(b.amount) AS 未付款總金額,
        MAX(b.issue_date) AS 最近帳單時間
    FROM patient p
    JOIN appointment a ON p.patient_id = a.patient_id
    JOIN bill b ON a.appointment_id = b.appointment_id
    WHERE b.status = '未付款'
    GROUP BY p.patient_id, p.name
    HAVING COUNT(b.bill_id) > 0
    ORDER BY a.patient_id;
    ```

- 查詢某位病患最近看診日期
    ```sql
    SELECT p.name AS 病患姓名, 
           MAX(a.appointment_time) AS 最後看診時間
    FROM patient p
    JOIN appointment a ON p.patient_id = a.patient_id
    WHERE a.status = '完成' AND p.name = '病患名稱'
    GROUP BY p.patient_id;
    ```
### Trigger
[創建觸發器連結](https://github.com/kevin083177/mariadb-final/blob/main/create_trigger.sql)

### Event
* 將逾時掛號自動修改狀態為"已逾時"
    ```sql
    SET GLOBAL event_scheduler = ON;

    -- 創建每分鐘執行的事件來處理逾時預約
    CREATE EVENT update_expired_appointments
    ON SCHEDULE EVERY 1 MINUTE
    STARTS CURRENT_TIMESTAMP
    COMMENT '自動將逾時的預約狀態更新為已逾期'
    DO
      UPDATE appointment
      SET status = '已逾期'
      WHERE status NOT IN ('完成', '已逾期') 
        -- 若於 15 分鐘內未完成掛號
        AND appointment_time + INTERVAL 15 MINUTE < NOW();
    ```

### View
* 基礎處方記錄
    ```sql
    CREATE VIEW patient_prescription_basic AS
    SELECT 
        p.name AS patient_name,
        a.appointment_time,
        m.diagnosis,
        pr.medicine_id,
        pr.dosage,
        pr.duration
    FROM patient p
    JOIN appointment a ON p.patient_id = a.patient_id
    JOIN medical_record m ON a.appointment_id = m.appointment_id
    JOIN prescription pr ON m.record_id = pr.record_id
    WHERE a.status = '完成';
    ```
        
* 完整醫療記錄
    ```sql
    CREATE VIEW patient_medical_complete AS
    SELECT 
        p.patient_id,
        p.name AS 病患姓名,
        p.gender AS 性別,
        TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) AS 年齡,
        a.appointment_time AS 就診時間,
        d.name AS 醫生姓名,
        m.diagnosis AS 診斷,
        m.treatment AS 治療方式,
        pr.medicine_id,
        md.name AS 藥物名稱,
        md.type AS 藥物類型,
        pr.dosage AS 劑量,
        pr.duration AS 療程,
        pr.instructions AS 服用說明
    FROM patient p
    JOIN appointment a ON p.patient_id = a.patient_id
    JOIN doctor d ON a.doctor_id = d.doctor_id
    JOIN medical_record m ON a.appointment_id = m.appointment_id
    JOIN prescription pr ON m.record_id = pr.record_id
    JOIN medicine md ON pr.medicine_id = md.medicine_id
    WHERE a.status = '完成'
    ORDER BY p.patient_id, a.appointment_time DESC;
    ```
        
* 今日預約紀錄
    ```sql
    CREATE VIEW today_appointments AS
    SELECT 
        a.appointment_time AS 預約時間,
        p.name AS 病患姓名,
        p.phone AS 病患電話,
        d.name AS 醫生姓名,
        a.status AS 狀態
    FROM appointment a
    JOIN patient p ON a.patient_id = p.patient_id
    JOIN doctor d ON a.doctor_id = d.doctor_id
    WHERE DATE(a.appointment_time) = CURDATE()
    ORDER BY a.appointment_time;
    ```

### Procedure
* 病人初次看診
    ```sql
    CREATE PROCEDURE create_patient_and_appointment(
        IN p_name VARCHAR(20),
        IN p_gender ENUM('M', 'F'),
        IN p_birth_date DATE,
        IN p_phone VARCHAR(10),
        IN p_address VARCHAR(100),
        IN p_email VARCHAR(50),
        IN p_doctor_id INT,
        IN p_appointment_time DATETIME
    )
    BEGIN
        DECLARE new_patient_id INT;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SELECT '建立病患和預約失敗' AS error_message;
        END;

        START TRANSACTION;

        -- 1. 建立病患資料
        INSERT INTO patient (name, gender, birth_date, phone, address, email)
        VALUES (p_name, p_gender, p_birth_date, p_phone, p_address, p_email);

        SET new_patient_id = LAST_INSERT_ID();

        -- 2. 建立預約
        INSERT INTO appointment (patient_id, doctor_id, appointment_time, status)
        VALUES (new_patient_id, p_doctor_id, p_appointment_time, '已預約');

        COMMIT;
        SELECT new_patient_id AS patient_id, '建立成功' AS message;
    END;
    ```
    
* 醫生完成看病
    ```sql
    CREATE PROCEDURE complete_appointment(
        IN p_appointment_id INT,
        IN p_diagnosis TEXT,
        IN p_treatment TEXT,
        IN p_medicine_id INT,
        IN p_dosage VARCHAR(50),
        IN p_duration VARCHAR(50),
        IN p_instructions TEXT,
        IN p_bill_amount DECIMAL(10,2)
    )
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SELECT '看診流程失敗，所有操作已回滾' AS error_message;
        END;

        -- 開始交易
        START TRANSACTION;

        -- 1. 更新預約狀態為完成
        UPDATE appointment 
        SET status = '完成' 
        WHERE appointment_id = p_appointment_id;

        -- 2. 建立病歷記錄
        INSERT INTO medical_record (appointment_id, diagnosis, treatment, record_date)
        VALUES (p_appointment_id, p_diagnosis, p_treatment, CURDATE());

        -- 3. 開立處方
        INSERT INTO prescription (record_id, medicine_id, dosage, duration, instructions)
        VALUES (LAST_INSERT_ID(), p_medicine_id, p_dosage, p_duration, p_instructions);

        -- 4. 生成帳單
        SET @allow_bill_insert = 1;
        INSERT INTO bill (appointment_id, amount, issue_date, status)
        VALUES (p_appointment_id, p_bill_amount, NOW(), '未付款');
        SET @allow_bill_insert = NULL;

        -- 提交交易
        COMMIT;
        SELECT '看診流程完成' AS success_message;
    END;
    ```
    
* 帳單付款處理
    ```sql
    CREATE PROCEDURE process_payment(
        IN p_bill_id INT,
        IN p_payment_method ENUM('現金', '信用卡', '健保')
    )
    BEGIN
        DECLARE bill_amount DECIMAL(10,2);
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SELECT '付款處理失敗' AS error_message;
        END;

        START TRANSACTION;

        -- 檢查帳單是否存在且未付款
        SELECT amount INTO bill_amount
        FROM bill 
        WHERE bill_id = p_bill_id AND status = '未付款';

        IF bill_amount IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '帳單不存在或已付款';
        END IF;

        -- 更新帳單狀態
        UPDATE bill 
        SET status = '已付款', payment_method = p_payment_method
        WHERE bill_id = p_bill_id;

        COMMIT;
        SELECT '付款完成' AS message, bill_amount AS amount;
    END;
    ```
    
### 安全性管理
* 管理員權限(admin)
    * 可進行所有資料表的操作
    ```sql
    CREATE USER 'admin'@'%' IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
    ```

* 醫生權限(doctor)
    ```sql
    CREATE USER 'doctor'@'%' IDENTIFIED BY '123456';

    GRANT SELECT ON hospital.patient TO 'doctor'@'%';
    GRANT SELECT ON hospital.doctor TO 'doctor'@'%';
    GRANT SELECT ON hospital.medicine TO 'doctor'@'%';
    GRANT SELECT, INSERT, UPDATE ON hospital.appointment TO 'doctor'@'%';
    GRANT SELECT, INSERT, UPDATE ON hospital.medical_record TO 'doctor'@'%';
    GRANT SELECT, INSERT, UPDATE, DELETE ON hospital.prescription TO 'doctor'@'%';
    GRANT SELECT, INSERT ON hospital.bill TO 'doctor'@'%';
    GRANT EXECUTE ON PROCEDURE hospital.create_patient_and_appointment TO 'doctor'@'%';
    GRANT EXECUTE ON PROCEDURE hospital.complete_appointment TO 'doctor'@'%';
    GRANT SELECT ON hospital.patient_medical_complete TO 'doctor'@'%';
    GRANT SELECT ON hospital.patient_prescription_basic TO 'doctor'@'%';
    GRANT SELECT ON hospital.today_appointments TO 'doctor'@'%';
    ```
    
* 病患權限(patient)
    ```sql
    CREATE USER 'patient'@'%' IDENTIFIED BY '456789';

    GRANT SELECT ON hospital.appointment TO 'patient'@'%';
    GRANT SELECT ON hospital.patient TO 'patient'@'%';
    GRANT SELECT ON hospital.doctor TO 'patient'@'%';
    GRANT SELECT, UPDATE ON hospital.bill TO 'patient'@'%';
    GRANT EXECUTE ON PROCEDURE hospital.create_patient_and_appointment TO 'patient'@'%';
    GRANT EXECUTE ON PROCEDURE hospital.process_payment TO 'patient'@'%';
    ```
    
* 重新加載權限
    ```sql
    FLUSH PRIVILEGES;
    ```

## 組員分工

* 倪靖哲：PPT 製作
* 鄭丞希：文件撰寫、錄影
* 洪振凱：資料庫建立
* 陳威伍：範例資料插入與測試
