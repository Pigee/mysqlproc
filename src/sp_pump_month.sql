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

-- 导出  过程 fh_xydd.sp_pump_month 结构
DROP PROCEDURE IF EXISTS `sp_pump_month`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pump_month`(paraId varchar(36),paraDate varchar(36))
BEGIN

declare initDate date;
declare s1,d_count int;
declare i,p_count int;
declare querystr varchar(2000);
declare pumpId varchar(36);
declare  pump_cur cursor for select pump_id from t_data_pump where local_id = paraId order by pump_name asc;

drop temporary table if exists temp_pump_month;
create temporary table temp_pump_month(datecol varchar(36));


SELECT 
    TIMESTAMPDIFF(DAY,
        paraDate,
        (DATE_ADD(paraDate, INTERVAL 1 MONTH)))
INTO d_count FROM DUAL;

set initDate = paraDate;
set s1 = 1;
while s1 <= d_count do
insert into temp_pump_month select initDate;
set s1 = s1 + 1;
set initDate = date_add(initDate,interval 1 day);
end while;



select count(pump_id) into p_count from t_data_pump where local_id = paraId;
set i = 1;
open  pump_cur;
while i <= p_count do
  fetch pump_cur into pumpId;

  set querystr = concat('alter table temp_pump_month add h',i,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  set querystr = concat('alter table temp_pump_month add e',i,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  set querystr = concat('alter table temp_pump_month add a',i,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  
  set querystr = concat('update temp_pump_month t1,(select x042_sum,x033_sum,x3342_avg,date_time from t_static_pump where pump_id = \'',pumpId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',paraDate,'\',\'%Y-%m\'))t2 set t1.h',i,' = t2.x042_sum,t1.e',i,' =t2.x033_sum,t1.a',i,' = t2.x3342_avg where t1.datecol = t2.date_time');
   set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  set i = i + 1;
end while;

if p_count = 1 then
select datecol,h1,e1,a1 from temp_pump_month;
end if;

if p_count = 2 then
select datecol,h1,h2,e1,e2,a1,a2 from temp_pump_month;
end if;

if p_count = 3 then
select datecol,h1,h2,h3,e1,e2,e3,a1,a2,a3 from temp_pump_month;
end if;

if p_count = 4 then
select datecol,h1,h2,h3,h4,e1,e2,e3,e4,a1,a2,a3,a4 from temp_pump_month;
end if;

if  p_count = 5 then
select datecol,h1,h2,h3,h4,h5,e1,e2,e3,e4,e5,a1,a2,a3,a4,a5 from temp_pump_month;
end if;

if  p_count = 6 then
select datecol,h1,h2,h3,h4,h5,h6,e1,e2,e3,e4,e5,e6,a1,a2,a3,a4,a5,a6 from temp_pump_month;
end if;



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
