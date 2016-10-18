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

-- 导出  过程 fh_xydd.sp_org_static 结构
DROP PROCEDURE IF EXISTS `sp_org_static`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_org_static`(pName varchar(45) charset gbk)
BEGIN
declare orgId varchar(36) charset gbk;
declare ssName varchar(45) charset gbk;
declare errcount varchar(12) charset gbk;
declare o_count int;
declare s1 int;
declare orgcur cursor for select org_id,sname from t_org where org_type = '1' and province = pName;
select count(org_id) into o_count from t_org where org_type = '1' and province = pName;

drop temporary table if exists temp_org;
create temporary table temp_org (orgsid varchar(36) charset gbk,orgsname varchar(45) charset gbk,ecount varchar(12) charset gbk);

open orgcur;
set s1 = 1;
while s1 < o_count + 1 do
fetch orgcur into orgId,ssName;
SELECT 
    COUNT(*)
INTO errcount FROM
    t_warn_data
WHERE
    local_id IN (SELECT 
            local_id
        FROM
            t_local
        WHERE
            org_id IN (SELECT 
                    org_id
                FROM
                    t_org
                WHERE
                    super_id = orgId));
insert into temp_org(orgsid,orgsname,ecount) values (orgId,ssName,errcount);
set s1 = s1 + 1;
end while;
close orgcur;
select * from temp_org order by ecount desc;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
