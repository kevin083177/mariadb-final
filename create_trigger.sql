use hospital;

-- 防止醫生修改入職日期在未來
CREATE TRIGGER doctor_hire_date_check
BEFORE INSERT ON doctor
FOR EACH ROW
BEGIN
    IF NEW.hire_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '入職日期不能在未來';
    END IF;
END;

CREATE TRIGGER doctor_hire_date_update_check
BEFORE UPDATE ON doctor
FOR EACH ROW
BEGIN
    IF NEW.hire_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '入職日期不能在未來';
    END IF;
END;

-- 驗證醫生電話號碼格式
CREATE TRIGGER doctor_phone_check
BEFORE INSERT ON doctor
FOR EACH ROW
BEGIN
    IF NEW.phone IS NOT NULL AND (LENGTH(NEW.phone) != 10 OR NEW.phone NOT REGEXP '^09[0-9]{8}$') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '電話號碼格式錯誤，應為09開頭的10位數字';
    END IF;
END;

CREATE TRIGGER doctor_phone_update_check
BEFORE UPDATE ON doctor
FOR EACH ROW
BEGIN
    IF NEW.phone IS NOT NULL AND (LENGTH(NEW.phone) != 10 OR NEW.phone NOT REGEXP '^09[0-9]{8}$') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '電話號碼格式錯誤，應為09開頭的10位數字';
    END IF;
END;

-- 防止醫生同一時段有多筆預約
CREATE TRIGGER doctor_time_conflict_check
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;
    SELECT COUNT(*) INTO conflict_count
    FROM appointment
    WHERE doctor_id = NEW.doctor_id
    AND appointment_time = NEW.appointment_time
    AND status IN ('已預約', '完成');

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '該醫生在此時間已有預約';
    END IF;
END;

CREATE TRIGGER doctor_time_conflict_update_check
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;
    SELECT COUNT(*) INTO conflict_count
    FROM appointment
    WHERE doctor_id = NEW.doctor_id
    AND appointment_time = NEW.appointment_time
    AND status IN ('已預約', '完成')
    AND appointment_id != NEW.appointment_id;

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '該醫生在此時間已有預約';
    END IF;
END;

-- 防止病患出生日期在未來
CREATE TRIGGER patient_birth_date_check
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '出生日期不能在未來';
    END IF;
END;

CREATE TRIGGER patient_birth_date_update_check
BEFORE UPDATE ON patient
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '出生日期不能在未來';
    END IF;
END;

-- 驗證病患電話號碼格式
CREATE TRIGGER patient_phone_check
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.phone) != 10 OR NEW.phone NOT REGEXP '^09[0-9]{8}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '電話號碼格式錯誤，應為09開頭的10位數字';
    END IF;
END;

CREATE TRIGGER patient_phone_update_check
BEFORE UPDATE ON patient
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.phone) != 10 OR NEW.phone NOT REGEXP '^09[0-9]{8}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '電話號碼格式錯誤，應為09開頭的10位數字';
    END IF;
END;

-- 防止病患同一時段有多筆預約
CREATE TRIGGER patient_time_conflict_check
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;
    SELECT COUNT(*) INTO conflict_count
    FROM appointment
    WHERE patient_id = NEW.patient_id
    AND appointment_time = NEW.appointment_time
    AND status IN ('已預約', '完成');

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '該病患在此時間已有預約';
    END IF;
END;

-- 防止掛號插入過去時間
CREATE TRIGGER appointment_time_check
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    IF NEW.appointment_time < NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '預約時間不能在過去';
    END IF;
END;

CREATE TRIGGER appointment_time_update_check
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
    IF NEW.appointment_time < NOW() AND OLD.status = '已預約' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '預約時間不能在過去';
    END IF;
END;

-- 確保只有"完成"狀態的掛號才能建立病歷

