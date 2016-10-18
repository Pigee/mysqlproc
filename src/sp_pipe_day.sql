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

-- 导出  过程 fh_xydd.sp_pipe_day 结构
DROP PROCEDURE IF EXISTS `sp_pipe_day`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pipe_day`(paraId varchar(36) charset gbk,paraCode varchar(12) charset gbk,paraDate varchar(30) charset gbk,paraInter varchar(12) charset gbk)
BEGIN

declare pipeQuery varchar(500) charset gbk;

drop temporary table if exists pipeday;
create temporary table pipeday(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk);

insert into pipeday(timecol) values ('最大值');
insert into pipeday(timecol) values ('最大时间');
insert into pipeday(timecol) values ('最小值');
insert into pipeday(timecol) values ('最小时间');
insert into pipeday(timecol) values ('平均值');

set pipeQuery = concat('update pipeday t1, (select ',paraCode,'_max from t_static_pipe where local_id = \'',paraId,'\' and date_time =\'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,'_max where timecol = \'最大值\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

set pipeQuery = concat('update pipeday t1, (select date_format(',paraCode,'_maxtime,\'%H:%i:%s\') ',paraCode,'_maxtime from t_static_pipe where local_id = \'',paraId,'\' and date_time = \'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,'_maxtime where timecol = \'最大时间\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

set pipeQuery = concat('update pipeday t1, (select ',paraCode,'_min from t_static_pipe where local_id = \'',paraId,'\' and date_time = \'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,'_min where timecol = \'最小值\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

set pipeQuery = concat('update pipeday t1, (select date_format(',paraCode,'_mintime,\'%H:%i:%s\') ',paraCode,'_mintime from t_static_pipe where local_id = \'',paraId,'\' and date_time = \'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,'_mintime where timecol = \'最小时间\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery; 
execute stmt; 

set pipeQuery = concat('update pipeday t1, (select ',paraCode,'_avg from t_static_pipe where local_id = \'',paraId,'\' and date_time = \'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,'_avg where timecol = \'平均值\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

if paraInter = '30' then 
set pipeQuery = concat('insert into pipeday select date_format(update_time,\'%H:%i:%s\'),',paracode,' from t_data_pipe_his where date_format(update_time, \'%Y-%m-%d %i:%s\') in (\'',paraDate,' 00:00\',\'',paraDate,' 30:00\') and local_id = \'',paraId,'\' order by update_time asc');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt;
end if;


if paraInter = '60' then 
set pipeQuery = concat('insert into pipeday select date_format(update_time,\'%H:%i:%s\'),',paracode,' from t_data_pipe_his where date_format(update_time, \'%Y-%m-%d %i:%s\') in (\'',paraDate,' 00:00\') and local_id = \'',paraId,'\' order by update_time asc');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt;
end if;

if paraInter = '120' then 
set pipeQuery = concat('insert into pipeday select date_format(update_time,\'%H:%i:%s\'),',paracode,' from t_data_pipe_his where date_format(update_time, \'%Y-%m-%d %H:%i:%s\') in (\'',paraDate,' 00:00:00\',\'',paraDate,' 02:00:00\',\'',paraDate,' 04:00:00\',\'',paraDate,' 06:00:00\',\'',paraDate,' 08:00:00\',\'',paraDate,' 10:00:00\',\'',paraDate,' 12:00:00\',\'',paraDate,' 14:00:00\',\'',paraDate,' 16:00:00\',\'',paraDate,' 18:00:00\',\'',paraDate,' 20:00:00\',\'',paraDate,' 22:00:00\') and local_id = \'',paraId,'\' order by update_time asc');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt;
end if;


select * from pipeday;

end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
