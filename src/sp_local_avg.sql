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

-- 导出  过程 fh_xydd.sp_local_avg 结构
DROP PROCEDURE IF EXISTS `sp_local_avg`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_local_avg`(paraLocalid varchar(36) charset gbk,paraConfid varchar(36) charset gbk,paraopt varchar(12) charset gbk)
BEGIN


declare startVar varchar(12) charset gbk;
declare endVar varchar(12) charset gbk;
declare dayCount  varchar(12) charset gbk;
declare codeVar varchar(12) charset gbk;
declare tbName  varchar(20) charset gbk;
declare queryStr varchar(500) charset gbk;
declare s1 int;

SELECT 
    start_var
INTO startVar FROM
    t_warn_conf
WHERE
    conf_id = paraConfid;
SELECT 
    end_var
INTO endVar FROM
    t_warn_conf
WHERE
    conf_id = paraConfid;
SELECT 
    day_count
INTO dayCount FROM
    t_warn_conf
WHERE
    conf_id = paraConfid;
SELECT 
    warn_type
INTO codeVar FROM
    t_warn_conf
WHERE
    conf_id = paraConfid;
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
        ELSE 't_data_pipe_his'
    END
INTO tbName FROM
    t_local
WHERE
    local_id = paraLocalid;


if paraOpt = '0' then 
set queryStr = concat('select round(avg(',codeVar,'),2) avgvalue  from ',tbName,' where ',codeVar,' between ',startVar,' and ',endVar,' and update_time between date_sub(curdate(),interval ',dayCount,' day) and curdate() and local_id = \'',paraLocalid,'\'');
set @myquery = queryStr;
SELECT queryStr;
prepare stmt from @myquery;

end if;

if paraOpt = '1' then 
set queryStr = concat('select round(avg(',codeVar,'),2) avgvalue  from ',tbName,' where ',codeVar,' between ',startVar,' and ',endVar,' and date_format(update_time,\'%Y-%m-%d %H\') in (');

set s1 = 1;
while s1 <= dayCount do
set queryStr=concat(queryStr,'date_format(date_sub(now(),interval ',s1,' day),\'%Y-%m-%d %H\'),');
set s1 = s1 + 1;
end while;

set queryStr = concat(substring(queryStr,1,length(queryStr)-1),')and local_id = \'',paraLocalid,'\'');
SELECT queryStr;
/*
set @myquery = queryStr;

 prepare stmt from @myquery;
execute stmt;  
*/
end if;


END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
