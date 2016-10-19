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

-- 导出  过程 fh_xydd.sp_zrtq_value 结构
DROP PROCEDURE IF EXISTS `sp_zrtq_value`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_zrtq_value`(paraField varchar(20) charset gbk)
BEGIN

drop table if exists temp_zrtq;
create temporary table temp_zrtq(local_id varchar(36),tq_time varchar(36));


insert into temp_zrtq 
SELECT 
        local_id,FUNC_ZRTQ(local_id)
    FROM
        t_local_signal
    WHERE
        field = paraField;
   
  if paraField = 'g02' then       
 SELECT 
    t1.local_id id,
    t1.local_name name,
    DATE_FORMAT(t1.update_time, '%m-%d %H:%i:%s') time,
    ROUND(t1.g02, 2) n_value,
    ROUND(t4.g02, 2) n_zrtq,
    ROUND(t1.g02 - t4.g02, 2) n_tb,
    ROUND(t2.g02_max, 2) n_max,
    ROUND(t2.g02_min, 2) n_min,
    ROUND(t2.g02_avg, 2) n_avg,
    ROUND(t2.g02_vib, 2) n_vib,
    ROUND(t3.g02_max, 2) y_max,
    ROUND(t3.g02_min, 2) y_min,
    ROUND(t3.g02_avg, 2) y_avg,
    ROUND(t3.g02_vib, 2) y_vib,
    t5.warn
FROM
    (SELECT 
        local_id, local_name, update_time, g02
    FROM
        t_data_pipe
    WHERE
        local_id IN (SELECT 
                local_id
            FROM
                t_local_signal
            WHERE
                field = 'g02')and local_id in (select local_id from t_local where is_show = '1')) t1
        LEFT JOIN
    (SELECT 
        local_id,
            MAX(g02) g02_max,
            MIN(g02) g02_min,
            AVG(g02) g02_avg,
            MAX(g02) - MIN(g02) g02_vib
    FROM
        t_data_pipe_his
    WHERE
        update_time >= DATE(NOW())
            AND local_id IN (SELECT 
                local_id
            FROM
                t_local_signal
            WHERE
                field = 'g02') group by local_id) t2 ON t1.local_id = t2.local_id
        LEFT JOIN
    (SELECT 
        local_id, g02_max, g02_min, g02_avg, g02_vib
    FROM
        t_static_pipe
    WHERE
        date_time = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY), '%Y-%m-%d')
            AND local_id IN (SELECT 
                local_id
            FROM
                t_local_signal
            WHERE
                field = 'g02')) t3 ON t1.local_id = t3.local_id
        LEFT JOIN
    (SELECT 
        n.local_id, n.g02
    FROM
        t_data_pipe_his n, (SELECT 
        local_id,tq_time
    FROM
        temp_zrtq
    ) m
    WHERE
        n.update_time = m.tq_time 
            AND n.local_id = m.local_id) t4 ON t1.local_id = t4.local_id 
            left join (
            select local_id,count(*) warn from t_warn_data where warn_status = '0' and warn_type= '10' group by local_id) t5 on  t1.local_id = t5.local_id
            order by time desc;
            end if;
            
   
	if 	paraField = 'g11' then 
   SELECT 
    t1.local_id id,
    t1.local_name name,
    DATE_FORMAT(t1.update_time, '%m-%d %H:%i:%s') time,
    ROUND(t1.g11, 2) n_value,
    ROUND(t4.g11, 0) n_zrtq,
    ROUND(t1.g11 - t4.g11, 0) n_tb,
    ROUND(t2.g11_vib, 0) n_vib,
    ROUND(t3.g11_night, 0) n_night,
    ROUND(t2.g10_day, 0) n_lj_value,
    ROUND(t5.n_lj_month, 0) n_lj_month,
    ROUND(t6.g11_vib, 0) y_vib,
    ROUND(t6.g11_night, 0) y_night,
    ROUND(t6.g10_day, 0) y_lj_value,
    t7.warn
FROM
    (SELECT 
        local_id, local_name, update_time, g11
    FROM
        t_data_pipe
    WHERE
        local_id IN (SELECT DISTINCT
                local_id
            FROM
                t_local_signal
            WHERE
                field IN ('g11' , 'g10'))and local_id in (select local_id from t_local where is_show = '1')) t1
        LEFT JOIN
    (SELECT 
        local_id,
            MAX(g10) - MIN(g10) g10_day,
            MAX(g11) - MIN(g11) g11_vib
    FROM
        t_data_pipe_his
    WHERE
        update_time >= DATE(NOW())
            AND local_id IN (SELECT DISTINCT
                local_id
            FROM
                t_local_signal
            WHERE
                field IN ('g11' , 'g10'))
    GROUP BY local_id) t2 ON t1.local_id = t2.local_id
        LEFT JOIN
    (SELECT 
        local_id, MAX(g10)-MIN(g10) g11_night
    FROM
        t_data_pipe_his
    WHERE
        local_id IN (SELECT 
                local_id
            FROM
                t_local_signal
            WHERE
                field = 'g11')
            AND update_time >= concat(date_format(date(now()),'%Y-%m-%d'),' 01:30:00')
            AND update_time <= concat(date_format(date(now()),'%Y-%m-%d'),' 04:00:00')
    GROUP BY local_id) t3 ON t1.local_id = t3.local_id
        LEFT JOIN
    (SELECT 
        n.local_id, n.g11
    FROM
        t_data_pipe_his n, (SELECT 
        local_id,tq_time
    FROM
        temp_zrtq
    ) m
    WHERE
        n.update_time = m.tq_time 
            AND n.local_id = m.local_id) t4 ON t1.local_id = t4.local_id
        LEFT JOIN
    (SELECT 
        local_id, max(g10) - min(g10) n_lj_month 
    FROM
        t_data_pipe_his 
    WHERE
        g10 <>0 and
        update_time >= concat(DATE_FORMAT(NOW(), '%Y-%m-01'))
            AND local_id IN (SELECT 
                local_id
            FROM
                t_local_signal
            WHERE
                field = 'g10')
    GROUP BY local_id) t5 ON t1.local_id = t5.local_id
        LEFT JOIN
    (SELECT 
        local_id, g11_vib, g11_night, g10_day
    FROM
        t_static_pipe
    WHERE
        date_time = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY), '%Y-%m-%d')
            AND local_id IN (SELECT 
                local_id
            FROM
                t_local_signal
            WHERE
                field IN ('g11' , 'g10'))) t6 ON t1.local_id = t6.local_id left join (
            select local_id,count(*) warn from t_warn_data where warn_status = '0' and warn_from= '1' group by local_id) t7 on  t1.local_id = t7.local_id
            order by time desc;
    
    end if;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
