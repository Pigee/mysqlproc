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

-- 导出  过程 fh_xydd.sp_pumproom_xymonth 结构
DROP PROCEDURE IF EXISTS `sp_pumproom_xymonth`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pumproom_xymonth`(paraId varchar(36),paraDate varchar(36))
BEGIN

declare initDate date;
declare s1,d_count int;
declare i,p_count int;
declare querystr varchar(2000);
declare pumpId varchar(36);
declare  pump_cur cursor for select pump_id from t_data_pump where local_id = paraId order by pump_name asc;

drop temporary table if exists temp_pumproom_month;
create temporary table temp_pumproom_month(datecol varchar(36),x025_avg double,x033_day double);


SELECT 
    TIMESTAMPDIFF(DAY,
        paraDate,
        (DATE_ADD(paraDate, INTERVAL 1 MONTH)))
INTO d_count FROM DUAL;
set initDate = paraDate;
set s1 = 1;
while s1 <= d_count do
insert into temp_pumproom_month(datecol) select initDate;
set s1 = s1 + 1;
set initDate = date_add(initDate,interval 1 day);
end while;


UPDATE temp_pumproom_month t1,
    (SELECT 
        x025_avg, x033_day, date_time
    FROM
        t_static_pumproom
    WHERE
        local_id = paraId
            AND date_time >= paraDate
            AND date_time < DATE_ADD(paraDate, INTERVAL 1 MONTH)) t2 
SET 
    t1.x025_avg = t2.x025_avg,
    t1.x033_day = t2.x033_day
WHERE
    t1.datecol = t2.date_time;


SELECT 
    COUNT(pump_id)
INTO p_count FROM
    t_data_pump
WHERE
    local_id = paraId;
set i = 1;
open  pump_cur;
while i <= p_count do
  fetch pump_cur into pumpId;

  set querystr = concat('alter table temp_pumproom_month add p',i,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  
  set querystr = concat('update temp_pumproom_month t1,(select x042_sum,date_time from t_static_pump where pump_id = \'',pumpId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',paraDate,'\',\'%Y-%m\'))t2 set t1.p',i,' = t2.x042_sum where t1.datecol = t2.date_time');
   set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  set i = i + 1;
end while;
close pump_cur;


insert into temp_pumproom_month(datecol) values('合计/平均');
update temp_pumproom_month t1,(select round(avg(x025_avg),2) x025_avg,sum(x033_day) x033_day from t_static_pumproom
    WHERE
        local_id = paraId
            AND date_time >= paraDate
            AND date_time < DATE_ADD(paraDate, INTERVAL 1 MONTH)) t2 set t1.x025_avg = t2.x025_avg,t1.x033_day = t2.x033_day where t1.datecol = '合计/平均';

set i = 1;
open  pump_cur;
while i <= p_count do
  fetch pump_cur into pumpId;
set querystr = concat('update temp_pumproom_month t1,(select sum(x042_sum) x042_sum from t_static_pump where pump_id = \'',pumpId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',paraDate,'\',\'%Y-%m\'))t2 set t1.p',i,' = t2.x042_sum where t1.datecol = \'合计/平均\'');
   set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  set i = i + 1;
end while;
close pump_cur;



if  p_count = 6 then
select datecol,x025_avg,x033_day,p1,p2,p3,p4,p5,p6 from temp_pumproom_month;
end if;
if p_count = 5 then
select datecol,x025_avg,x033_day,p1,p2,p3,p4,p5 from temp_pumproom_month;
end if; 
if p_count = 4 then
select datecol,x025_avg,x033_day,p1,p2,p3,p4 from temp_pumproom_month;
end if; 
if p_count = 3 then
select datecol,x025_avg,x033_day,p1,p2,p3 from temp_pumproom_month;
end if;
if p_count = 2 then
select datecol,x025_avg,x033_day,p1,p2 from temp_pumproom_month;
end if;
if p_count = 1 then
select datecol,x025_avg,x033_day,p1 from temp_pumproom_month;
end if;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
