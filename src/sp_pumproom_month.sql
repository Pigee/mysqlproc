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

-- 导出  过程 fh_xydd.sp_pumproom_month 结构
DROP PROCEDURE IF EXISTS `sp_pumproom_month`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pumproom_month`(paraId varchar(36) charset gbk,paraCode varchar(12) charset gbk,paraDate varchar(30) charset gbk,paradCounts varchar(12) charset gbk)
BEGIN





declare pumpQuery varchar(500) charset gbk;
declare tbName varchar(36) charset gbk;
declare endDate date;
declare s1 int;


select case local_type when '7' then 't_static_pumproom' else 't_static_pipe' end into tbName from t_local where local_id = paraId; 


drop temporary table if exists pumpmonth;
create temporary table pumpmonth(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk);

insert into pumpmonth(timecol) values ('最大值');
insert into pumpmonth(timecol) values ('最大时间');
insert into pumpmonth(timecol) values ('最小值');
insert into pumpmonth(timecol) values ('最小时间');
insert into pumpmonth(timecol) values ('平均值');


set endDate = date_add(paraDate,interval paradCounts day);
set s1 = 1 ;


if paraCode in ('x001','x002','x005','x025','g02') then
set pumpQuery = concat('update pumpmonth t1, (select max(',paraCode,'_avg*1) ',paraCode,'_avg from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_avg where timecol = \'最大值\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select date_time  from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\' order by ',paraCode,'_avg*1 desc limit 1) t2 set t1.valuecol = t2.date_time where timecol = \'最大时间\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select min(',paraCode,'_avg*1) ',paraCode,'_avg from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_avg where timecol = \'最小值\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select date_time  from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\' order by ',paraCode,'_avg*1 asc limit 1) t2 set t1.valuecol = t2.date_time where timecol = \'最小时间\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery; 
execute stmt; 


set pumpQuery = concat('update pumpmonth t1, (select round(avg(',paraCode,'_avg),3) ',paraCode,'_avg from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_avg where timecol = \'平均值\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 


set endDate = paraDate;
while s1 <= paradCounts do
	insert into pumpmonth(timecol) select endDate;
    
       set pumpQuery = concat('update pumpmonth set valuecol = (select ',paraCode,'_avg  from ',tbName,' where local_id = \'',paraId,'\' and date_time = \'',endDate,'\') where timecol = \'',endDate,'\';');  
       set @myquery = pumpQuery;
       prepare stmt from @myquery;
	   execute stmt;
	set endDate = date_add(endDate,interval 1 day);
    set s1 = s1 + 1;
end while;
end if;



if paraCode in ('g10','x022') then
insert into pumpmonth(timecol) values ('总计');

set pumpQuery = concat('update pumpmonth t1, (select max(',paraCode,'_day*1) ',paraCode,'_day from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_day where timecol = \'最大值\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select date_time  from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\' order by ',paraCode,'_day*1 desc limit 1) t2 set t1.valuecol = t2.date_time where timecol = \'最大时间\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select min(',paraCode,'_day*1) ',paraCode,'_day from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_day where timecol = \'最小值\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select date_time  from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\' order by ',paraCode,'_day*1 asc limit 1) t2 set t1.valuecol = t2.date_time where timecol = \'最小时间\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery; 
execute stmt; 


set pumpQuery = concat('update pumpmonth t1, (select round(avg(',paraCode,'_day),3) ',paraCode,'_day from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_day where timecol = \'平均值\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt; 

set pumpQuery = concat('update pumpmonth t1, (select round(sum(',paraCode,'_day),3) ',paraCode,'_day from ',tbName,' where local_id = \'',paraId,'\' and date_time >= \'',paraDate,'\' and date_time <= \'',endDate,'\') t2 set t1.valuecol = t2.',paraCode,'_day where timecol = \'总计\';');  
set @myquery = pumpQuery;
prepare stmt from @myquery;
execute stmt;

set endDate = paraDate;
while s1 <= paradCounts do
	insert into pumpmonth(timecol) select endDate;
    
       set pumpQuery = concat('update pumpmonth set valuecol = (select ',paraCode,'_day  from ',tbName,' where local_id = \'',paraId,'\' and date_time = \'',endDate,'\') where timecol = \'',endDate,'\';');  
       set @myquery = pumpQuery;
       prepare stmt from @myquery;
	   execute stmt;
	set endDate = date_add(endDate,interval 1 day);
    set s1 = s1 + 1;
end while;
end if;


update pumpmonth set valuecol = '' where valuecol is null;
select * from pumpmonth;
end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
