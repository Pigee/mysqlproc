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

-- 导出  过程 fh_xydd.sp_update_static 结构
DROP PROCEDURE IF EXISTS `sp_update_static`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_update_static`()
BEGIN

declare localid varchar(36) charset gbk;
declare datime varchar(36) charset gbk;
declare col    varchar(12) charset gbk;
declare r_count int;
declare s1 int;
declare lotype varchar(12);
declare mystr varchar(2000);
declare staticur cursor for select local_id,date_time,colname from t_static_data where date_format(date_time,'%Y-%m-d%') = date_format(now(),'%Y-%m-d%');

SELECT 
    COUNT(*)
INTO r_count FROM
    t_static_data
WHERE
    DATE_FORMAT(date_time, '%Y-%m-d%') = DATE_FORMAT(now(), '%Y-%m-d%');
open staticur;
set s1 = 1;
while s1 < r_count + 1 do
fetch staticur into localid,datime,col;
SELECT 
    local_type
INTO lotype FROM
    t_local
WHERE
    local_id = localid;

if lotype = '1' then
   set mystr = concat('UPDATE t_static_data m,
    (SELECT 
        t1.local_id,
            t1.',col,' max,
            t1.update_time maxtime,
            t2.',col,' min,
            t2.update_time mintime,
            t3.',col,' avgvalue
    FROM
        (SELECT 
        local_id,',col,', update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = \'',localid,'\'
            AND date_format(update_time,\'%Y-%m-%d\') like date_format(now(),\'%Y-%m-%d\')
    ORDER BY ',col,' DESC
    LIMIT 0 , 1) t1
    LEFT JOIN (SELECT 
        local_id, ',col,', update_time
    FROM
        t_data_imp_his
    WHERE
        local_id = \'',localid,'\'
            AND date_format(update_time,\'%Y-%m-%d\') like date_format(now(),\'%Y-%m-%d\')
    ORDER BY ',col,' ASC
    LIMIT 0 , 1) t2 ON t1.local_id = t2.local_id
    LEFT JOIN (SELECT 
        local_id, truncate(AVG(',col,'),2)',col,'
    FROM
        t_data_imp_his
    WHERE
        local_id = \'',localid,'\'
            AND date_format(update_time,\'%Y-%m-%d\') like date_format(now(),\'%Y-%m-%d\')) t3 ON t1.local_id = t3.local_id) n 
SET 
    m.maxvale = n.max,
    m.maxtime = n.maxtime,
    m.minvalue = n.min,
    m.mintime = n.mintime,
    m.avgvalue = n.avgvalue
WHERE
    m.local_id = \'',localid,'\'
        AND m.colname = \'',col,'\'
        AND DATE_FORMAT(m.date_time, \'%Y-%M-%d\') = DATE_FORMAT(NOW(), \'%Y-%M-%d\')');
set @myquery = mystr;
prepare stmt from @myquery;
execute stmt;

END IF;

if lotype = '2' then

set mystr = concat('UPDATE t_static_data m,
    (SELECT 
        t1.local_id,
            t1.',col,' max,
            t1.update_time maxtime,
            t2.',col,' min,
            t2.update_time mintime,
            t3.',col,' avgvalue
    FROM
        (SELECT 
        local_id,',col,', update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = \'',localid,'\'
            AND date_format(update_time,\'%Y-%m-%d\') like date_format(now(),\'%Y-%m-%d\')
    ORDER BY ',col,' DESC
    LIMIT 0 , 1) t1
    LEFT JOIN (SELECT 
        local_id, ',col,', update_time
    FROM
        t_data_exp_his
    WHERE
        local_id = \'',localid,'\'
            AND date_format(update_time,\'%Y-%m-%d\') like date_format(now(),\'%Y-%m-%d\')
    ORDER BY ',col,' ASC
    LIMIT 0 , 1) t2 ON t1.local_id = t2.local_id
    LEFT JOIN (SELECT 
        local_id, truncate(AVG(',col,'),2) ',col,'
    FROM
        t_data_exp_his
    WHERE
        local_id = \'',localid,'\'
            AND date_format(update_time,\'%Y-%m-%d\') like date_format(now(),\'%Y-%m-%d\')) t3 ON t1.local_id = t3.local_id) n 
SET 
    m.maxvale = n.max,
    m.maxtime = n.maxtime,
    m.minvalue = n.min,
    m.mintime = n.mintime,
    m.avgvalue = n.avgvalue
WHERE
    m.local_id = \'',localid,'\'
        AND m.colname = \'',col,'\'
        AND DATE_FORMAT(m.date_time, \'%Y-%M-%d\') = DATE_FORMAT(NOW(), \'%Y-%M-%d\')');
set @myquery = mystr;
prepare stmt from @myquery;
execute stmt;
end if;
set s1 = s1 + 1;
end while;
close staticur;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
