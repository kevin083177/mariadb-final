use hospital;

SELECT '醫生數量' AS 項目, COUNT(*) AS 數量 FROM doctor
UNION ALL
SELECT '病患數量', COUNT(*) FROM patient
UNION ALL  
SELECT '預約總數', COUNT(*) FROM appointment
UNION ALL
SELECT '完成診療', COUNT(*) FROM appointment WHERE status = '完成'
UNION ALL
SELECT '藥物種類', COUNT(*) FROM medicine;

INSERT INTO doctor (name, gender, phone, email, hire_date)
VALUES ('Demo醫生2', 'M', '0912345999', 'demo.doctor@hospital.com', CURDATE());

SELECT * FROM doctor;

-- 錯誤1：電話格式錯誤 (觸發trigger)
INSERT INTO doctor (name, gender, phone, email, hire_date)
VALUES ('錯誤醫生', 'M', '123456789', 'error@test.com', CURDATE());

-- 錯誤2：未來入職日期 (觸發trigger)
INSERT INTO doctor (name, gender, phone, email, hire_date)
VALUES ('未來醫生', 'F', '0987654321', 'future@test.com', '2030-01-01');