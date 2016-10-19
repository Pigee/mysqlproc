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

-- 导出  过程 fh_xydd.sp_print_result 结构
DROP PROCEDURE IF EXISTS `sp_print_result`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_print_result`(
 IN f_string varchar(1000),IN f_delimiter varchar(5)
)
BEGIN
  
  declare cnt int;
  declare i int; 
  drop  temporary table if exists tmp_print;
  create temporary table tmp_print(anum varchar(200) not null);
  set i = 0;
   set cnt = func_get_split_string_total(f_string,f_delimiter);
  while i < cnt do
    set i = i + 1;
    insert into tmp_print(anum) values (func_get_split_string(f_string,f_delimiter,i));
  end while;
SELECT 
    *
FROM
    tmp_print;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
