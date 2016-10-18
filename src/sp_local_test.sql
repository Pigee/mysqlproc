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

-- 导出  过程 fh_xydd.sp_local_test 结构
DROP PROCEDURE IF EXISTS `sp_local_test`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_local_test`(paraId varchar(36) charset gbk,paraTime varchar(36) charset gbk,paraInterval int)
BEGIN

DROP temporary table IF EXISTS t_local_code;
create temporary table t_local_code as select m.local_id,m.local_name,n.dic_code,n.dic_table from  (
SELECT 
    t1.org_id, t1.dic_id, t2.dic_code, t2.dic_table
FROM
    (SELECT 
        org_id, dic_id
    FROM
        t_factson_detail
    WHERE
        w_conf0 = '1') t1,
    t_factory_dic t2
WHERE
    t1.dic_id = t2.dic_id )n, (
    SELECT 
    local_id,
    local_name,
    org_id,
    CASE
        WHEN local_type = '2' THEN 't_data_exp'
        WHEN local_type = '1' THEN 't_data_imp'
    END
    dic_table
FROM
    t_local
WHERE
    local_id = paraId)m
    where m.org_id = n.org_id and m.dic_table = n.dic_table;

    
BEGIN 

declare local_id varchar(36) charset gbk;   
declare local_name varchar(45) charset gbk; 
declare dic_code varchar(12) charset gbk;
declare dic_table varchar(12) charset gbk;
declare starTime varchar(36) charset gbk;
declare endTime varchar(36) charset gbk;
declare l_count int;
declare t_count int;
declare s1 int;
declare s2 int;
declare mystr varchar(20000) charset gbk;
declare local_cur cursor for select * from t_local_code;


set starTime = paraTime;
set endTime = date_add(paraTime,interval paraInterval minute);
set mystr = 'select ';
set t_count = 1440/paraInterval;
set s2 = 1;

   while s2 <= t_count do 
      
       set s1 = 1;
       open local_cur;
       select count(*) into l_count from t_local_code;
       
       if l_count = 0 then
       set mystr = concat(mystr,'date_format(\'',starTime,'\',\'%H:%i\') time from dual union all select ');
       end if ;
       
       if l_count > 0 then
       set mystr = concat(mystr,'date_format(\'',starTime,'\',\'%H:%i\') time,');
       while s1 < l_count + 1 do
        fetch local_cur into local_id,local_name,dic_code,dic_table;
        set mystr = concat(mystr,'truncate(avg(',dic_code,'),2)',dic_code,',');
        set s1 = s1 + 1;
       END WHILE;
	  set mystr = concat(substring(mystr,1,length(mystr)-1),' from ',dic_table,'_his where local_id = \'',local_id,'\' and update_time between \'',starTime,'\' and \'',endTime,'\' union all select ');
       end if;
       
      set starTime = date_add(starTime,interval paraInterval minute);
     set endTime = date_add(endTime,interval paraInterval minute);
     set s2 = s2 + 1;
      close local_cur;
end while;
    
set mystr = substring(mystr,1,length(mystr)-17);
select length(mystr);



 END;
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
