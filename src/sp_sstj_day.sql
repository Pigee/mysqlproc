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

-- 导出  过程 fh_xydd.sp_sstj_day 结构
DROP PROCEDURE IF EXISTS `sp_sstj_day`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_sstj_day`(paraOrgid varchar(36),paraDate varchar(36),paraArr varchar(200))
BEGIN

declare initTime datetime;
declare initCode varchar(200);
declare finalstr varchar(1000) charset gbk  ;
declare querystr varchar(1000) charset gbk  ;
declare xcode varchar(12);
declare tbName varchar(20);
declare localId varchar(36);
declare i int;
declare j int;
declare k int;
declare cnt int;
declare soncnt int;
declare initDate datetime;


drop temporary table if exists  temp_data;
create temporary table temp_data(timecol varchar(36));
drop temporary table if exists  temp_data_prt;
create temporary table temp_data_prt(timecol varchar(36));


    set i = 0;
    set initDate = paraDate;
    while i < 24 do
    insert into temp_data(timecol) values(initDate);
	set initDate = date_add(initDate,interval 1 hour);
    set i = i + 1;
   end while;

   
    set j = 1;
    set cnt = func_get_split_string_total(paraArr,';');
       while j <= cnt do
       set initCode = func_get_split_string(paraArr,';',j);
           set k = 1 ;
            set soncnt = func_get_split_string_total(initCode,',');
            while k <= soncnt do
                if k = 1 then 
			       set tbName = func_get_split_string(initCode,',',k);
                   
                   
			    end if;
                if k > 1 then
                  set xcode = func_get_split_string(initCode,',',k);
			      set querystr = concat('alter table temp_data add ',xcode,' varchar(36) default null');
                  set @myquery = querystr;
                  prepare stmt from @myquery;
                  execute stmt; 
                end if;
                    set i = 0;
                    set initDate = paraDate;
                    while i < 24 do 
                       if xcode like 'y%' then
                         set querystr =  concat('update temp_data t1,(select round(avg(',xcode,'),2) ',xcode,' from ',tbName,' where update_time > \'',initDate,'\' and update_time <= date_add(\'',initDate,'\',interval 1 hour) and local_id = \'',paraOrgID,'\') t2 set t1.',xcode,'=t2.',xcode,' where timecol = \'',initDate,'\';');
                       end if;
                    end while;
                    
                    
                    
                      
               set k = k + 1;
            end while;
           
			set j = j + 1;
	    end while;
   


select * from temp_data;






END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
