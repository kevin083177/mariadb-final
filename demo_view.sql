use hospital;

-- 1. 基礎處方紀錄
-- 查看所有處方紀錄
    SELECT * FROM patient_prescription_basic
    ORDER BY appointment_time DESC;
    
-- 查詢特定病患的處方紀錄
    SELECT 
        patient_name,
        appointment_time,
        diagnosis,
        dosage,
        duration
    FROM patient_prescription_basic
    WHERE patient_name = '李俊豪'
    ORDER BY appointment_time;

-- 統計病患用藥次數
    SELECT 
        patient_name,
        COUNT(*) AS 總處方數,
        COUNT(DISTINCT medicine_id) AS 不同藥物數
    FROM patient_prescription_basic
    GROUP BY patient_name
    ORDER BY 總處方數 DESC;
    
-- 藥物使用頻率統計
    SELECT 
        medicine_id,
        COUNT(*) AS 開立次數,
        COUNT(DISTINCT patient_name) AS 使用患者數
    FROM patient_prescription_basic
    GROUP BY medicine_id
    ORDER BY 開立次數 DESC;

-- 2. 完整醫療記錄
-- 查看完整就醫紀錄
    SELECT * FROM patient_medical_complete
    ORDER BY 就診時間 DESC;

-- 特定病患的完整病歷
    SELECT 
        病患姓名,
        性別,
        年齡,
        就診時間,
        醫生姓名,
        診斷,
        藥物名稱,
        劑量,
        服用說明
    FROM patient_medical_complete
    WHERE 病患姓名 = '李俊豪'
    ORDER BY 就診時間 DESC;

-- 特定醫生的診療紀錄
    SELECT 
        醫生姓名,
        病患姓名,
        就診時間,
        診斷,
        治療方式,
        藥物名稱
    FROM patient_medical_complete
    WHERE 醫生姓名 = '陳建宏'
    ORDER BY 就診時間 DESC;
    
-- 分析醫生開藥習慣
    SELECT 
        醫生姓名,
        藥物名稱,
        藥物類型,
        COUNT(*) AS 開立次數,
        GROUP_CONCAT(DISTINCT 劑量) AS 常用劑量
    FROM patient_medical_complete
    GROUP BY 醫生姓名, 藥物名稱, 藥物類型
    HAVING COUNT(*) >= 1
    ORDER BY 醫生姓名, 開立次數;

-- 藥物類型使用統計
    SELECT 
        藥物類型,
        COUNT(*) AS 使用次數,
        COUNT(DISTINCT 藥物名稱) AS 藥物品項數,
        COUNT(DISTINCT 病患姓名) AS 使用患者數
    FROM patient_medical_complete
    GROUP BY 藥物類型
    ORDER BY 使用次數 DESC;

-- 3. 今日預約紀錄
-- 查看今日所有預約
    SELECT * FROM today_appointments;

-- 查看今日預約狀態之病患
    SELECT 
        TIME(預約時間) AS 時間,
        病患姓名,
        病患電話,
        醫生姓名
    FROM today_appointments
    WHERE 狀態 = '已預期' -- 已預約、已逾期、完成
    ORDER BY 預約時間;

-- 查看特定醫生今日的預約
    SELECT 
        TIME(預約時間) AS 時間,
        病患姓名,
        病患電話,
        狀態
    FROM today_appointments
    WHERE 醫生姓名 = '許芳儀'
    ORDER BY 預約時間;

-- 查看時段預約
    SELECT 
        TIME(預約時間) AS 時間,
        病患姓名,
        醫生姓名,
        狀態
    FROM today_appointments
    WHERE TIME(預約時間) BETWEEN '09:00:00' AND '12:00:00'
    ORDER BY 預約時間;

-- 今日預約統計
    SELECT 
        '今日預約總數' AS 項目,
        COUNT(*) AS 數量
    FROM today_appointments

    UNION ALL

    SELECT 
        '待診人數' AS 項目,
        COUNT(*) AS 數量
    FROM today_appointments
    WHERE 狀態 = '已預約'

    UNION ALL

    SELECT 
        '已完成診療' AS 項目,
        COUNT(*) AS 數量
    FROM today_appointments
    WHERE 狀態 = '完成'

    UNION ALL

    SELECT 
        '逾期未到' AS 項目,
        COUNT(*) AS 數量
    FROM today_appointments
    WHERE 狀態 = '已逾期';
