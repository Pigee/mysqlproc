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

-- 导出  过程 fh_xydd.sp_xy_impday 结构
DROP PROCEDURE IF EXISTS `sp_xy_impday`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_xy_impday`(paraId varchar(36),paraDate varchar(36))
BEGIN


declare initDate datetime;
declare i,p_count int;
declare pumpId varchar(36);
declare queryStr varchar(2000);
declare pump_cur cursor for select pump_id from t_data_pump where local_id = paraId;
select count(pump_id) into p_count from t_data_pump where local_id = paraId;


drop temporary table if exists temp_impday;
create temporary table temp_impday(timecol varchar(36));



set i = 1;
set initDate = paraDate;
while i <= 24 do

insert into temp_impday select initDate;
set initDate = date_add(initDate,interval 1 hour);
set i = i + 1;
end while;


open pump_cur;
set i = 1;
while i <= p_count do
fetch pump_cur into pumpId;

set querystr = concat('alter table temp_impday add l',i,' varchar(12)');
set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt;

set querystr = concat('alter table temp_impday add d',i,' varchar(12)');
set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt;

set queryStr = concat('update temp_impday t1,(select m.update_time,avg(m.x036) x036_avg,max(m.x033)-min(m.x033) x033_sum from (select update_time,x036,x033 from t_data_pump_his where pump_id = \'',pumpId,'\' and update_time >= \'',paraDate,'\' and  update_time <= date_add(\'',paraDate,'\',interval 1 day) union all select date_sub(update_time,interval 3 minute) update_time,x036,x033 from t_data_pump_his where pump_id = \'',pumpId,'\' and update_time > \'',paraDate,'\' and  update_time <= date_add(\'',paraDate,'\',interval 1 day) and minute(update_time) = 0) m where m.x033 <> 0 group by hour(m.update_time))t2 set t1.l',i,' = round(t2.x036_avg,2),t1.d',i,' = round(t2.x033_sum,2) where t1.timecol = t2.update_time');

 set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt; 
set i = i + 1;
end while;

alter table temp_impday add x043_avg varchar(12);
alter table temp_impday add x046_avg varchar(12);
alter table temp_impday add x023_avg varchar(12);
alter table temp_impday add x124_avg varchar(12);

UPDATE temp_impday t1,
    (SELECT 
        update_time,
            AVG(x043) x043_avg,
            AVG(x046) x046_avg,
            AVG(x023) x023_avg,
            AVG(x124) x124_avg
    FROM
        t_data_imp_his
    WHERE
        local_id = paraId
            AND update_time >= paraDate
            AND update_time <= DATE_ADD(paraDate, INTERVAL 1 DAY)
    GROUP BY HOUR(update_time)) t2 
SET 
    t1.x043_avg = round(t2.x043_avg,2),
    t1.x046_avg = round(t2.x046_avg,2),
    t1.x023_avg = round(t2.x023_avg,2),
    t1.x124_avg = round(t2.x124_avg,2)
WHERE
    t1.timecol = t2.update_time ;

update temp_impday set timecol = concat(date_format(timecol,'%Y-%m-%d %H:%i'),'-',date_format(date_add(timecol,interval 1 hour),'%H:%i'));

if p_count = 4 then
select timecol,l1,d1,l2,d2,l3,d3,l4,d4,x043_avg,x046_avg,x023_avg,x124_avg from temp_impday;
end if;
if p_count = 5 then
select timecol,l1,d1,l2,d2,l3,d3,l4,d4,l5,d5,x043_avg,x046_avg,x023_avg,x124_avg from temp_impday;
end if;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
