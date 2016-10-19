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

-- 导出  过程 fh_xydd.sp_data_his 结构
DROP PROCEDURE IF EXISTS `sp_data_his`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_data_his`()
BEGIN
insert into t_data_imp_his select uuid(),local_id,local_name,now(),x001,x005,x010,x011,coalesce(x121,'0') +coalesce(x221,'0') +coalesce(x321,'0'), coalesce(x122,'0') +coalesce(x222,'0') +coalesce(x322,'0'),x023,x003,x033,x122,x222,x121,x221,x321,x322,x124,x051,x035,x036,x037,x038,x039,x040,x041,x042,x043,x044,x045,x046,x047,x048,x053,x054,x060 from t_data_imp;
insert into t_data_exp_his select uuid(),local_id,local_name,now(),x001,x002,x005,coalesce(x121,'0') +coalesce(x221,'0') +coalesce(x321,'0'),coalesce(x122,'0') +coalesce(x222,'0') +coalesce(x322,'0'),x023,x003,x033,x122,x222,x121,x221,x051,x060,x061,x062,x063,x064,x065,x066,x067,x068,x075,x076,x077,x078,x024,x322,x321,x025,x026,x027 from t_data_exp;
insert into t_data_pump_his select uuid(),pump_id,pump_name,now(),x031,x032,x033,x034,x041,x042,x043,x023,x025,x026,x044,x045,x036,x037,x038,x039,x051,x052,x053 from t_data_pump;
 insert into t_data_pipe_his select uuid(),local_id,local_name,now(),x001,x002,x005,g01,g02,g10,g11,g12,g13,g15,g03,x010,x011,x035,x036 from t_data_pipe where local_id in ('0b37fe2e-0ff7-4108-abe0-bfe39469ffdd',
'603ca823-cdf4-4949-9b85-c08eecf86972',
'624ed326-1fef-4cf3-b394-fdce5c5afca6',
'9107a040-3fa9-4c57-a8cc-c19b101648b6',
'96628960-1457-42a6-a993-cc9dbd2b89f0',
'98ddec5f-e30d-4f79-8e20-42224220ec76',
'9a957c59-52d7-4206-bab9-8d9bab1e56e6',
'ab8b5c12-ca8a-4c9c-aedb-a2645e701366',
'c04ecf06-0512-4502-b8d5-9bee2a4457fd',
'c6d6ff24-b94f-4d97-a632-f79d402039c2',
'ff58769d-b591-4169-9259-758fee3e5ac6'
);
insert into t_data_pumproom_his select uuid(),local_id,local_name,now(),x001,x002,x005,x021,x022,x023,x025,x033,x043,x032,x034,x035,x026,x036,x037,x038,x045,x046,x047,x048,x049,x050,x051,x052 from t_data_pumproom;

-- insert into t_data_sed_his select uuid(),local_id,local_name,now(),x021,x002,x005,x024 from t_data_sed;
-- insert into t_data_fil_his select uuid(),local_id,local_name,now(),x001,x002,x005,x021,x024 from t_data_fil;
-- insert into t_data_cle_his select uuid(),local_id,local_name,now(),x001,x002,x005,x021,x024 from t_data_cle;
-- insert into t_data_ci_his select uuid(),local_id,local_name,now(),x141,x241,x341,x441,x121,x221,x321,x421,x122,x222,x322,x422,coalesce(x121,'0') +coalesce(x221,'0') +coalesce(x321,'0') +coalesce(x421,'0')+coalesce(x521,'0'),coalesce(x122,'0') +coalesce(x222,'0') +coalesce(x322,'0') +coalesce(x422,'0')+coalesce(x522,'0'),x541,x521,x522,x031,x032,x033,x034,x035,x036,x037 from t_data_ci;
insert into t_data_drug_his select uuid(),local_id,local_name,now(),x141,x241,x341,x441,x121,x221,x321,x421,x122,x222,x322,x422,x021,x022,x023,x024,x025,x026,x031,x032,x033,x034,coalesce(x121,'0') +coalesce(x221,'0') +coalesce(x321,'0') +coalesce(x421,'0'),coalesce(x122,'0') +coalesce(x222,'0') +coalesce(x322,'0') +coalesce(x422,'0'),x043,x044,x061,x062,x063,x064,x065,x066,x035,x036 from t_data_drug;
insert into t_data_swell_his select uuid(),local_id,local_name,now(),x124,x224 from t_data_swell;
-- insert into t_data_ys_pump_his select uuid(),local_id,local_name,now(),x002,x124,x224,x125,x225,x121,x221,x122,x222,x027,x028 from t_data_ys_pump;

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
