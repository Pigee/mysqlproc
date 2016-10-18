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

-- 导出  过程 fh_xydd.sp_month_maxin 结构
DROP PROCEDURE IF EXISTS `sp_month_maxin`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_month_maxin`(ParaldId varchar(36) charset gbk,ParaCol varchar (45) charset gbk,ParaMon varchar(20) charset gbk)
BEGIN
declare dyquery varchar(200) charset gbk;

drop temporary table if exists temp_maxin ;

set dyquery = concat('create temporary table temp_maxin (montime varchar(20) charset gbk,',ParaCol,' varchar(45) charset gbk);');
set @myquery = dyquery;
prepare stmt from @myquery;
execute stmt;


insert into temp_maxin select '最大值',case max(avgvalue) when  null then '' else max(avgvalue) end from t_static_data where colname = ParaCol and local_id = ParaldId and date_format(date_time,'%Y-%m') = ParaMon;
insert into temp_maxin select '最大时间',case date_time when null then '' else date_time  end  from t_static_data where colname = ParaCol and local_id = ParaldId and date_format(date_time,'%Y-%m') = ParaMon order by avgvalue desc limit 0,1 ;
insert into temp_maxin select '最小值',case min(avgvalue) when null then '' else min(avgvalue)  end from t_static_data where colname = ParaCol and local_id = ParaldId and date_format(date_time,'%Y-%m') = ParaMon;
insert into temp_maxin select '最小时间',case date_time when null then '' else date_time end from t_static_data  where colname = ParaCol and local_id = ParaldId and date_format(date_time,'%Y-%m') = ParaMon order by avgvalue asc limit 0,1 ;
insert into temp_maxin select '平均值',case truncate(avg(avgvalue),2)  when null then '' else truncate(avg(avgvalue),2) end from t_static_data where colname = ParaCol and local_id = ParaldId and date_format(date_time,'%Y-%m') = ParaMon;

set dyquery = concat('select montime,',ParaCol,' from temp_maxin;');
set @myquery = dyquery;
prepare stmt from @myquery;
execute stmt;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
