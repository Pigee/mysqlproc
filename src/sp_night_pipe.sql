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

-- 导出  过程 fh_xydd.sp_night_pipe 结构
DROP PROCEDURE IF EXISTS `sp_night_pipe`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_night_pipe`(localId varchar(36) charset gbk,paraDate varchar(36) charset gbk,xCode varchar(20) charset gbk,paraInter varchar(20) charset gbk,paraAd varchar(20) charset gbk)
BEGIN
declare initDate varchar(36) charset gbk;
declare querystr varchar(1000) charset gbk;
declare s1 int;
declare dcount int;

 declare datecur cursor for select distinct(date(update_time)) from t_hour_col where date_format(update_time,'%Y-%m') = date_format(paraDate,'%Y-%m');

drop temporary table if exists temp_night;
create temporary table temp_night(datecol varchar(36) charset gbk,valuecol varchar(36) charset gbk,timecol varchar(36) charset gbk);
drop temporary table if exists temp_night_prt;
create temporary table temp_night_prt(datecol varchar(36) charset gbk,valuecol varchar(36) charset gbk,timecol varchar(36) charset gbk);

set initDate = paraDate;

set s1 = 0;
open datecur;
while s1 < 31 do

fetch datecur into initDate;
insert into temp_night(datecol) select initDate;
set querystr = concat('update  temp_night t1,(select round(AVG(',xCode,'),2)',xCode,',update_time from t_data_pipe_his where update_time >=\'',initDate,'\' and update_time < \'',initDate,' 23:57:00\'  and local_id= \'',localId,'\' group by  (time_to_sec(update_time) DIV (',paraInter,'*60)) order by ',xCode,' ',paraAd,' limit 1) t2 set t1.valuecol = t2.',xCode,',t1.timecol = t2.update_time where t1.datecol = \'',initDate,'\'');
set @myquery = querystr;
prepare stmt from @myquery;
execute stmt; 
set initDate = date_add(initDate,interval 1 day);
set s1 = s1 + 1; 
end while;

insert into temp_night_prt(datecol) values ('最大值');
insert into temp_night_prt(datecol) values ('最大日期');
insert into temp_night_prt(datecol) values ('最小值');
insert into temp_night_prt(datecol) values ('最小日期');
insert into temp_night_prt(datecol) values ('平均值');

update temp_night_prt t1,(select valuecol,datecol from temp_night order by valuecol*1 desc limit 1) t2 set t1.valuecol = t2.valuecol where t1.datecol = '最大值';
update temp_night_prt t1,(select valuecol,datecol from temp_night order by valuecol*1 desc limit 1) t2 set t1.valuecol = t2.datecol where t1.datecol = '最大日期';
update temp_night_prt t1,(select valuecol,datecol from temp_night where valuecol is not null order by valuecol*1 asc limit 1) t2 set t1.valuecol = t2.valuecol where t1.datecol = '最小值';
update temp_night_prt t1,(select valuecol,datecol from temp_night  where valuecol is not null order by valuecol*1 asc limit 1) t2 set t1.valuecol = t2.datecol where t1.datecol = '最小日期';
update temp_night_prt t1,(select round(avg(valuecol),2) valuecol from temp_night) t2 set t1.valuecol = t2.valuecol where t1.datecol = '平均值';

insert into temp_night_prt select * from temp_night; 
update temp_night_prt set timecol = concat(date_format(timecol,'%H:%i'),'~',date_format(date_add(timecol,interval paraInter minute),'%H:%i'));

SELECT 
    *
FROM
    temp_night_prt;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
