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

-- 导出  函数 fh_xydd.orgwarn 结构
DROP FUNCTION IF EXISTS `orgwarn`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` FUNCTION `orgwarn`(orgid varchar(36) charset gbk) RETURNS int(11)
    DETERMINISTIC
BEGIN
declare warnnum INT(11);
SELECT 
    COUNT(*) into warnnum
FROm
    t_warn_data
WHERE
    warn_status IN ('0' , '1')
        AND local_id IN (
        SELECT 
            local_id
        FROM
            t_local
        WHERE
            org_id = orgid);
RETURN warnnum;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