CREATE TRIGGER medical_record_appointment_status_check
BEFORE INSERT ON medical_record
FOR EACH ROW
BEGIN
    DECLARE appointment_status VARCHAR(10);
    SELECT status INTO appointment_status
    FROM appointment
    WHERE appointment_id = NEW.appointment_id;

    IF appointment_status != '完成' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '只有完成的掛號才能建立病歷';
    END IF;
END;


-- 病例不能早於掛號日期
CREATE TRIGGER medical_record_date_check
BEFORE INSERT ON medical_record
FOR EACH ROW
BEGIN
    DECLARE appointment_date DATE;
    SELECT DATE(appointment_time) INTO appointment_date
    FROM appointment
    WHERE appointment_id = NEW.appointment_id;

    IF NEW.record_date < appointment_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '病歷日期不能早於掛號日期';
    END IF;
END;

CREATE TRIGGER medical_record_date_update_check
BEFORE UPDATE ON medical_record
FOR EACH ROW
BEGIN
    DECLARE appointment_date DATE;
    SELECT DATE(appointment_time) INTO appointment_date
    FROM appointment
    WHERE appointment_id = NEW.appointment_id;

    IF NEW.record_date < appointment_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '病歷日期不能早於掛號日期';
    END IF;
END;

-- 防止重複建立病歷
CREATE TRIGGER duplicate_medical_record_check
BEFORE INSERT ON medical_record
FOR EACH ROW
BEGIN
    DECLARE record_count INT;
    SELECT COUNT(*) INTO record_count
    FROM medical_record
    WHERE appointment_id = NEW.appointment_id;
    
    IF record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '該掛號已有病歷記錄';
    END IF;
END;

-- 確保處方籤對應的病歷存在
CREATE TRIGGER prescription_record_exists_check
BEFORE INSERT ON prescription
FOR EACH ROW
BEGIN
    DECLARE record_count INT;
    SELECT COUNT(*) INTO record_count
    FROM medical_record
    WHERE record_id = NEW.record_id;
    
    IF record_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '處方籤必須對應已存在的病歷';
    END IF;
END;

-- 禁止手動插入帳單
CREATE TRIGGER prevent_manual_bill_insert
BEFORE INSERT ON bill
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = '禁止手動插入帳單，帳單僅能由系統自動生成';
END;

-- 確保只有"完成"狀態的掛號才能產生帳單
CREATE TRIGGER bill_appointment_status_check
BEFORE INSERT ON bill
FOR EACH ROW
BEGIN
    DECLARE appointment_status VARCHAR(10);
    SELECT status INTO appointment_status
    FROM appointment
    WHERE appointment_id = NEW.appointment_id;
    
    IF appointment_status != '完成' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '只有完成的掛號才能產生帳單';
    END IF;
END;

-- 防止重複開立帳單
CREATE TRIGGER duplicate_bill_check
BEFORE INSERT ON bill
FOR EACH ROW
BEGIN
    DECLARE bill_count INT;
    SELECT COUNT(*) INTO bill_count
    FROM bill
    WHERE appointment_id = NEW.appointment_id;
    
    IF bill_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '該掛號已有帳單記錄';
    END IF;
END;

-- 帳單金額不能修改為負數
CREATE TRIGGER bill_amount_update_check
BEFORE UPDATE ON bill
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '帳單金額不能為負數';
    END IF;
END;

-- 已付款帳單不能修改金額
CREATE TRIGGER paid_bill_amount_protection
BEFORE UPDATE ON bill
FOR EACH ROW
BEGIN
    IF OLD.status = '已付款' AND OLD.amount != NEW.amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '已付款帳單不能修改金額';
    END IF;
END;

-- 付款時必須指定付款方式
CREATE TRIGGER payment_method_check
BEFORE UPDATE ON bill
FOR EACH ROW
BEGIN
    IF NEW.status = '已付款' AND NEW.payment_method IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '付款時必須指定付款方式';
    END IF;
END;

SHOW TRIGGERS;