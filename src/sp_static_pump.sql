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

-- 导出  过程 fh_xydd.sp_static_pump 结构
DROP PROCEDURE IF EXISTS `sp_static_pump`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_static_pump`()
BEGIN

drop table if exists temp_pump_his;
CREATE TABLE temp_pump_his AS SELECT * FROM
    t_data_pump_his
WHERE
    update_time >= DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))
        AND update_time <= DATE(NOW()); 

insert into t_static_pump(data_id,pump_id,local_id,pump_name,date_time) select uuid(),pump_id,local_id,pump_name,date_format(date_sub(now(),interval 1 day),'%Y-%m-%d') from t_data_pump;

begin
declare paraPumpId varchar(36) charset gbk;
declare p_count int;
declare s1 int;

declare pump_cur cursor for select pump_id from t_static_pump where date_time = date(date_sub(now(),interval 1 day));

SELECT 
    COUNT(*)
INTO p_count FROM
    t_static_pump
WHERE
    date_time = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY));
 set s1 = 1;   
 open pump_cur;
   while s1 < p_count + 1 do
  fetch pump_cur into ParaPumpId;
UPDATE t_static_pump t1,
    (SELECT 
        pump_id,SUM(
            CASE x042
                WHEN '0' THEN 0
                ELSE 1
            END )/12 x042_sum,
            max(x033)-min(x033) x033_sum,
            (max(x033)-min(x033))/(sum(
            CASE x042
                WHEN '0' THEN 0
                ELSE 1
            END )/12) x3342_avg
    FROM
        temp_pump_his
    WHERE
        update_time >= DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))
            AND update_time < DATE(NOW())
            AND pump_id = ParaPumpid)t2 
SET 
    t1.x042_sum = round(t2.x042_sum,1),
    t1.x033_sum = round(t2.x033_sum,1),
    t1.x3342_avg = round(t2.x3342_avg,2)
WHERE
    t1.pump_id = ParaPumpId
        AND t1.date_time = DATE_SUB(DATE(NOW()), INTERVAL 1 DAY);

set s1 = s1 + 1;

end while;
    
    end;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
