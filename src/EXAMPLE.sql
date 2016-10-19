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

-- 导出  过程 fh_xydd.EXAMPLE 结构
DROP PROCEDURE IF EXISTS `EXAMPLE`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `EXAMPLE`()
BEGIN
 
 DECLARE v_addtime_begin varchar(13);
 DECLARE v_addtime_end varchar(13);
 
 DECLARE v_borrow_id int;
 DECLARE v_count int;
 DECLARE s1 int;
  
 
 DECLARE c_borrow CURSOR FOR
 SELECT ID from rocky_borrow WHERE BORROWTYPE = 2 AND PUBLISH_TIME >= UNIX_TIMESTAMP('2014-05-27') AND PUBLISH_TIME <= UNIX_TIMESTAMP('2014-07-30') ORDER by ID ASC;
 
 SELECT count(ID) INTO v_count from rocky_borrow WHERE BORROWTYPE = 2 AND PUBLISH_TIME >= UNIX_TIMESTAMP('2014-05-27') AND PUBLISH_TIME <= UNIX_TIMESTAMP('2014-07-30') ORDER by ID ASC;
 
 SET s1 = 1;
 
 START TRANSACTION;
 
 OPEN c_borrow;
 
  WHILE s1 < v_count+1 DO
  
  FETCH c_borrow INTO v_borrow_id;
  SELECT t1.addtime INTO v_addtime_begin FROM (SELECT * FROM rocky_b_tenderrecord bt WHERE BORROW_ID = v_borrow_id AND tender_type = 1 ORDER BY ID ASC) t1 GROUP BY t1.borrow_id;
  SELECT t1.addtime INTO v_addtime_end FROM (SELECT * FROM rocky_b_tenderrecord bt WHERE BORROW_ID = v_borrow_id AND tender_type = 1 ORDER BY ID DESC) t1 GROUP BY t1.borrow_id;
  IF (v_addtime_begin IS NOT NULL) && (v_addtime_end IS NOT NULL) THEN
   
   BEGIN
    DECLARE v_id int;
    DECLARE v_user_id int;
    DECLARE v_type varchar(20);
    DECLARE v_total decimal(20,8) DEFAULT 0;
    DECLARE v_money decimal(20,8) DEFAULT 0;
    DECLARE v_use_money decimal(20,8) DEFAULT 0;
    DECLARE v_no_use_money decimal(20,8) DEFAULT 0;
    DECLARE v_collection decimal(20,8) DEFAULT 0;
    DECLARE v_to_user int(11);
    DECLARE v_remark VARCHAR(1000);
    DECLARE v_addtime varchar(13);
    DECLARE v_addip varchar(64);
    DECLARE v_first_borrow_use_money decimal(20,8) DEFAULT 0;
    DECLARE done VARCHAR(45) DEFAULT '';
    DECLARE t_error int DEFAULT 0;
   
    DECLARE c_accountlog CURSOR FOR
    SELECT ID,USER_ID,TYPE,TOTAL,MONEY,USE_MONEY,NO_USE_MONEY,COLLECTION,TO_USER,REMARK,ADDTIME,ADDIP,FIRST_BORROW_USE_MONEY FROM (
    SELECT ID,USER_ID,TYPE,TOTAL,MONEY,USE_MONEY,NO_USE_MONEY,COLLECTION,TO_USER,REMARK,ADDTIME,ADDIP,FIRST_BORROW_USE_MONEY FROM rocky_accountlog
    WHERE ADDTIME >= v_addtime_begin AND ADDTIME <= v_addtime_end AND (type = 'tender_cold' or type= 'repayment_deduct')
    ) t GROUP BY t.user_id HAVING count(t.user_id) > 1;
     
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = NULL;
    OPEN c_accountlog;
    FETCH c_accountlog INTO v_id,v_user_id,v_type,v_total,v_money,v_use_money,v_no_use_money,v_collection,v_to_user,v_remark,v_addtime,v_addip,v_first_borrow_use_money;
    WHILE (done IS NOT NULL) DO
     INSERT INTO rocky_accountlog_test2 (ACCOUNTLOG_ID,USER_ID,TYPE,TOTAL,MONEY,USE_MONEY,NO_USE_MONEY,COLLECTION,TO_USER,REMARK,ADDTIME,ADDIP,FIRST_BORROW_USE_MONEY,BORROW_ID)
     VALUES (v_id,v_user_id,v_type,v_total,v_money,v_use_money,v_no_use_money,v_collection,v_to_user,v_remark,v_addtime,v_addip,v_first_borrow_use_money,v_borrow_id);
     FETCH c_accountlog INTO v_id,v_user_id,v_type,v_total,v_money,v_use_money,v_no_use_money,v_collection,v_to_user,v_remark,v_addtime,v_addip,v_first_borrow_use_money;
    END WHILE;
    CLOSE c_accountlog;
   END;
  END IF;
  SET s1 = s1 + 1;
 END WHILE;
 CLOSE c_borrow;
 
 COMMIT; 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
