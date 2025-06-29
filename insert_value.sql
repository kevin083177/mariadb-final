-- doctor
INSERT INTO doctor (name, gender, phone, email, hire_date) VALUES
('陳建宏', 'M', '0912345678', 'jhchen@example.com','2015-06-12'),
('林怡君', 'F', '0922333444', 'yijunlin@example.com','2017-09-05'),
('張育誠', 'M', '0988776655', 'yucheng@example.com','2016-03-22'),
('許芳儀', 'F', '0933445566', 'fangyi@example.com','2020-01-15'),
('黃志明', 'M', '0955667788', 'zmhuang@example.com','2013-11-10'),
('陳佳慧', 'F', '0966554433', 'chiahui@example.com','2018-08-30'),
('李建宇', 'M', '0911222333', 'jianyuli@example.com','2014-07-01'),
('王心如', 'F', '0922111444', 'xinruwang@example.com','2019-05-12'),
('趙偉哲', 'M', '0933777888', 'weizhao@example.com','2021-10-09'),
('鄭雅雯', 'F', '0977888999', 'yawen@example.com','2012-02-17');

-- patient
INSERT INTO patient (name, gender, birth_date, phone, address, email) VALUES
('李俊豪', 'M', '1995-04-10', '0911000111', '台北市大安區仁愛路1段1號', 'junhao.lee@example.com'),
('王怡婷', 'F', '1988-12-22', '0922333555', '新北市板橋區中山路2段2號', 'iting.wang@example.com'),
('張志強', 'M', '1979-07-05', '0933111222', '桃園市中壢區中央西路88號', 'chiang@example.com'),
('陳玉珍', 'F', '2000-09-15', '0966888777', '高雄市苓雅區五福三路66號', 'yu.chen@example.com'),
('林柏宇', 'M', '1990-06-30', '0911222333', '台中市西屯區市政路88號', 'boyu.lin@example.com'),
('劉欣儀', 'F', '1993-03-08', '0955667788', '台南市東區中華東路3段3號', 'xinyi.liu@example.com'),
('黃威辰', 'M', '1985-10-18', '0977555666', '新竹市光復路2段10號', 'weicheng.huang@example.com'),
('蔡佳蓉', 'F', '1997-01-27', '0933666555', '基隆市信義區信一路20號', 'jarong@example.com'),
('謝承翰', 'M', '2002-11-12', '0988999777', '彰化縣員林市大同路100號', 'heng.xie@example.com'),
('吳宛儀', 'F', '1991-05-25', '0922111444', '苗栗縣竹南鎮和平路5號', 'wanyi.wu@example.com');

-- appointment
INSERT INTO appointment (patient_id, doctor_id, appointment_time, status) VALUES
(1, 3, '2025-06-15 09:00:00', '完成'),
(2, 5, '2025-06-16 14:30:00', '完成'),
(3, 1, '2025-06-17 10:00:00', '完成'),
(4, 2, '2025-06-17 11:00:00', '完成'),
(5, 7, '2025-06-13 15:00:00', '已逾期'),
(6, 9, '2025-06-10 09:30:00', '完成'),
(7, 4, '2025-06-18 13:00:00', '完成'),
(8, 6, '2025-06-12 16:00:00', '已逾期'),
(9, 8, '2025-06-14 08:30:00', '完成'),
(3, 1, '2025-06-20 09:00:00', '已預約'),
(5, 4, '2025-06-21 10:30:00', '已預約'),
(7, 2, '2025-06-22 14:00:00', '已預約'),
(2, 6, '2025-06-23 11:15:00', '已預約'),
(8, 7, '2025-06-24 09:45:00', '已預約'),
(4, 3, '2025-06-25 13:30:00', '已預約'),
(1, 5, '2025-06-26 15:00:00', '已預約'),
(9, 9, '2025-06-27 10:00:00', '已預約'),
(6, 8, '2025-06-28 08:30:00', '已預約'),
(10, 10, '2025-06-29 16:00:00', '已預約'),
(10, 10, '2025-06-18 09:00:00', '完成'),
(9, 3, '2025-06-03 10:00:00', '完成'),
(1, 4, '2025-06-06 14:00:00', '完成'),
(1, 7, '2025-06-18 12:00:00', '完成'),
(6, 10, '2025-06-07 15:00:00', '完成'),
(1, 9, '2025-06-03 15:00:00', '完成'),
(8, 2, '2025-06-12 11:00:00', '完成'),
(4, 5, '2025-06-08 09:30:00', '完成'),
(7, 6, '2025-06-11 13:00:00', '已逾期'),
(3, 2, '2025-06-05 10:45:00', '完成'),
(2, 8, '2025-06-14 16:15:00', '已逾期'),
(5, 1, '2025-06-09 14:20:00', '完成'),
(10, 3, '2025-06-10 11:10:00', '已逾期'),
(2, 9, '2025-06-17 15:50:00', '完成'),
(6, 4, '2025-06-13 12:30:00', '已逾期'),
(9, 1, '2025-06-16 09:40:00', '完成'),
(3, 5, '2025-06-07 13:25:00', '完成'),
(7, 8, '2025-06-15 10:55:00', '完成'),
(5, 2, '2025-06-18 14:05:00', '完成'),
(4, 7, '2025-06-04 16:40:00', '已逾期'),
(8, 6, '2025-06-19 11:15:00', '已預約');

