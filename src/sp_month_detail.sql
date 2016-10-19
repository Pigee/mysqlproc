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

-- 导出  过程 fh_xydd.sp_month_detail 结构
DROP PROCEDURE IF EXISTS `sp_month_detail`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_month_detail`(paraId varchar(36),paraMonth varchar(36),paraCode varchar(20),paraInter varchar(20))
BEGIN
declare md_init int;
declare md_num int;
declare row_num int;
declare date_init datetime;

drop temporary table if exists temp_result_data;
create temporary table temp_result_data(timecol varchar(30));
drop temporary table if exists temp_month_data;
create temporary table temp_month_data as select * from t_data_pipe_his where local_id = paraID and update_time >= paraMonth and update_time <= date_add(paraMonth,interval 1 month);

SELECT 
    CASE paraInter
        WHEN 60 THEN 24
        WHEN 30 THEN 48
        WHEN 10 THEN 144
    END
INTO row_num FROM DUAL;
SELECT 
    TIMESTAMPDIFF(DAY,
        paraMonth,
        (DATE_ADD(paraMonth, INTERVAL 1 MONTH)))
INTO md_num FROM DUAL;

insert into temp_result_data 
select date_format(paraMonth + interval m.rank*paraInter minute,'%H:%i') as update_time from (
select n.rank from ( select 0 as rank union 
SELECT @rownum := @rownum + 1 
FROM t_local t, (SELECT @rownum := 0) r) n where n.rank < row_num) m;
  
set md_init = 0;
set date_init = paraMonth;
while md_init < md_num do
alter table temp_result_data add  md_init double;


set date_init = date_add(date_init,interval 1 day);
set md_init = md_init + 1;
end while;
select md_init;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
