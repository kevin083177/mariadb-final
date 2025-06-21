use hospital;

CALL complete_appointment(
    '51',          -- 預約ID
    'Demo診斷：輕微感冒',          -- 診斷
    'Demo治療：多休息多喝水',      -- 治療方案
    1,                             -- 藥物ID
    '500mg',                       -- 劑量
    '每8小時一次，連續3天',        -- 療程
    'Demo說明：飯後服用，避免空腹', -- 服用說明
    500.00                         -- 費用
);

SELECT * FROM patient_medical_complete 
WHERE 病患姓名 = 'Demo病患';

SELECT * FROM today_appointments
ORDER BY 預約時間;