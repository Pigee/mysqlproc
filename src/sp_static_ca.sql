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

-- 导出  过程 fh_xydd.sp_static_ca 结构
DROP PROCEDURE IF EXISTS `sp_static_ca`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_static_ca`()
BEGIN

if date_format('2015-02-19 23:55:55','%H:%i:%s') = '00:10:00' then
	insert into t_static_pipe(data_id,local_id,local_name,date_time) select uuid(),local_id,local_name,date_format(update_time,'%Y-%m-%d') from t_data_pipe;
end if;

begin
declare ParaPipeId varchar(36) charset gbk;
declare p_count int;
declare s1 int;
declare pipe_cur cursor for select local_id from t_static_pipe where date_time = date_format('2015-02-19 23:55:55','%Y-%m-%d');

open pipe_cur;
SELECT 
    COUNT(*)
INTO p_count FROM
    t_static_pipe
WHERE
    date_time = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d');
set s1 = 1;
while s1 < p_count + 1 do
  fetch pipe_cur into ParaPipeId;
  select ParaPipeId;
  
UPDATE t_static_pipe t1,

  
    (SELECT 
        x001, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY x001 DESC
    LIMIT 0 , 1) t2,
    (SELECT 
        x001, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY x001 ASC
    LIMIT 0 , 1) t3,
    (SELECT 
        AVG(x001) x001
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) t4,
    (SELECT 
        max(x001)-min(x001) vib
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) v1,
    
    
    (SELECT 
        x002, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY x002 DESC
    LIMIT 0 , 1) t5,
    (SELECT 
        x002, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY x002 ASC
    LIMIT 0 , 1) t6,
    (SELECT 
        AVG(x002) x002
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) t7,
     (SELECT 
        max(x002)-min(x002) vib
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) v2,
    
    
    (SELECT 
        x005, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY x005 DESC
    LIMIT 0 , 1) t8,
    (SELECT 
        x005, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY x005 ASC
    LIMIT 0 , 1) t9,
    (SELECT 
        AVG(x005) x005
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) t10,
     (SELECT 
        max(x005)-min(x005) vib
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) v3,
    
    (SELECT 
        g02, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY g02 DESC
    LIMIT 0 , 1) t11,
    (SELECT 
        g02, update_time
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ORDER BY g02 ASC
    LIMIT 0 , 1) t12,
    (SELECT 
        AVG(g02) g02
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) t13,
     (SELECT 
        max(g02)-min(g02) vib
    FROM
        t_data_pipe_his
    WHERE
        local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')
    ) v4,
    (select max(g10)-min(g10) g10_day from t_data_pipe_his where 
            local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')) t14,
            
	(select max(g10)-min(g10) g10_month from t_data_pipe_his where 
            local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m')) t15,
	(select min(g11) g11_night from t_data_pipe_his where 
            local_id = ParaPipeId
            AND update_time between DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d') and date_add(DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d'),interval 6 hour)) t16,
	(select max(g11)-min(g11) g11_vib from t_data_pipe_his where 
            local_id = ParaPipeId
            AND DATE_FORMAT(update_time, '%Y-%m-%d') = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d')) t17
	
    
SET 
    
    t1.x001_max = t2.x001,
    t1.x001_maxtime = t2.update_time,
    t1.x001_min = t3.x001,
    t1.x001_mintime = t3.update_time,
	t1.x001_avg = truncate(t4.x001,3),
    t1.x001_vib = truncate(v1.vib,3),
    
    t1.x002_max = t5.x002,
    t1.x002_maxtime = t5.update_time,
    t1.x002_min = t6.x002,
    t1.x002_mintime = t6.update_time,
	t1.x002_avg = truncate(t7.x002,3),
    t1.x002_vib = truncate(v2.vib,3),
    
    t1.x005_max = t8.x005,
    t1.x005_maxtime = t8.update_time,
    t1.x005_min = t9.x005,
    t1.x005_mintime = t9.update_time,
	t1.x005_avg = truncate(t10.x005,3),
    t1.x005_vib = truncate(v3.vib,3),
    
    t1.g02_max = t11.g02,
    t1.g02_maxtime = t11.update_time,
    t1.g02_min = t12.g02,
    t1.g02_mintime = t12.update_time,
	t1.g02_avg = truncate(t13.g02,3),
    t1.g02_vib = truncate(v4.vib,3),
    
    t1.g10_day = truncate(t14.g10_day,3),
    t1.g10_month = truncate(t15.g10_month,3),
    
    t1.g11_night = truncate(t16.g11_night,3),
    t1.g11_vib = truncate(t17.g11_vib,3)
    
WHERE
    t1.local_id = ParaPipeId
        AND t1.date_time = DATE_FORMAT('2015-02-19 23:55:55', '%Y-%m-%d');
   set s1 = s1 + 1;
end while;
close pipe_cur;
end;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
