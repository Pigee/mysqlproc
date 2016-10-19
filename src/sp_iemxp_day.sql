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

-- 导出  过程 fh_xydd.sp_iemxp_day 结构
DROP PROCEDURE IF EXISTS `sp_iemxp_day`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_iemxp_day`(paraId varchar(36) charset gbk,paraDate varchar(36) charset gbk,tmcol varchar(36) charset gbk)
BEGIN

declare i int;
declare pcount int;
declare pumpName varchar(36) charset gbk;
declare pumpId varchar(36) charset gbk;
declare querystr varchar(1000) charset gbk;
declare queryinst varchar(1000) charset gbk;
declare querysel varchar(1000) charset gbk;
declare initDate datetime;
declare pumpcur cursor for select pump_id,pump_name from t_data_pump where local_id = paraId;



drop table if exists temp_data;
CREATE TABLE temp_data (
    timecol VARCHAR(36)CHARSET GBK,
    x023 VARCHAR(36)CHARSET GBK,
    x022 VARCHAR(36)CHARSET GBK,
    x033 VARCHAR(36)CHARSET GBK,
    x3perx2 VARCHAR(36)CHARSET GBK
);

drop table if exists temp_data_print;
CREATE TABLE temp_data_print (
    timecol VARCHAR(36)CHARSET GBK,
    x023 VARCHAR(36)CHARSET GBK,
    x022 VARCHAR(36)CHARSET GBK,
    x033 VARCHAR(36)CHARSET GBK,
    x3perx2 VARCHAR(36)CHARSET GBK
);


insert into temp_data(timecol) select update_time from t_hour_col where date(update_time) = paraDate;
SELECT 
    COUNT(*)
INTO pcount FROM
    t_data_pump
WHERE
    local_id = paraId;


UPDATE temp_data t1,
    (SELECT 
        update_time,
            ROUND(AVG(x023), 2) x023,
            (MAX(x022 * 1) - MIN(x022 * 1)) x022,
            (MAX(x033 * 1) - MIN(x033 * 1)) x033,
            (MAX(x022 * 1) - MIN(x022 * 1)) / (MAX(x033 * 1) - MIN(x033 * 1)) * 1000 x3perx2
    FROM
        t_data_imp_his
    WHERE
        DATE(update_time) = paraDate
            AND local_id = paraId
    GROUP BY HOUR(update_time)) t2 
SET 
    t1.x023 = t2.x023,
    t1.x022 = t2.x022,
    t1.x033 = t2.x033,
    t1.x3perx2 = t2.x3perx2
WHERE
    t1.timecol = t2.update_time;
  

set queryinst = concat('insert into temp_data_print select \'总计\', avg(x023),sum(x022),sum(x033),avg(x3perx2),');
set querysel = concat('select timecol,x023,x022,x033,x3perx2,');


open pumpcur;   
set i = 0;
while i < pcount  do

  fetch pumpcur into pumpId,pumpName;
  
  set querystr = concat('alter table temp_data add p',i,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  
  set querystr = concat('alter table temp_data_print add p',i,' varchar(12)');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt;
  
  set querystr = concat('update temp_data t1,(select min(update_time) update_time,max(x041) x041 from t_data_pump_his where date(update_time) = \'',paraDate,'\' and pump_id = \'',pumpId,'\' group by hour(update_time)) t2 set t1.p',i,' = t2.x041 where t1.timecol = t2.update_time');
  set @myquery = querystr;
  prepare stmt from @myquery;
  execute stmt; 
  
  
  set queryinst = concat(queryinst,'max(p',i,'),');
  set querysel = concat(querysel,'p',i,',');
  
  set i = i + 1;  
end while;

  insert into temp_data_print select * from temp_data;
 
  set queryinst = concat(substring(queryinst,1,length(queryinst)-3),' from temp_data');
  set @myquery = queryinst;
  prepare stmt from @myquery;
  execute stmt; 

   
  set querysel = concat(substring(querysel,1,length(querysel)-4),' from temp_data_print');
  select querysel;
  set @myquery = querysel;
  prepare stmt from @myquery;
  execute stmt;  



END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
