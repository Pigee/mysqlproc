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

-- 导出  过程 fh_xydd.sp_insert_static 结构
DROP PROCEDURE IF EXISTS `sp_insert_static`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_insert_static`()
BEGIN


drop temporary table if exists temp_exp;
drop temporary table if exists temp_imp;
drop temporary table if exists temp_dic;
create temporary table temp_exp as SELECT t1.local_id,t1.local_name,t2.org_id from t_data_exp t1,t_local t2 where t1.local_id = t2.local_id;
create temporary table temp_imp as SELECT t1.local_id,t1.local_name,t2.org_id from t_data_imp t1,t_local t2 where t1.local_id = t2.local_id;
create temporary table temp_dic as select t1.org_id,t2.dic_code,t2.dic_table from (select org_id,dic_id from t_factson_detail where w_conf0 = '1') t1, t_factory_dic t2 where t1.dic_id = t2.dic_id;

    begin
      declare corg_id varchar(36) charset gbk;
	  declare dic_code varchar(12) charset gbk;
      declare dic_table varchar(12) charset gbk;
      declare c_count int;
      declare s1 int;
      declare dic_cursor cursor for select * from temp_dic;
      select count(org_id) into c_count from temp_dic;
      set s1 = 1;
	  start transaction;
	  open dic_cursor;
      while s1 < c_count + 1 do
      fetch dic_cursor into corg_id,dic_code,dic_table;
		     if dic_table = 't_data_exp' then
             begin
             declare exp_id varchar(36) charset gbk;
             declare exp_name varchar(45) charset gbk;
             declare eorg_id varchar(36) charset gbk;
             declare e_count int;
             declare s2 int;
             declare exp_cursor cursor for select * from temp_exp;
			 select count(local_id) into e_count from temp_exp;
			 set s2 = 1;
             open exp_cursor;    
               while s2 < e_count + 1 do
                fetch exp_cursor into exp_id,exp_name,eorg_id;
				if eorg_id = corg_id then 
                insert into t_static_data(data_id,local_id,local_name,colname,date_time) values (uuid(),exp_id,exp_name,dic_code,now());
                end if;
               set s2 = s2 + 1;
               end while;
               close exp_cursor;
              end;
              end if;
			 if dic_table = 't_data_imp' then
             begin
             declare imp_id varchar(36) charset gbk;
             declare imp_name varchar(45) charset gbk;
             declare iorg_id varchar(36) charset gbk;
             declare i_count int;
             declare s3 int;
             declare imp_cursor cursor for select * from temp_imp;
			 select count(local_id) into i_count from temp_imp;
			 set s3 = 1;
             open imp_cursor;    
               while s3 < i_count + 1 do
                fetch imp_cursor into imp_id,imp_name,iorg_id;
                  if iorg_id = corg_id then 
				    insert into t_static_data(data_id,local_id,local_name,colname,date_time) values (uuid(),imp_id,imp_name,dic_code,now());
                  end if;
               set s3 = s3 + 1;
               end while;
               close imp_cursor;
              end;
              end if;
              
      SET s1 = s1 + 1;
      end while;
      close dic_cursor;
	 commit;
    END;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
