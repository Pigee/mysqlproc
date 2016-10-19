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

-- 导出  过程 fh_xydd.sp_orgwarn 结构
DROP PROCEDURE IF EXISTS `sp_orgwarn`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_orgwarn`(orgid varchar(36) charset gbk)
BEGIN

declare x varchar(36) charset gbk;
declare curorg CURSOR FOR SELECT DISTINCT org_id from v_org_local where super_id = orgid;
DECLARE EXIT HANDLER FOR NOT FOUND  SET @done = TRUE ;
drop temporary table if exists static_temp ;
create temporary table static_temp as SELECT DISTINCT org_id,org_name,org_x,org_y from v_org_local where super_id =orgid;
alter table static_temp add warnum varchar(20);
set @done = NULL;
OPEN curorg;
   org_loop: LOOP
         
    IF @done is TRUE THEN
         leave org_loop;
		 END IF;
         
         FETCH curorg INTO x;
UPDATE static_temp 
SET 
    warnum = ORGWARN(x)
WHERE
    org_id = x;
       
		 END LOOP org_loop;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