-- medicine
INSERT INTO medicine (name, type, description) VALUES
('普拿疼加強錠', '錠劑', '用於退燒與止痛'),
('抗生素Amoxicillin', '膠囊', '廣效型抗生素，用於治療感染'),
('生理食鹽水注射液', '注射液', '補充體液用'),
('止咳糖漿', '口服液', '緩解乾咳與刺激性咳嗽'),
('消炎貼布', '貼布', '局部消炎止痛用'),
('B群複方錠', '錠劑', '維生素補充用'),
('胃乳片', '錠劑', '減緩胃酸過多引起的不適'),
('止瀉膠囊', '膠囊', '用於短期緩解腹瀉症狀'),
('葡萄糖注射液', '注射液', '能量補充或低血糖時使用'),
('喉糖液', '口服液', '緩解喉嚨腫痛與不適');

-- medical_record
INSERT INTO medical_record (appointment_id, diagnosis, treatment, record_date) VALUES
(1, '急性上呼吸道感染', '開立感冒藥並建議多休息', '2025-06-15'),
(2, '月經不規則', '安排抽血與後續追蹤', '2025-06-16'),
(3, '過敏性鼻炎', '開立抗組織胺', '2025-06-17'),
(4, '胃食道逆流', '開立制酸劑並建議飲食調整', '2025-06-17'),
(5, '高血壓追蹤', '調整藥物劑量並安排一週後複診', '2025-06-13'),
(6, '小兒發燒', '退燒處理與觀察', '2025-06-10'),
(7, '皮膚濕疹', '開立類固醇藥膏', '2025-06-18'),
(8, '偏頭痛', '開立止痛藥並建議記錄誘發因子', '2025-06-12'),
(9, '背部拉傷', '局部熱敷與肌肉鬆弛劑', '2025-06-14'),
(10, '骨質疏鬆檢查結果解說', '建議補充鈣與維生素D', '2025-06-18'),
(11, '過敏性咳嗽', '追蹤檢查', '2025-06-15'),
(12, '腸胃炎', '開立藥物', '2025-06-10'),
(13, '感冒', '飲食建議', '2025-06-19'),
(14, '糖尿病', '追蹤檢查', '2025-06-13'),
(15, '高血脂', '追蹤檢查', '2025-06-04'),
(16, '過敏性鼻炎', '開立藥物', '2025-06-11'),
(17, '胃食道逆流', '飲食建議', '2025-06-12'),
(18, '偏頭痛', '追蹤檢查', '2025-06-14'),
(19, '背部拉傷', '開立藥物', '2025-06-16'),
(20, '濕疹', '追蹤檢查', '2025-06-17'),
(21, '急性咽炎', '開立藥物', '2025-06-05'),
(22, '關節痛', '飲食建議', '2025-06-09'),
(23, '失眠', '追蹤檢查', '2025-06-08'),
(24, '貧血', '開立藥物', '2025-06-07'),
(25, '肝功能異常', '追蹤檢查', '2025-06-13'),
(26, '骨質疏鬆', '開立藥物', '2025-06-11'),
(27, '高血壓', '追蹤檢查', '2025-06-12'),
(28, '膽結石', '飲食建議', '2025-06-14'),
(29, '皮膚濕疹', '開立藥物', '2025-06-16'),
(30, '關節炎', '追蹤檢查', '2025-06-18');

-- prescription
INSERT INTO prescription (record_id, medicine_id, dosage, duration, instructions) VALUES
(1, 1, '500mg', '每4~6小時1次', '飯後服用'),
(2, 2, '250mg', '每日三次', '連續服用7天'),
(3, 4, '10ml', '每日兩次', '搖勻後服用'),
(4, 7, '1錠', '每日三次', '飯後服用'),
(5, 6, '1錠', '每日一次', '早餐後服用'),
(6, 3, '500ml', '按需靜脈注射', '由護理師執行'),
(7, 5, '1片', '每日1次', '貼於患部，勿重複貼同部位'),
(8, 8, '2粒', '每次腹瀉後服用', '不可過量'),
(9, 10, '10ml', '每日三次', '喉嚨不適時使用'),
(10, 9, '100ml', '緊急時使用', '低血糖症狀出現時施打'),
(11, 7, '2錠', '每日三次', '飯前服用'),
(12, 6, '1錠', '每日一次', '早餐後服用'),
(13, 5, '2片', '每日兩次', '分別貼於不同患部'),
(14, 4, '15ml', '每6小時一次', '咳嗽時服用'),
(15, 9, '250ml', '急性低血糖時', '靜脈點滴使用'),
(16, 2, '500mg', '每8小時一次', '連續服用10天'),
(17, 1, '1000mg', '每8小時一次', '嚴重疼痛時服用'),
(18, 3, '1000ml', '每日一次', '靜脈補液'),
(19, 8, '1粒', '腹瀉時服用', '每日最多6粒'),
(20, 10, '5ml', '每4小時一次', '含漱後吞嚥'),
(21, 4, '20ml', '每日四次', '飯前及睡前服用'),
(22, 5, '1片', '疼痛時使用', '每片可使用8小時'),
(23, 6, '2錠', '每日兩次', '早晚餐後服用'),
(24, 7, '1錠', '胃酸過多時', '每日最多4錠'),
(25, 2, '375mg', '每12小時一次', '連續服用5天'),
(26, 3, '250ml', '每日兩次', '靜脈緩慢注射'),
(27, 1, '650mg', '每6小時一次', '發燒或疼痛時服用'),
(28, 8, '3粒', '急性腹瀉時', '首次服用後改為每次1粒'),
(29, 10, '15ml', '每日五次', '喉嚨劇痛時增加使用頻率'),
(30, 9, '150ml', '血糖過低時', '配合胰島素調整使用');

-- bill
-- 將在掛號(appointment) `status = "已完成"`時，自動生成金額為 300 元的帳單