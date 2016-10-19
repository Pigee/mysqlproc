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

-- 导出  过程 fh_xydd.sp_work_smorder 结构
DROP PROCEDURE IF EXISTS `sp_work_smorder`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_work_smorder`(paraDate varchar(36),paraId varchar(36))
BEGIN

if paraId = '0' then 
SELECT 
    a.dept_id,
    a.dept_name,
    COALESCE(b.total, '---') total,
    COALESCE(c.finish, '---') finish,
    COALESCE(d.processing, '---') processing,
    COALESCE(c.finish / b.total, '---') ratio
FROM
    (SELECT 
        dept_id, dept_name
    FROM
        t_dept
    WHERE
        dept_level = '2') a
        LEFT JOIN
    (SELECT 
        t.super_id, COUNT(*) total
    FROM
        (SELECT 
        t1.sent_user,
            t2.dept_id,
            t3.dept_name,
            CASE
                WHEN LENGTH(t3.super_id) < 5 THEN t2.dept_id
                ELSE t3.super_id
            END super_id
    FROM
        (SELECT 
        sent_user, order_status, gdtype
    FROM
        t_work_order
    WHERE
        DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND order_status IN ('2' , '3', '4', '6')
            AND gdtype IN (SELECT 
                dic_code
            FROM
                fh_xydd.t_data_dic
            WHERE
                dic_type = 'gd01')) t1
    JOIN sys_user t2 ON t1.sent_user = t2.user_id
    JOIN t_dept t3 ON t2.dept_id = t3.dept_id) t
    GROUP BY t.super_id) b ON a.dept_id = b.super_id
        LEFT JOIN
    (SELECT 
        t.super_id, COUNT(*) finish
    FROM
        (SELECT 
        t1.sent_user,
            t2.dept_id,
            t3.dept_name,
            CASE
                WHEN LENGTH(t3.super_id) < 5 THEN t2.dept_id
                ELSE t3.super_id
            END super_id
    FROM
        (SELECT 
        sent_user, order_status, gdtype
    FROM
        t_work_order
    WHERE
        DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND order_status IN ('4')
            AND gdtype IN (SELECT 
                dic_code
            FROM
                fh_xydd.t_data_dic
            WHERE
                dic_type = 'gd01')) t1
    JOIN sys_user t2 ON t1.sent_user = t2.user_id
    JOIN t_dept t3 ON t2.dept_id = t3.dept_id) t
    GROUP BY t.super_id) c ON a.dept_id = c.super_id
        LEFT JOIN
    (SELECT 
        t.super_id, COUNT(*) processing
    FROM
        (SELECT 
        t1.sent_user,
            t2.dept_id,
            t3.dept_name,
            CASE
                WHEN LENGTH(t3.super_id) < 5 THEN t2.dept_id
                ELSE t3.super_id
            END super_id
    FROM
        (SELECT 
        sent_user, order_status, gdtype
    FROM
        t_work_order
    WHERE
        DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND order_status IN ('2' , '3', '6')
            AND gdtype IN (SELECT 
                dic_code
            FROM
                fh_xydd.t_data_dic
            WHERE
                dic_type = 'gd01')) t1
    JOIN sys_user t2 ON t1.sent_user = t2.user_id
    JOIN t_dept t3 ON t2.dept_id = t3.dept_id) t
    GROUP BY t.super_id) d ON a.dept_id = d.super_id;

else 
SELECT 
    a.dept_id,
    a.dept_name,
    COALESCE(b.total, '---') total,
    COALESCE(c.finish, '---') finish,
    COALESCE(d.processing, '---') processing,
    COALESCE(c.finish / b.total, '---') ratio
FROM
    (SELECT 
        dept_id, dept_name
    FROM
        t_dept
    WHERE
        dept_level = '2') a
        LEFT JOIN
    (SELECT 
        t.super_id, COUNT(*) total
    FROM
        (SELECT 
        t1.sent_user,
            t2.dept_id,
            t3.dept_name,
            CASE
                WHEN LENGTH(t3.super_id) < 5 THEN t2.dept_id
                ELSE t3.super_id
            END super_id
    FROM
        (SELECT 
        sent_user, order_status, gdtype
    FROM
        t_work_order
    WHERE
        DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND order_status IN ('2' , '3', '4', '6')
            AND gdtype IN (SELECT 
                dic_code
            FROM
                fh_xydd.t_data_dic
            WHERE
                dic_type = 'gd01')) t1
    JOIN sys_user t2 ON t1.sent_user = t2.user_id
    JOIN t_dept t3 ON t2.dept_id = t3.dept_id) t
    GROUP BY t.super_id) b ON a.dept_id = b.super_id
        LEFT JOIN
    (SELECT 
        t.super_id, COUNT(*) finish
    FROM
        (SELECT 
        t1.sent_user,
            t2.dept_id,
            t3.dept_name,
            CASE
                WHEN LENGTH(t3.super_id) < 5 THEN t2.dept_id
                ELSE t3.super_id
            END super_id
    FROM
        (SELECT 
        sent_user, order_status, gdtype
    FROM
        t_work_order
    WHERE
        DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND order_status IN ('4')
            AND gdtype IN (SELECT 
                dic_code
            FROM
                fh_xydd.t_data_dic
            WHERE
                dic_type = 'gd01')) t1
    JOIN sys_user t2 ON t1.sent_user = t2.user_id
    JOIN t_dept t3 ON t2.dept_id = t3.dept_id) t
    GROUP BY t.super_id) c ON a.dept_id = c.super_id
        LEFT JOIN
    (SELECT 
        t.super_id, COUNT(*) processing
    FROM
        (SELECT 
        t1.sent_user,
            t2.dept_id,
            t3.dept_name,
            CASE
                WHEN LENGTH(t3.super_id) < 5 THEN t2.dept_id
                ELSE t3.super_id
            END super_id
    FROM
        (SELECT 
        sent_user, order_status, gdtype
    FROM
        t_work_order
    WHERE
        DATE_FORMAT(create_time, '%Y-%m') = paraDate
            AND order_status IN ('2' , '3', '6')
            AND gdtype IN (SELECT 
                dic_code
            FROM
                fh_xydd.t_data_dic
            WHERE
                dic_type = 'gd01')) t1
    JOIN sys_user t2 ON t1.sent_user = t2.user_id
    JOIN t_dept t3 ON t2.dept_id = t3.dept_id) t
    GROUP BY t.super_id) d ON a.dept_id = d.super_id
    where a.dept_id = paraId;
    end if;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
