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

-- 导出  过程 fh_xydd.sp_warn_static 结构
DROP PROCEDURE IF EXISTS `sp_warn_static`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_warn_static`(paraId varchar(36) charset gbk,paraType varchar(2) charset gbk)
BEGIN

    declare orgid varchar(36) charset gbk;
    declare orgname varchar(36) charset gbk;
    declare orgx varchar(45) charset gbk;
    declare orgy varchar(45) charset gbk;
    declare s1 int;
    declare o_count int;
    declare orgcur cursor for select org_id,org_name,org_x,org_y from t_org where org_type = paraType;

DROP temporary TABLE IF EXISTS temp_warn;
DROP temporary TABLE IF EXISTS temp_warn_static;
create temporary table temp_warn_static (org_id varchar(36) charset gbk,org_name varchar(36) charset gbk,org_x varchar(45) charset gbk,org_y varchar(45) charset gbk,level0 varchar(36) charset gbk,level1 varchar(36) charset gbk,level2 varchar(36) charset gbk);
create temporary table temp_warn as 
SELECT  
    t1.super_id,
    t1.org_id,
    t1.org_name,
    t2.local_id,
    t2.warn_level
FROM
    v_org_local t1,
    t_warn_data t2
WHERE
    t1.local_id = t2.local_id
    and t1.super_id = paraId;
SELECT 
    COUNT(*)
INTO o_count FROM
    t_org
WHERE
    super_id = paraId and org_type = paraType;
    set s1 =  1;
    open orgcur;
    
while s1 < o_count + 1 do
        fetch orgcur into orgid,orgname,orgx,orgy;
    insert into temp_warn_static(org_id,org_name,org_x,org_y) values (orgid,orgname,orgx,orgy);
    
 update temp_warn_static t1,(           
     SELECT org_id,
            COUNT(*) total 
        FROM
            temp_warn
        WHERE
            org_id = orgid AND warn_level = '0' ) t2 
            set t1.level0 = t2.total where 
            t1.org_id = orgid;

update temp_warn_static t1,(           
     SELECT org_id,
            COUNT(*) total 
        FROM
            temp_warn
        WHERE
            org_id = orgid AND warn_level = '1' ) t2 
            set t1.level1 = t2.total where 
            t1.org_id = orgid;
            
update temp_warn_static t1,(           
     SELECT org_id,
            COUNT(*) total 
        FROM
            temp_warn
        WHERE
            org_id = orgid AND warn_level = '2') t2 
            set t1.level2 = t2.total where 
            t1.org_id = orgid;
            
            set s1 = s1 + 1;
            
end while;
close orgcur;

select * from temp_warn_static;

end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
