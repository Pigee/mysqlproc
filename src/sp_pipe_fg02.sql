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

-- 导出  过程 fh_xydd.sp_pipe_fg02 结构
DROP PROCEDURE IF EXISTS `sp_pipe_fg02`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pipe_fg02`(paraLocalid varchar(36) charset gbk,paraDate varchar(20) charset gbk,paraResult varchar(20) charset gbk)
BEGIN

declare startTime,endTime varchar(36) charset gbk;
declare queryStr,fengStr,guStr varchar(1500) charset gbk;
declare localName varchar(36) charset gbk;
declare s1,s2,s3,fCount,gCount,dayCount int;
declare initDate varchar(20) charset gbk;
declare fengcur cursor for select start_time,end_time from res_fg_def where timetype = '0';
declare gucur cursor for select start_time,end_time from res_fg_def where timetype = '1';


drop temporary table if exists temp_fgend;
drop temporary table if exists temp_fg02;
create temporary table temp_fgend (timecol varchar(36) charset gbk,fvalue varchar(36) charset gbk,gvalue varchar(36) charset gbk,avalue varchar(36) charset gbk);
create temporary table temp_fg02 (timecol varchar(36) charset gbk,fvalue double,gvalue double,avalue double);

select local_name into localName from t_local where local_id = paraLocalid;
select count(*) into fCount from res_fg_def where timetype = '0';
select count(*) into gCount from res_fg_def where timetype = '1';
SELECT  TIMESTAMPDIFF(day,paraDate,(DATE_add(paraDate,INTERVAL 1 month))) into dayCount;





set initDate = paraDate;
set s1 = 1;
while s1 <= dayCount do

     set queryStr= concat('insert into temp_fg02 select \'',initDate,'\',round(t1.feng,3),round(t2.gu,3),round(t3.av,3) from (select min(g02) feng from t_data_pipe_his where g02 <> 0 and (');
     
       set s2 = 1;
       open fengcur;

	   while s2 <= fCount do
	   fetch fengCur into startTime,endTime;
	   set queryStr = concat(queryStr,' update_time between \'',initDate,' ',startTime,'\' and \'',initDate,' ',endTime,'\' or');
        set s2 = s2 + 1;
       end while;
       set queryStr = concat(substring(queryStr,1,length(queryStr)-3),') and local_id = \'',paraLocalid,'\') t1,(select min(g02) gu from t_data_pipe_his  where g02 <> 0 and (');
       close fengcur;
       
       
       
       set s2 = 1;
       open gucur;
	   while s2 <= gCount do
	   fetch guCur into startTime,endTime;
	   set queryStr = concat(queryStr,' update_time between \'',initDate,' ',startTime,'\' and \'',initDate,' ',endTime,'\' or');
        set s2 = s2 + 1;
       end while;
       set queryStr = concat(substring(queryStr,1,length(queryStr)-3),')  and local_id = \'',paraLocalid,'\') t2');
       close gucur;
       set queryStr = concat(queryStr,', (select avg(g02) av from t_data_pipe_his where update_time >= \'',initDate,'\' and  update_time <= date_add(\'',initDate,'\',interval 1 day) and local_id = \'',paraLocalid,'\') t3');
   
       set @myquery = queryStr;
	   prepare stmt from @myquery;
       execute stmt;
	 
       
       
   set initDate = date_add(initDate,interval 1 day);
   set s1 = s1 + 1;
   
end while;


IF paraResult = '0' then
##########################################
insert into temp_fgend select '最大值',max(fvalue),max(gvalue),max(avalue) from temp_fg02;
insert into temp_fgend(timecol,fvalue) select '最大时间',t1.timecol from (select timecol from temp_fg02 order by fvalue desc limit 1) t1;
update temp_fgend t1,(select timecol from temp_fg02 where gvalue is not null order by gvalue desc limit 1) t2 set t1.gvalue = t2.timecol where t1.timecol = '最大时间'; 
update temp_fgend t1,(select timecol from temp_fg02 where avalue is not null order by avalue desc limit 1) t2 set t1.avalue = t2.timecol where t1.timecol = '最大时间'; 


##########################################
insert into temp_fgend select '最小值',min(fvalue),min(gvalue),min(avalue) from temp_fg02;
insert into temp_fgend(timecol,fvalue) select '最小时间',t1.timecol from (select timecol from temp_fg02 order by fvalue asc limit 1) t1;
update temp_fgend t1,(select timecol from temp_fg02 where gvalue is not null order by gvalue asc limit 1) t2 set t1.gvalue = t2.timecol where t1.timecol = '最小时间'; 
update temp_fgend t1,(select timecol from temp_fg02 where avalue is not null order by avalue asc limit 1) t2 set t1.avalue = t2.timecol where t1.timecol = '最小时间'; 

###########################################
insert into temp_fgend select '平均值',round(avg(fvalue),3),round(avg(gvalue),3),round(avg(avalue),3) from temp_fg02;
insert into temp_fgend select timecol,fvalue,gvalue,avalue from temp_fg02;


###############################
update temp_fgend set fvalue = '' where fvalue is null;
update temp_fgend set gvalue = '' where gvalue is null;
update temp_fgend set avalue = '' where avalue is null;
select timecol,fvalue,gvalue,avalue from temp_fgend;
end if;

if paraResult = '1' then
select localName,timecol,fvalue,gvalue,avalue from temp_fg02;
end if; 

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
