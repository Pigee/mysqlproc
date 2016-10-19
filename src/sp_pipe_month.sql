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

-- 导出  过程 fh_xydd.sp_pipe_month 结构
DROP PROCEDURE IF EXISTS `sp_pipe_month`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pipe_month`(paraId varchar(36) charset gbk,paraCode varchar(12) charset gbk,paraCode2 varchar(30) charset gbk,paraDate varchar(30) charset gbk)
BEGIN

declare pipeQuery varchar(500) charset gbk;

drop temporary table if exists pipemonth;
create temporary table pipemonth(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk,hourcol varchar(30) charset gbk);

insert into pipemonth(timecol) values ('最大值');
insert into pipemonth(timecol) values ('最大时间');
insert into pipemonth(timecol) values ('最小值');
insert into pipemonth(timecol) values ('最小时间');
insert into pipemonth(timecol) values ('平均值');

set pipeQuery = concat('update pipemonth t1, (select max(',paraCode,') ',paraCode,' from t_static_pipe where local_id = \'',paraId,'\' and date_format(date_time,\'%Y-%m\') =\'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,' where timecol = \'最大值\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

set pipeQuery = concat('update pipemonth t1, (select date_time  from t_static_pipe where local_id = \'',paraId,'\' and date_format(date_time,\'%Y-%m\') = \'',paraDate,'\' and ',paraCode,' is not null order by ',paraCode,' desc limit 1) t2 set t1.valuecol = t2.date_time where timecol = \'最大时间\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

set pipeQuery = concat('update pipemonth t1, (select min(',paraCode,') ',paraCode,' from t_static_pipe where local_id = \'',paraId,'\' and date_format(date_time,\'%Y-%m\') =\'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,' where timecol = \'最小值\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 

set pipeQuery = concat('update pipemonth t1, (select date_time  from t_static_pipe where local_id = \'',paraId,'\' and date_format(date_time,\'%Y-%m\') = \'',paraDate,'\' and ',paraCode,' is not null order by ',paraCode,' asc limit 1) t2 set t1.valuecol = t2.date_time where timecol = \'最小时间\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery; 
execute stmt; 


set pipeQuery = concat('update pipemonth t1, (select round(avg(',paraCode,'),3) ',paraCode,' from t_static_pipe where local_id = \'',paraId,'\' and date_format(date_time,\'%Y-%m\') = \'',paraDate,'\') t2 set t1.valuecol = t2.',paraCode,' where timecol = \'平均值\';');  
set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 


insert into pipemonth(timecol) SELECT 
date_field
FROM
(SELECT 
MAKEDATE(YEAR(concat(paraDate,'-01')), 1) + INTERVAL (MONTH(concat(paraDate,'-01')) - 1) MONTH + INTERVAL daynum DAY date_field
FROM
(SELECT 
t * 10 + u daynum
FROM
(SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A, (SELECT 0 u UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) B
ORDER BY daynum) AA) AAA
WHERE
MONTH(date_field) = MONTH(concat(paraDate,'-01')) order by date_field;


set pipeQuery = concat('update pipemonth t1, (select date_time,',paraCode,',',paraCode2,' from t_static_pipe where date_format(date_time,\'%Y-%m\') = \'',paraDate,'\' and local_id = \'',paraId,'\')t2 set t1.valuecol = t2.',paraCode,', t1.hourcol = t2.',paraCode2,' where t1.timecol = t2.date_time');  

if paraCode2 = 'avg' then
set pipeQuery = concat('update pipemonth t1, (select date_time,',paraCode,' from t_static_pipe where date_format(date_time,\'%Y-%m\') = \'',paraDate,'\' and local_id = \'',paraId,'\')t2 set t1.valuecol = t2.',paraCode,' where t1.timecol = t2.date_time');  
end if;

set @myquery = pipeQuery;
prepare stmt from @myquery;
execute stmt; 
if paraCode2 = 'avg' then
select timecol,valuecol from pipemonth;
end if;

if paraCode2 != 'avg' then
select timecol,valuecol,concat(date_format(hourcol,'%H:%i'),'~',date_format(date_add(hourcol,interval 1 hour),'%H:%i')) hourcol from pipemonth;

end if;
end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
