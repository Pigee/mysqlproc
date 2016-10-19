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

-- 导出  过程 fh_xydd.sp_pumproom_day 结构
DROP PROCEDURE IF EXISTS `sp_pumproom_day`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pumproom_day`(paraId varchar(36) charset gbk,paraCode varchar(12) charset gbk,paraDate varchar(30) charset gbk,paraInter varchar(12) charset gbk)
BEGIN

declare pumproomQuery varchar(500) charset gbk;
declare initdate datetime;
declare tbName varchar(36) charset gbk;
declare s1 int;
declare hcount int;

SELECT 
    CASE local_type
        WHEN '1' THEN 't_data_imp_his'
        WHEN '2' THEN 't_data_exp_his'
        WHEN '4' THEN 't_data_sed_his'
        WHEN '5' THEN 't_data_fil_his' 
        WHEN '6' THEN 't_data_cle_his'
        WHEN '7' THEN 't_data_pumproom_his'
        WHEN '8' THEN 't_data_drug_his'
        WHEN '9' THEN 't_data_ci_his'
        WHEN '10' THEN 't_data_swell_his'
        else 't_data_pipe_his'
    END
INTO tbName FROM
    t_local
WHERE
    local_id = paraId; 

select case paraInter when 60 then 24 when 30 then 48 when 10 then 144 when 120 then 12 when 240 then 6 end into hcount from dual;



drop temporary table if exists pumproomday;
drop temporary table if exists pumproomday_temp;

create temporary table pumproomday(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk);
create temporary table pumproomday_temp(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk);

insert into pumproomday(timecol) values ('最大值');
insert into pumproomday(timecol) values ('最大时间');
insert into pumproomday(timecol) values ('最小值');
insert into pumproomday(timecol) values ('最小时间');
insert into pumproomday(timecol) values ('平均值');


if paraCode  in ('x022','g10','x033') then
   insert into pumproomday(timecol) values ('合计');
   if paraCode  in ('g10') then
   insert into pumproomday(timecol) values ('天气');
   end if;
      set s1 = 1;
      set initDate = paraDate;

      while s1 <= hcount do
		insert into pumproomday_temp(timecol) select initDate;
         set pumproomQuery = concat('update pumproomday_temp t1,(select ROUND(max(',paraCode,'*1) - min(',paraCode,'*1),2)',paraCode,'  from ',tbName,' where update_time >= \'',initDate,'\' and update_time <= date_add(\'',initDate,'\',interval ',paraInter,' minute) and ',paraCode,'<> 0 and local_id = \'',paraId,'\')t2 set t1.valuecol = t2.',paraCode,' where timecol = \'',initDate,'\'');
          set @myquery = pumproomQuery;
		  prepare stmt from @myquery;
		  execute stmt;
         
         set initDate = date_add(initDate,interval paraInter minute);
          set s1 = s1 + 1;  
      end while;
   end if;
    update pumproomday set valuecol = (select round(sum(valuecol),2) from pumproomday_temp) where timecol = '合计';


if paraCode  in ('x001','x002','x005','x025','g02','g11','x124') then
      set s1 = 1;
      set initDate = paraDate;
      while s1 <= hcount do
		insert into pumproomday_temp(timecol) select initDate;
        
       
          set initDate = date_add(initDate,interval paraInter minute);
          set s1 = s1 + 1;  
       end while;
       
       set pumproomQuery = concat('update pumproomday_temp t1,(select update_time,',paraCode,'  from ',tbName,' where update_time >= \'',paraDate,'\' and update_time < date_add(\'',paraDate,'\',interval 1 day)  and local_id = \'',paraId,'\' and minute(update_time)%',paraInter,'=0)t2 set t1.valuecol = t2.',paraCode,' where t1.timecol = t2.update_time');
	  set @myquery = pumproomQuery;
      prepare stmt from @myquery;
		  execute stmt;
end if;

   update pumproomday set valuecol = (select max(valuecol*1) from pumproomday_temp) where timecol = '最大值';
   update pumproomday set valuecol = (select min(valuecol*1) from pumproomday_temp) where timecol = '最小值';
   update pumproomday set valuecol = (select round(avg(valuecol),2) from pumproomday_temp) where timecol = '平均值';
 if paraCode  in ('x022','g10','x033') then
   if paraCode  in ('g10') then
    update pumproomday set valuecol  = (select weather from t_weather where date = paraDate)  where timecol = '天气';
   end if;
  update pumproomday set valuecol  = (select concat(date_format(timecol,'%H:%i'),'~',date_format(date_add(timecol,interval paraInter minute),'%H:%i')) from pumproomday_temp where valuecol is not null order by valuecol*1 asc limit 1)   where timecol = '最小时间';
  update pumproomday set valuecol  = (select concat(date_format(timecol,'%H:%i'),'~',date_format(date_add(timecol,interval paraInter minute),'%H:%i')) from pumproomday_temp where valuecol is not null  order by valuecol*1 desc limit 1)   where timecol = '最大时间';     
 update pumproomday set valuecol  = (select concat(date_format(timecol,'%H:%i'),'~',date_format(date_add(timecol,interval paraInter minute),'%H:%i')) from pumproomday_temp where valuecol is not null order by valuecol*1 asc limit 1)   where timecol = '最小时间';
 insert into pumproomday select concat(date_format(timecol,'%H:%i'),'~',date_format(date_add(timecol,interval paraInter minute),'%H:%i')),valuecol from pumproomday_temp order by timecol asc;
end if;

if paraCode  in ('x001','x002','x005','x025','g02','g11','x124') then
  update pumproomday set valuecol  = (select date_format(timecol,'%H:%i') from pumproomday_temp where valuecol is not null order by valuecol*1 asc limit 1)   where timecol = '最小时间';
  update pumproomday set valuecol  = (select date_format(timecol,'%H:%i') from pumproomday_temp  where valuecol is not null order by valuecol*1 desc limit 1)   where timecol = '最大时间';     
 update pumproomday set valuecol  = (select date_format(timecol,'%H:%i') from pumproomday_temp where valuecol is not null order by valuecol*1 asc limit 1)   where timecol = '最小时间';
 insert into pumproomday select date_format(timecol,'%H:%i'),valuecol from pumproomday_temp order by timecol asc;
end if;
 update pumproomday set valuecol = ''  where valuecol is null;

select * from pumproomday;

end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
