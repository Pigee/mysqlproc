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

-- 导出  过程 fh_xydd.sp_work_order 结构
DROP PROCEDURE IF EXISTS `sp_work_order`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_work_order`(paraId varchar(36),paraDate varchar(36))
BEGIN
declare s1,c_count int;
declare initDate date;
declare dicId,dicName varchar(36);
declare queryStr,sumStr varchar(2000);

declare dic_cur cursor for SELECT dic_code,dic_value FROM fh_xydd.t_data_dic where dic_type = 'gd01';
        
drop temporary table if exists temp_order;
create temporary table temp_order as SELECT 
    dept_id,dept_name
FROM
    fh_xydd.T_DEPT
WHERE
    dept_level = '3'
        AND super_id = paraId or dept_id = paraId;
        
SELECT 
    COUNT(*)
INTO c_count FROM
    fh_xydd.t_data_dic
WHERE
    dic_type = 'gd01';
open dic_cur;
set s1 = 1;
set sumStr = concat('insert into temp_order_final select \'sumid\',\'合计\',');
while s1 <= c_count do
fetch dic_cur into dicId,dicName;
set sumStr = concat(sumstr,'sum(',dicId,'),');
-- select dicId,dicName;
set queryStr = concat('alter table temp_order add ',dicId,' varchar(36)');
set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt;

set queryStr = concat('update temp_order x, (select m.dept_id,m.dept_name,coalesce(n.order_sum,0) order_sum from (
SELECT 
    dept_id,dept_name
FROM
    fh_xydd.T_DEPT
WHERE
    dept_level = \'3\'
        AND super_id = \'',paraId,'\' or dept_id = \'',paraId,'\')m 
        left join (
        SELECT 
        t2.dept_id, COUNT(*) order_sum
    FROM
        t_work_order t1,(select user_id,dept_id from sys_user) t2 WHERE
        gDtype = \'',dicId,'\' and order_status in (\'2\',\'3\',\'4\',\'6\')
        and date_format(create_time,\'%Y-%m\') = \'',paraDate,'\'
        and t1.sent_user = t2.user_id
    GROUP BY t2.dept_id
        )n on m.dept_id = n.dept_id)y set x.',dicId,' = y.order_sum where x.dept_id = y.dept_id');
set @myquery = queryStr;
prepare stmt from @myquery;
execute stmt;
set s1 = s1 + 1;
end while;
close dic_cur;


alter table temp_order add sum_value varchar(36);

UPDATE temp_order x,
    (SELECT 
        t2.dept_id, COUNT(*) order_sum
    FROM
        t_work_order t1, (SELECT 
        user_id, dept_id
    FROM
        sys_user) t2
    WHERE
        gDtype IN (SELECT 
                dic_code
            FROM
                t_data_dic
            WHERE
                dic_type = 'gd01')
            AND DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND t1.sent_user = t2.user_id
    GROUP BY t2.dept_id) y 
SET 
    x.sum_value = COALESCE(y.order_sum, NULL)
WHERE
    x.dept_id = y.dept_id;

drop temporary table if exists temp_order_final;
create temporary table temp_order_final as SELECT * from temp_order;
        
set sumStr = concat(sumStr,'sum(sum_value) from temp_order');
set @myquery = sumStr;
prepare stmt from @myquery;
execute stmt;
update temp_order_final set sum_value = 0 where sum_value is null;
update temp_order_final set dept_name = '部门直属' where dept_id = paraId;
SELECT 
    *
FROM
    temp_order_final;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
