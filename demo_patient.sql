use hospital;

CALL create_patient_and_appointment(
    'Demo病患2',                    -- 姓名
    'F',                           -- 性別
    '1990-05-15',                 -- 生日
    '0922334455',                 -- 電話
    'Demo地址',                    -- 地址
    'demo.patient@email.com',     -- 電子郵件
    '12', 	                      -- 醫生ID
    DATE_ADD(NOW(), INTERVAL 10 MINUTE)  -- 10分鐘後預約
);

SELECT 
    p.name AS 病患姓名,
    d.name AS 醫生姓名,
    a.appointment_time AS 預約時間,
    a.status AS 狀態
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id
WHERE p.name = 'Demo病患2';

SELECT * FROM patient; 
SELECT * FROM appointment;



SELECT * FROM bill;

CALL process_payment(35, '現金');