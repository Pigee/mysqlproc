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

-- 导出  过程 fh_xydd.sp_month_night 结构
DROP PROCEDURE IF EXISTS `sp_month_night`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_month_night`(`localId` varchar(36) charset gbk,  `yearMo` varchar(36) charset gbk,paraCode varchar(20))
BEGIN
--  管网夜间流量 
declare localCol varchar(12) charset gbk;
declare initdate date;
declare s1 int;
declare day_count int;
declare monstr varchar(2000) charset gbk;
-- declare secstr varchar(2000) charset gbk;
-- declare colcur cursor for select distinct colname from t_static_pipe where local_id = localId and date_format(date_time,'%Y-%m') = date_format(yearMo,'%Y-%m');


drop  table if exists  temp_month;
create temporary table temp_month(montime varchar(36),colvalue varchar(36));


insert into temp_month(montime) values ('最大值');
insert into temp_month(montime) values ('最大时间');
insert into temp_month(montime) values ('最小值');
insert into temp_month(montime) values ('最小时间');
insert into temp_month(montime) values ('月合计');
insert into temp_month(montime) values ('日平均');

SELECT 
    TIMESTAMPDIFF(DAY,
        yearMo,
        (DATE_ADD(yearMo, INTERVAL 1 MONTH)))
INTO day_count;


set monstr = concat('update temp_month m, (select ',paraCode,' maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_time >= \'',yearMo,'\' and date_time <= DATE_ADD(\'',yearMo,'\', INTERVAL 1 MONTH) and ',paraCode,' is not null order by maxv desc limit 1)n set m.colvalue = round(n.maxv,1) where m.montime = \'最大值\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;

set monstr = concat('update temp_month m, (select ',paraCode,' maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_time >= \'',yearMo,'\' and date_time <= DATE_ADD(\'',yearMo,'\', INTERVAL 1 MONTH) and ',paraCode,' is not null order by maxv desc limit 1)n set m.colvalue = n.date_time where m.montime = \'最大时间\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;

set monstr = concat('update temp_month m, (select ',paraCode,' maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_time >= \'',yearMo,'\' and date_time <= DATE_ADD(\'',yearMo,'\', INTERVAL 1 MONTH) and ',paraCode,' is not null order by maxv asc limit 1)n set m.colvalue = round(n.maxv,1) where m.montime = \'最小值\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;

set monstr = concat('update temp_month m, (select ',paraCode,' maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_time >= \'',yearMo,'\' and date_time <= DATE_ADD(\'',yearMo,'\', INTERVAL 1 MONTH) and ',paraCode,' is not null order by maxv asc limit 1)n set m.colvalue = n.date_time where m.montime = \'最小时间\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;

set monstr = concat('update temp_month m, (select sum(',paraCode,') maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_time >= \'',yearMo,'\' and date_time <= DATE_ADD(\'',yearMo,'\', INTERVAL 1 MONTH) order by maxv asc limit 1)n set m.colvalue = round(n.maxv,1) where m.montime = \'月合计\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;

set monstr = concat('update temp_month m, (select avg(',paraCode,') maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_time >= \'',yearMo,'\' and date_time <= DATE_ADD(\'',yearMo,'\', INTERVAL 1 MONTH) order by maxv asc limit 1)n set m.colvalue = round(n.maxv,1) where m.montime = \'日平均\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
########################################
set s1 = 0;
set initDate = yearMo;
while s1 < day_count do
insert into temp_month(montime) select initDate;

set monstr = concat('update temp_month m, (select ',paraCode,' maxv  from t_static_pipe where local_id = \'',localId,'\' and date_time = \'',initDate,'\')n set m.colvalue = round(n.maxv,1) where m.montime = \'',initDate,'\'');
 set @myquery = monstr;
prepare stmt from @myquery;
execute stmt; 
set s1 = s1 + 1;
set initDate = date_add(initDate,interval 1 day);
end while;


 

select montime,colvalue from temp_month;
/* 
SELECT 
    COUNT(DISTINCT colname)
INTO col_count FROM
    t_static_pipe
WHERE
    local_id = localId
        AND DATE_FORMAT(date_time, '%Y-%m') = DATE_FORMAT(yearMo, '%Y-%m');
        
set secstr = 'select montime ,';
if col_count > 0 then 
set s1 = 1;
open colcur;

set monstr = concat('update temp_month m, (select ',paraCode,' maxv,date_time from t_static_pipe where local_id = \'',localId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',yearMo,'\',\'%Y-%m\'))n set m.colvalue = n.maxv where m.montime = n.date_time');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;


while s1 < col_count + 1 do
fetch  colcur into localCol;
set monstr = concat('alter table temp_month add ',localCol,' varchar(12) charset gbk;');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt;

set monstr = concat('update temp_month m, (
 SELECT date_time, avgvalue FROM t_static_pipe WHERE local_id = \'',localId,'\' AND colname = \'',localCol,'\' AND DATE_FORMAT(date_time, \'%Y-%m\') = DATE_FORMAT(\'',yearMo,'\', \'%Y-%m\'))n set m.',localCol,' = n.avgvalue where m.montime = n.date_time');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt; 

set monstr = concat('update temp_month m, (
 select max(avgvalue*1) avgvalue from t_static_pipe where colname = \'',localCol,'\' and local_id = \'',localId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',yearMo,'\',\'%Y-%m\'))n set m.',localCol,' = n.avgvalue where m.montime = \'最大值\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt; 


set monstr = concat('update temp_month m, (
 select date_time avgvalue from t_static_pipe where colname = \'',localCol,'\' and local_id = \'',localId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',yearMo,'\',\'%Y-%m\') order by \'',localCol,'\'*1 desc limit 0,1)n set m.',localCol,' = n.avgvalue where m.montime = \'最大时间\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt;


set monstr = concat('update temp_month m, (
 select min(avgvalue*1) avgvalue from t_static_pipe where colname = \'',localCol,'\' and local_id = \'',localId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',yearMo,'\',\'%Y-%m\'))n set m.',localCol,' = n.avgvalue where m.montime = \'最小值\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt;


set monstr = concat('update temp_month m, (
 select date_time avgvalue from t_static_pipe where colname = \'',localCol,'\' and local_id = \'',localId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',yearMo,'\',\'%Y-%m\') order by \'',localCol,'\'*1 asc limit 0,1)n set m.',localCol,' = n.avgvalue where m.montime = \'最小时间\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt;


set monstr = concat('update temp_month m, (
 select truncate(avg(avgvalue),2) avgvalue from t_static_pipe where colname = \'',localCol,'\' and local_id = \'',localId,'\' and date_format(date_time,\'%Y-%m\') = date_format(\'',yearMo,'\',\'%Y-%m\'))n set m.',localCol,' = n.avgvalue where m.montime = \'平均值\'');
set @myquery = monstr;
prepare stmt from @myquery;
execute stmt;
deallocate prepare stmt;
set secstr = concat(secstr,localCol,',');
set s1 = s1 + 1;

end while;
close colcur;
end if; 

set secstr = concat(substring(secstr,1,length(secstr)-1),' from temp_month;');



set @myquery = secstr;
prepare stmt from @myquery;
execute stmt;  */

end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
