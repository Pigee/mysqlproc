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

-- 导出  过程 fh_xydd.sp_pumproom_xyday 结构
DROP PROCEDURE IF EXISTS `sp_pumproom_xyday`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pumproom_xyday`(paraId varchar(36) charset gbk,paraDate varchar(30) charset gbk)
BEGIN

declare iniTime datetime;
declare s1,p_count int;
declare pumpId varchar(36);
declare queryStr varchar(500);
declare pump_cur cursor for select pump_id from t_data_pump where local_id = paraId;

drop temporary table if exists temp_pumproom_his;
CREATE temporary TABLE temp_pumproom_his AS SELECT * FROM
    t_data_pumproom_his
WHERE
    update_time >= paraDate
        AND update_time <= date_add(paraDate,interval 1 day) and local_id = paraId; 


drop temporary table if exists temp_pumproom_day;
create temporary table temp_pumproom_day(timecol varchar(36) charset gbk,x025_avg double,x033_sum double);

set iniTime = paraDate;
set s1 = 1;
while s1 <= 24 do
insert into temp_pumproom_day(timecol) select iniTime;
update temp_pumproom_day set x033_sum = (select round(max(x033)-min(x033),2) from temp_pumproom_his where  update_time >= iniTime and update_time <= date_add(iniTime,interval 1 hour)) where timecol = iniTime;
set s1 = s1 + 1;
set iniTime = date_add(iniTime,interval 1 hour);
end while;

update temp_pumproom_day t1,(select  date_format(update_time,'%Y-%m-%d %H:00:00') update_time,avg(x025) x025_avg from temp_pumproom_his where  update_time >= paraDate and update_time <= date_add(paraDate,interval 1 day) group by hour(update_time)) t2 set t1.x025_avg = round(t2.x025_avg,2) where date_format(t1.timecol,'%Y-%m-%d %H:%i:%s') = t2.update_time;



select count(pump_id) into p_count from t_data_pump where local_id = paraId;
open  pump_cur;
set s1 = 1;
while s1 <= p_count do
  fetch pump_cur into pumpId;
  set querystr = concat('alter table temp_pumproom_day add p',s1,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;

  set querystr = concat('update temp_pumproom_day t1,(select max(x042) x042_max,date_format(update_time,\'%Y-%m-%d %H:00:00\') update_time from t_data_pump_his where pump_id = \'',pumpId,'\' and update_time >= \'',paraDate,'\' AND update_time <= date_add(\'',paraDate,'\',interval 1 day) group by hour(update_time))t2 set t1.p',s1,' = t2.x042_max where date_format(t1.timecol,\'%Y-%m-%d %H:%i:%s\') = t2.update_time');
   set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  set s1 = s1 + 1;
end while;

update temp_pumproom_day set timecol = concat(date_format(timecol,'%Y-%m-%d %H:%i'),'-',date_format(date_add(timecol,interval 1 hour),'%H:%i'));

insert into temp_pumproom_day(timecol,x025_avg,x033_sum) select '合计/平均',round(avg(x025),2),round(max(x033)-min(x033),2) from temp_pumproom_his;


if p_count = 1 then
select timecol,x025_avg,x033_sum,p1 from temp_pumproom_day;
end if;

if p_count = 2 then
select timecol,x025_avg,x033_sum,p1,p2 from temp_pumproom_day;
end if;

if p_count = 3 then
select timecol,x025_avg,x033_sum,p1,p2,p3 from temp_pumproom_day;
end if;

if p_count = 4 then
select timecol,x025_avg,x033_sum,p1,p2,p3,p4 from temp_pumproom_day;
end if;

if  p_count = 5 then
select timecol,x025_avg,x033_sum,p1,p2,p3,p4,p5 from temp_pumproom_day;
end if;

if  p_count = 6 then
select timecol,x025_avg,x033_sum,p1,p2,p3,p4,p5,p6 from temp_pumproom_day;
end if;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
