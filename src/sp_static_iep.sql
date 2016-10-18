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

-- 导出  过程 fh_xydd.sp_static_iep 结构
DROP PROCEDURE IF EXISTS `sp_static_iep`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_static_iep`()
BEGIN

if date_format(now(),'%H:%i:%s') = '00:10:00' then
	insert into t_static_iep(data_id,local_id,local_name,date_time) select uuid(),local_id,local_name,date_sub(date(now()),interval 1 day) from t_data_imp;
    insert into t_static_iep(data_id,local_id,local_name,date_time) select uuid(),local_id,local_name,date_sub(date(now()),interval 1 day) from t_data_exp;
end if;

begin
declare localId varchar(36) charset gbk;
declare localType varchar(12) charset gbk;
declare p_count int;
declare s1 int;
declare iep_cur cursor for select local_id from t_static_iep where date_time = date_sub(date(now()),interval 1 day);

open iep_cur;
SELECT 
    COUNT(*)
INTO p_count FROM
    t_static_iep
WHERE
    date_time = date_sub(date(now()),interval 1 day);
set s1 = 1;
while s1 < p_count + 1 do
  fetch iep_cur into localId;
  select local_type into localType from t_local where local_id = localId;
  
  
  if localType = '1' then   
  

 UPDATE t_static_iep t1,
    (SELECT 
        x001, update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) =date_sub(date(now()),interval 1 day)
            AND x001 IS NOT NULL
    ORDER BY x001 * 1 DESC
    LIMIT 0 , 1) t2,
    (SELECT 
        x001, update_time
    FROM
       t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x001 IS NOT NULL
    ORDER BY x001 * 1 ASC
    LIMIT 0 , 1) t3,
    (SELECT 
       AVG(x001) x001, AVG(x005) x005, AVG(x023) x023,AVG(x021) x021, ROUND(MAX(x022 * 1) - MIN(x022 * 1),0) x022_day,ROUND((MAX(x033 * 1) - MIN(x033 * 1)), 2) x033_day,((MAX(x033 * 1) - MIN(x033 * 1))/(MAX(x022 * 1) - MIN(x022 * 1)))*1000 x3perx2_day
    FROM
       t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)) t4,
   
    (SELECT 
        x005, update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x005 IS NOT NULL
    ORDER BY x005 * 1 DESC
    LIMIT 0 , 1) t8,
    (SELECT 
        x005, update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x005 IS NOT NULL
    ORDER BY x005 * 1 ASC
    LIMIT 0 , 1) t9,
    (SELECT 
        x023, update_time
    FROM
       t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x023 IS NOT NULL
    ORDER BY x023 * 1 DESC
    LIMIT 0 , 1) t11,
    (SELECT 
        x023, update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x023 IS NOT NULL
    ORDER BY x023 * 1 ASC
    LIMIT 0 , 1) t12,
  
            (SELECT 
        x021, update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x021 IS NOT NULL
    ORDER BY x021 * 1 DESC
    LIMIT  1) t20,
    (SELECT 
        x021, update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x021 IS NOT NULL
    ORDER BY x021 * 1 ASC
    LIMIT  1) t21
SET 
    t1.x001_max = t2.x001,
    t1.x001_maxtime = t2.update_time,
    t1.x001_min = t3.x001,
    t1.x001_mintime = t3.update_time,
    t1.x001_avg = ROUND(t4.x001, 3),
   
    t1.x005_max = t8.x005,
    t1.x005_maxtime = t8.update_time,
    t1.x005_min = t9.x005,
    t1.x005_mintime = t9.update_time,
    t1.x005_avg = ROUND(t4.x005, 3),
    t1.x023_max = t11.x023,
    t1.x023_maxtime = t11.update_time,
    t1.x023_min = t12.x023,
    t1.x023_mintime = t12.update_time,
    t1.x023_avg = ROUND(t4.x023, 3),
    t1.x021_max = t20.x021,
    t1.x021_maxtime = t20.update_time,
    t1.x021_min = t21.x021,
    t1.x021_mintime = t21.update_time,
    t1.x021_avg = ROUND(t4.x021, 3),
    t1.x022_day = ROUND(t4.x022_day, 3),
    t1.x033_day = ROUND(t4.x033_day, 3),
    t1.x3perx2_day = ROUND(t4.x3perx2_day, 3)

WHERE
    t1.local_id = localId
        AND t1.date_time = date_sub(date(now()),interval 1 day);
	end if;



if localType = '2' then
   UPDATE t_static_iep t1,
    (SELECT 
        x001, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) =date_sub(date(now()),interval 1 day)
            AND x001 IS NOT NULL
    ORDER BY x001 * 1 DESC
    LIMIT 0 , 1) t2,
    (SELECT 
        x001, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x001 IS NOT NULL
    ORDER BY x001 * 1 ASC
    LIMIT 0 , 1) t3,
    (SELECT 
       AVG(x001) x001,AVG(x002) x002, AVG(x005) x005, AVG(x023) x023,AVG(x021) x021, ROUND(MAX(x022 * 1) - MIN(x022 * 1),0) x022_day,ROUND((MAX(x033 * 1) - MIN(x033 * 1)), 2) x033_day,((MAX(x033 * 1) - MIN(x033 * 1))/(MAX(x022 * 1) - MIN(x022 * 1)))*1000 x3perx2_day
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)) t4,
    (SELECT 
        x002, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x002 IS NOT NULL
    ORDER BY x002 * 1 DESC
    LIMIT 0 , 1) t5,
    (SELECT 
        x002, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x002 IS NOT NULL
    ORDER BY x002 * 1 ASC
    LIMIT 0 , 1) t6,
    (SELECT 
        x005, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x005 IS NOT NULL
    ORDER BY x005 * 1 DESC
    LIMIT 0 , 1) t8,
    (SELECT 
        x005, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x005 IS NOT NULL
    ORDER BY x005 * 1 ASC
    LIMIT 0 , 1) t9,
    (SELECT 
        x023, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x023 IS NOT NULL
    ORDER BY x023 * 1 DESC
    LIMIT 0 , 1) t11,
    (SELECT 
        x023, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x023 IS NOT NULL
    ORDER BY x023 * 1 ASC
    LIMIT 0 , 1) t12,
      (SELECT 
        ROUND(MAX(x023) - MIN(x023), 2) vib
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND update_time >= DATE(NOW())
            AND update_time < DATE_ADD(DATE(NOW()), INTERVAL 1 DAY)) v1,
            (SELECT 
        x021, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x021 IS NOT NULL
    ORDER BY x021 * 1 DESC
    LIMIT  1) t20,
    (SELECT 
        x021, update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = localId
            AND date(update_time) = date_sub(date(now()),interval 1 day)
            AND x021 IS NOT NULL
    ORDER BY x021 * 1 ASC
    LIMIT  1) t21
SET 
    t1.x001_max = t2.x001,
    t1.x001_maxtime = t2.update_time,
    t1.x001_min = t3.x001,
    t1.x001_mintime = t3.update_time,
    t1.x001_avg = ROUND(t4.x001, 3),
    t1.x002_max = t5.x002,
    t1.x002_maxtime = t5.update_time,
    t1.x002_min = t6.x002,
    t1.x002_mintime = t6.update_time,
    t1.x002_avg = ROUND(t4.x002, 3),
    t1.x005_max = t8.x005,
    t1.x005_maxtime = t8.update_time,
    t1.x005_min = t9.x005,
    t1.x005_mintime = t9.update_time,
    t1.x005_avg = ROUND(t4.x005, 3),
    t1.x023_max = t11.x023,
    t1.x023_maxtime = t11.update_time,
    t1.x023_min = t12.x023,
    t1.x023_mintime = t12.update_time,
    t1.x023_avg = ROUND(t4.x023, 3),
    t1.x023_vib = v1.vib,
    t1.x021_max = t20.x021,
    t1.x021_maxtime = t20.update_time,
    t1.x021_min = t21.x021,
    t1.x021_mintime = t21.update_time,
    t1.x021_avg = ROUND(t4.x021, 3),
    t1.x022_day = ROUND(t4.x022_day, 3),
    t1.x033_day = ROUND(t4.x033_day, 3),
    t1.x3perx2_day = ROUND(t4.x3perx2_day, 3)

WHERE
    t1.local_id = localId
        AND t1.date_time = date_sub(date(now()),interval 1 day);
	end if;
  
  set s1 = s1 + 1;
end while;
close iep_cur;
end;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
