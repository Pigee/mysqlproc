-- --------------------------------------------------------
-- 主机:                           218.85.93.130
-- 服务器版本:                        10.0.19-MariaDB-1~wheezy - mariadb.org binary distribution
-- 服务器操作系统:                      debian-linux-gnu
-- HeidiSQL 版本:                  9.3.0.5099
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 导出  过程 fh_xydd.sp_pumproom_static 结构
DROP PROCEDURE IF EXISTS `sp_pumproom_static`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pumproom_static`()
BEGIN

drop table if exists temp_pumproom_his;
CREATE TABLE temp_pumproom_his AS SELECT * FROM
    t_data_pumproom_his
WHERE
    update_time >= DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))
        AND update_time <= DATE(NOW());

insert into t_static_pumproom(data_id,local_id,local_name,date_time) select uuid(),local_id,local_name,date_sub(curdate(),interval 1 day) from t_data_pumproom;

begin
declare ParaPipeId varchar(36) charset gbk;
declare p_count int;
declare s1 int;
declare pipe_cur cursor for select local_id from t_static_pumproom where date_time = date_sub(curdate(),interval 1 day);

open pipe_cur;
SELECT 
    COUNT(*)
INTO p_count FROM
    t_static_pumproom
WHERE
    date_time = date_sub(curdate(),interval 1 day);
set s1 = 1;
while s1 < p_count + 1 do
  fetch pipe_cur into ParaPipeId;

UPDATE t_static_pumproom t1,
    (SELECT 
        x001, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x001*1 DESC
    LIMIT 0 , 1) t2,
    (SELECT 
        x001, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x001*1 ASC
    LIMIT 0 , 1) t3,
    (SELECT 
        AVG(x001) x001
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) t4,
    (SELECT 
       round(max(x001)-min(x001),2)  vib
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) v1,
    

    (SELECT 
        x002, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x002*1 DESC
    LIMIT 0 , 1) t5,
    (SELECT 
        x002, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x002*1 ASC
    LIMIT 0 , 1) t6,
    (SELECT 
        AVG(x002) x002
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) t7,
     (SELECT 
        round(max(x002)-min(x002),2)  vib
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) v2,
    

    (SELECT 
        x005, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x005*1 DESC
    LIMIT 0 , 1) t8,
    (SELECT 
        x005, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x005*1 ASC
    LIMIT 0 , 1) t9,
    (SELECT 
        AVG(x005) x005
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) t10,
     (SELECT 
       round(max(x005)-min(x005),2)  vib
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) v3,
    
 
    (SELECT 
        x025, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x025*1 DESC
    LIMIT 0 , 1) t11,
    (SELECT 
        x025, update_time
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ORDER BY x025*1 ASC
    LIMIT 0 , 1) t12,
    (SELECT 
        AVG(x025) x025
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) t13,
     (SELECT 
        round(max(x025)-min(x025),2)  vib
    FROM
        temp_pumproom_his
    WHERE
        local_id = ParaPipeId
            
    ) v4,
    

    (select m.x022-n.x022 x022_day from (select x022 from temp_pumproom_his where update_time = curdate() and local_id = ParaPipeId ) m
            ,(select x022 from temp_pumproom_his where update_time = date_sub(curdate(),interval 1 day) and local_id = ParaPipeId ) n) t14,
            
	(select max(x022*1)-min(x022*1) x022_month from temp_pumproom_his where 
            local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')) t15,
	(select min(x021*1) x021_night from temp_pumproom_his where 
            local_id = ParaPipeId
            AND update_time between date_sub(curdate(),interval 1 day) and date_add(date_sub(curdate(),interval 1 day),interval 6 hour)) t16,
	(select round(max(x021)-min(x021),2)  x021_vib from temp_pumproom_his where 
            local_id = ParaPipeId
            ) t17,
		(select round(max(x033)-min(x033),2)  x033_sum from temp_pumproom_his where 
            local_id = ParaPipeId
            and x033 <> 0
            ) t18
	
    
SET 
    
    t1.x001_max = t2.x001,
    t1.x001_maxtime = t2.update_time,
    t1.x001_min = t3.x001,
    t1.x001_mintime = t3.update_time,
	t1.x001_avg = round(t4.x001,3),
    t1.x001_vib = round(v1.vib,3),
    
    t1.x002_max = t5.x002,
    t1.x002_maxtime = t5.update_time,
    t1.x002_min = t6.x002,
    t1.x002_mintime = t6.update_time,
	t1.x002_avg = round(t7.x002,3),
    t1.x002_vib = v2.vib,
    
    t1.x005_max = t8.x005,
    t1.x005_maxtime = t8.update_time,
    t1.x005_min = t9.x005,
    t1.x005_mintime = t9.update_time,
	t1.x005_avg =round(t10.x005,3),
    t1.x005_vib = v3.vib,
    
    t1.x025_max = t11.x025,
    t1.x025_maxtime = t11.update_time,
    t1.x025_min = t12.x025,
    t1.x025_mintime = t12.update_time,
	t1.x025_avg = round(t13.x025,3),
    t1.x025_vib = v4.vib,
    
    t1.x022_day = round(t14.x022_day,3),
    t1.x022_month = round(t15.x022_month,3),
    
    t1.x021_night = round(t16.x021_night,3),
    t1.x021_vib = t17.x021_vib,
    t1.x033_day = t18.x033_sum
    
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = date_sub(curdate(),interval 1 day);
   set s1 = s1 + 1;
end while;
close pipe_cur;
end;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
