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

-- 导出  函数 fh_xydd.func_zrtq 结构
DROP FUNCTION IF EXISTS `func_zrtq`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` FUNCTION `func_zrtq`(localId varchar(36)) RETURNS varchar(36) CHARSET gbk
BEGIN
declare timeResult varchar(36);

select update_time into timeResult from (
SELECT 
    update_time,
    ABS(update_time - (select date_sub(update_time,interval 1 day) from t_data_pipe
WHERE
    local_id = localId)) hell
FROM
    t_data_pipe_his
WHERE
    local_id = localId
        AND DATE(update_time) = date_sub(date(now()),interval 1 day))t order by t.hell limit 1;
RETURN timeResult;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
