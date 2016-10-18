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

-- 导出  过程 fh_xydd.sp_xy_expday 结构
DROP PROCEDURE IF EXISTS `sp_xy_expday`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_xy_expday`(paraId varchar(36),paraDate varchar(36))
BEGIN
declare initDate datetime;
declare i,p_count int;
declare pumpId varchar(36);
declare queryStr varchar(2000);
declare pump_cur cursor for select pump_id from t_data_pump where local_id = paraId;
select count(pump_id) into p_count from t_data_pump where local_id = paraId;


drop temporary table if exists temp_expday;
create temporary table temp_expday(timecol varchar(36));



set i = 1;
set initDate = paraDate;
while i <= 24 do

insert into temp_expday select initDate;
set initDate = date_add(initDate,interval 1 hour);
set i = i + 1;
end while;


open pump_cur;
set i = 1;
while i <= p_count do
fetch pump_cur into pumpId;

set querystr = concat('alter table temp_expday add l',i,' varchar(12)');
set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt;


set queryStr = concat('update temp_expday t1,(select update_time,avg(x036) x036_avg from  t_data_pump_his where pump_id = \'',pumpId,'\' and update_time >= \'',paraDate,'\' and  update_time <= date_add(\'',paraDate,'\',interval 1 day)  group by hour(update_time))t2 set t1.l',i,' = round(t2.x036_avg,2) where t1.timecol = t2.update_time');

 set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt; 
set i = i + 1;
end while;

alter table temp_expday add x121_avg varchar(12);
alter table temp_expday add x122_sum varchar(12);
alter table temp_expday add x221_avg varchar(12);
alter table temp_expday add x222_sum varchar(12);
alter table temp_expday add x065_avg varchar(12);
alter table temp_expday add x075_avg varchar(12);
alter table temp_expday add x061_avg varchar(12);
alter table temp_expday add x062_avg varchar(12);
alter table temp_expday add x024_avg varchar(12);
alter table temp_expday add x023_avg varchar(12);

UPDATE temp_expday t1,
    (SELECT 
        update_time,
            AVG(m.x121) x121_avg,
            max(m.x122)-min(m.x122) x122_sum,
            AVG(m.x221) x221_avg,
            max(m.x222)-min(m.x222) x222_sum,
            avg(m.x065) x065_avg,
            avg(m.x075) x075_avg,
            avg(m.x061) x061_avg,
            avg(m.x062) x062_avg,
            avg(m.x024) x024_avg,
            avg(m.x023) x023_avg
    FROM (select update_time,x121,x122,x221,x222,x065,x075,x061,x062,x024,x023 from 
        t_data_exp_his
    WHERE
        local_id = paraId
            AND update_time >= paraDate
            AND update_time <= DATE_ADD(paraDate, INTERVAL 1 DAY) union all 
            select date_sub(update_time,interval 3 minute) update_time,x121,x122,x221,x222,x065,x075,x061,x062,x024,x023 from 
        t_data_exp_his
    WHERE
        local_id = paraId
            AND update_time > paraDate
            AND update_time <= DATE_ADD(paraDate, INTERVAL 1 DAY) and minute(update_time) = 0) m where m.x122 <>0 and m.x222 <> 0
    GROUP BY HOUR(m.update_time)) t2 
SET 
    t1.x121_avg = round(t2.x121_avg,2),
    t1.x122_sum = round(t2.x122_sum,2),
    t1.x221_avg = round(t2.x121_avg,2),
    t1.x222_sum = round(t2.x222_sum,2),
    t1.x065_avg = round(t2.x065_avg,2),
    t1.x075_avg = round(t2.x075_avg,2),
    t1.x061_avg = round(t2.x061_avg,2),
    t1.x062_avg = round(t2.x062_avg,2),
    t1.x024_avg = round(t2.x024_avg,2),
    t1.x023_avg = round(t2.x023_avg,2)
    
WHERE
    t1.timecol = t2.update_time;
    
update temp_expday set timecol = concat(date_format(timecol,'%Y-%m-%d %H:%i'),'-',date_format(date_add(timecol,interval 1 hour),'%H:%i'));

if p_count = 5 then
select timecol,l1,l2,l3,l4,l5,x121_avg,x122_sum,x221_avg,x222_sum,x065_avg,x075_avg,x061_avg,x062_avg,x024_avg,x023_avg from temp_expday;
end if;
if p_count = 6 then
select timecol,l1,l2,l3,l4,l5,l6,x121_avg,x122_sum,x221_avg,x222_sum,x065_avg,x075_avg,x061_avg,x062_avg,x024_avg,x023_avg from temp_expday;
end if;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
