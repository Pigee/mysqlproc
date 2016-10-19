-- --------------------------------------------------------
-- 主机:                           undefined
-- 服务器版本:                        10.0.19-MariaDB-1~wheezy - mariadb.org binary distribution
-- 服务器操作系统:                      debian-linux-gnu
-- HeidiSQL 版本:                  9.3.0.5099
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 导出  过程 fh_xydd.sp_static_pipe 结构
DROP PROCEDURE IF EXISTS `sp_static_pipe`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_static_pipe`()
BEGIN

drop table if exists temp_data_his;
CREATE TABLE temp_data_his AS SELECT * FROM
    t_data_pipe_his
WHERE
    update_time >= DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))
        AND update_time <= DATE(NOW()); 


	insert into t_static_pipe(data_id,local_id,local_name,date_time) select uuid(),local_id,local_name,date_format(date_sub(now(),interval 1 day),'%Y-%m-%d') from t_data_pipe;


begin
declare ParaPipeId varchar(36) charset gbk;
declare p_count int;
declare s1 int;
declare s2 int;
declare s2_initime datetime;
declare g10_minp double;
declare g10_minhourp datetime;
declare g10_maxp double;
declare g10_maxhourp datetime;
declare g10_cur double;

declare pipe_cur cursor for select local_id from t_static_pipe where date_time = date(date_sub(now(),interval 1 day));

open pipe_cur;
SELECT 
    COUNT(*)
INTO p_count FROM
    t_static_pipe
WHERE
    date_time = date(date_sub(now(),interval 1 day));
set s1 = 1;
while s1 < p_count + 1 do
  fetch pipe_cur into ParaPipeId;
UPDATE t_static_pipe t1,
    (SELECT 
        x001, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND x001 IS NOT NULL
    ORDER BY x001 * 1 DESC
    LIMIT 0 , 1) t2,
    (SELECT 
        x001, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND x002 IS NOT NULL
    ORDER BY x001 * 1 ASC
    LIMIT 0 , 1) t3,
    (SELECT 
        AVG(x001) x001
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) t4,
    (SELECT 
        ROUND(MAX(x001) - MIN(x001), 2) vib
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) v1 
SET 
    t1.x001_max = t2.x001,
    t1.x001_maxtime = t2.update_time,
    t1.x001_min = t3.x001,
    t1.x001_mintime = t3.update_time,
    t1.x001_avg = ROUND(t4.x001, 3),
    t1.x001_vib = ROUND(v1.vib, 3)
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
        
UPDATE t_static_pipe t1,
    (SELECT 
        x002, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND x002 IS NOT NULL
    ORDER BY x002 * 1 DESC
    LIMIT 0 , 1) t5,
    (SELECT 
        x002, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND x002 IS NOT NULL
    ORDER BY x002 * 1 ASC
    LIMIT 0 , 1) t6,
    (SELECT 
        AVG(x002) x002
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) t7,
    (SELECT 
        ROUND(MAX(x002) - MIN(x002), 2) vib
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) v2 
SET 
    t1.x002_max = t5.x002,
    t1.x002_maxtime = t5.update_time,
    t1.x002_min = t6.x002,
    t1.x002_mintime = t6.update_time,
    t1.x002_avg = ROUND(t7.x002, 3),
    t1.x002_vib = v2.vib
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
 
UPDATE t_static_pipe t1,
    (SELECT 
        x005, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND x005 IS NOT NULL
    ORDER BY x005 * 1 DESC
    LIMIT 0 , 1) t8,
    (SELECT 
        x005, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND x005 IS NOT NULL
    ORDER BY x005 * 1 ASC
    LIMIT 0 , 1) t9,
    (SELECT 
        AVG(x005) x005
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) t10,
    (SELECT 
        ROUND(MAX(x005) - MIN(x005), 2) vib
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) v3 
SET 
    t1.x005_max = t8.x005,
    t1.x005_maxtime = t8.update_time,
    t1.x005_min = t9.x005,
    t1.x005_mintime = t9.update_time,
    t1.x005_avg = ROUND(t10.x005, 3),
    t1.x005_vib = v3.vib
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
            
UPDATE t_static_pipe t1,
    (SELECT 
        g02, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND g02 IS NOT NULL
    ORDER BY g02 * 1 DESC
    LIMIT 0 , 1) t11,
    (SELECT 
        g02, update_time
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)
            AND g02 IS NOT NULL
    ORDER BY g02 * 1 ASC
    LIMIT 0 , 1) t12,
    (SELECT 
        AVG(g02) g02
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) t13,
    (SELECT 
        ROUND(MAX(g02) - MIN(g02), 2) vib
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) v4 
SET 
    t1.g02_max = t11.g02,
    t1.g02_maxtime = t11.update_time,
    t1.g02_min = t12.g02,
    t1.g02_mintime = t12.update_time,
    t1.g02_avg = ROUND(t13.g02, 3),
    t1.g02_vib = v4.vib
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
            
UPDATE t_static_pipe t1,
    (SELECT 
        MAX(g10 * 1) - MIN(g10 * 1) g10_day
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY) and g10 <> 0) t14,
    (SELECT 
        MAX(g10 * 1) - MIN(g10 * 1) g10_month
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time >= DATE_ADD(DATE_ADD(LAST_DAY(NOW()), INTERVAL 1 DAY), INTERVAL - 1 MONTH)
            AND update_time < NOW() and g10 <> 0) t15 
SET 
    t1.g10_day = ROUND(t14.g10_day, 3),
    t1.g10_month = ROUND(t15.g10_month, 3)
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
	UPDATE t_static_pipe t1,
    (SELECT 
        ROUND(MAX(g11) - MIN(g11), 2) g11_vib
    FROM
        temp_data_his
    WHERE
        local_id = ParaPipeId
            AND update_time <= DATE(NOW())
            AND update_time >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)) t17 
SET 
    t1.g11_vib = t17.g11_vib
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
	
   
         UPDATE t_static_pipe t1,(select max(g10)-min(g10) g11 from temp_data_his where 
           update_time >= concat(date_format(date_sub(now(),interval 1 day),'%Y-%m-%d'),' 01:30:00') and update_time <= concat(date_format(date_sub(now(),interval 1 day),'%Y-%m-%d'),' 04:00:00') and local_id = ParaPipeId and g10 <> 0 ) t16 
            set   
                 t1.g11_night = round(t16.g11,2)
            WHERE
                     t1.local_id = ParaPipeId
                      AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);
   
   
  set s2 = 1;
     set s2_initime = date_sub(date(now()),interval 1 day);
    
	SELECT 
    (MAX(g10) - MIN(g10))
INTO g10_cur FROM
    temp_data_his
WHERE
    local_id = ParaPipeId
        AND update_time >= s2_initime
        AND update_time <= DATE_ADD(s2_initime, INTERVAL 1 HOUR) and g10 <> 0;
     
     set g10_minp = g10_cur;
    
     set g10_minhourp = s2_initime;
      
     set g10_maxp = g10_cur;
     set g10_maxhourp = s2_initime;
     while s2 < 93 do
     select (max(g10) - min(g10)) into g10_cur from temp_data_his where local_id = ParaPipeId and update_time >= s2_initime and update_time <= date_add(s2_initime,interval 1 hour) and g10 <> 0;
     if g10_cur < g10_minp then 
      set g10_minp = g10_cur;
     set g10_minhourp = s2_initime;
     end if;
     
     if g10_cur > g10_maxp then 
      set g10_maxp = g10_cur;
     set g10_maxhourp = s2_initime;
     
     end if;
     
     set s2_initime = date_add(s2_initime,interval 15 minute);
     set s2 =  s2 + 1;
   end while ;
   
   update t_static_pipe t1,
   (SELECT g10_maxhourp, round(g10_maxp,1) g10_maxp, g10_minhourp, round(g10_minp,1) g10_minp) t2
   set
   t1.g10_max = t2.g10_maxp,
   t1.g10_maxhour = t2.g10_maxhourp,
   t1.g10_min = t2.g10_minp,
   t1.g10_minhour = t2.g10_minhourp
   where t1.local_id = ParaPipeId
   and date_time = date_sub(date(now()),interval 1 day);
   
  set s1 = s1 + 1;
end while;
close pipe_cur;
end;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
