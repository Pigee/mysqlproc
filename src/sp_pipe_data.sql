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

-- 导出  过程 fh_xydd.sp_pipe_data 结构
DROP PROCEDURE IF EXISTS `sp_pipe_data`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pipe_data`(ParaId varchar(36) charset gbk)
BEGIN


drop temporary table if exists temp_pipedata;
create temporary table temp_pipedata(item varchar(36) charset gbk,dicode varchar(36) charset gbk,svalue varchar(36) charset gbk,unit varchar(12) charset utf8);
insert into temp_pipedata(item,dicode,unit) values ('更新时间','update_time','');
insert into temp_pipedata(item,dicode,unit) select dic_name,dic_code,dic_unit from t_factory_dic where dic_id in (select dic_id from t_factory_detail where isgwdt = '1');
begin
declare p_count int;
declare s1 int;
declare diccode varchar(36) charset gbk;
declare querystr varchar(500) charset gbk;
declare ccode cursor for select dicode from temp_pipedata;
SELECT 
    COUNT(*)
INTO p_count FROM
    temp_pipedata;
set s1 = 1;
open ccode;
while s1 < p_count + 1 do
   fetch ccode into diccode;
      set querystr =  concat('update temp_pipedata t1,(select ',diccode,' from t_data_pipe where local_id = \'',ParaId,'\') t2 set t1.svalue = t2.',diccode,' where t1.dicode = \'',diccode,'\'');
      set @myquery = querystr;
prepare stmt from @myquery;
execute stmt;
      set s1 =  s1 + 1;
end while;
close ccode;
end;
SELECT 
    item,svalue,unit
FROM
    temp_pipedata;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
