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

-- 导出  过程 fh_xydd.sp_update_data 结构
DROP PROCEDURE IF EXISTS `sp_update_data`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_update_data`()
BEGIN

update t_data_imp t set
            t.update_time = now(),
            t.x001=round(6+RAND()*3,2),	
			t.x005=round(20+RAND()*30,1),		
			t.x010=round((2+RAND()*2),2),
            t.x011=round(rand(),2),
            t.x121=round((1000+RAND()*1000),0),
            t.x221='',
            t.x321='',
			t.x021=round((t.x121+t.x221+t.x321),0),
            t.x122=round(x122+14+RAND()*7,0),
            t.x222='',
            t.x322='',
            t.x022=round((t.x122+t.x222+t.x322),0),
            t.x023=round(0.12+rand()/10*2,2),
            t.x003='',
		    t.x033=round(x033+2.1+rand()*1.5,1),
            t.x051=round(t.x051+RAND()*2,2),
            t.x035=round(rand()*20,2),
            t.x035=round(rand()*2,2);

update t_data_exp t set
            t.update_time = now(),
            t.x001=round(6+RAND()*3,2),		
			t.x005=round(0.1+rand()/10,2),	
			t.x002=round(0.5+rand()/10*2,2),
			t.x121=round((1000+RAND()*1000),0),
            t.x221='',
			t.x021=round((t.x121+t.x221),0),
            t.x122=round(x122+14+RAND()*7,0),
            t.x222='',
            t.x022=round((t.x122+t.x222),0),
            t.x023=round(0.29+rand()/100*2,2),
            t.x003=round(0.3+rand()/10*2,2),
            t.x033=round(x033+4.1+rand()*1.5,1),
		    t.x051='';
            
             
update t_data_pumproom t set
            t.update_time = now(),
            t.x001=round(6+RAND()*2,2),	
			t.x005=round(rand(),2),	
			t.x002=round(0.3+rand()/10*2,2),
            t.x021=round((2800+RAND()*10),2),
            t.x022=round(x022+RAND()*10,2),
            t.x023=round(0.12+rand()/100*2,2),
            t.x025=round(0.12+rand()/100*2,2),
            t.x033=round(x033+rand()*10,1),
            t.x043=round(40+rand()*5,1);
            
            
            
update t_data_sed t set
            t.update_time = now(),
            t.x021=round((2800+RAND()*10),2),	
			t.x002=round(0.3+rand()/10*2,2),		
			t.x005=round(2+rand(),2),
            t.x024=round(2+rand(),1);
            
            
update t_data_fil t set
            t.update_time = now(),
            t.x001=round(6+RAND()*2,2),
            t.x021=round((2800+RAND()*10),2),	
			t.x002=round(0.3+rand()/10*2,2),		
			t.x005=round(0.2+rand()/10,2),
            t.x024=round(2+rand(),1);
            
            
update t_data_cle t set
            t.update_time = now(),
			t.x001=round(6+RAND()*2,2),
            t.x021=round((2800+RAND()*10),2),	
			t.x002=round(0.3+rand()/10*2,2),		
			t.x005=round(rand(),2),
            t.x024=round(2+rand(),1);
            
update t_data_ci t set
            t.update_time = now(),
            t.x141= '1',
            t.x241= '0',
            t.x341= '1',
            t.x441= '0',
            t.x541= '1',
			t.x121=round(x122+RAND()*2,2),
            t.x221=round(x222+RAND()*2,2),
            t.x321=round(x322+RAND()*2,2),
            t.x421=round(x422+RAND()*2,2),
            t.x521=round(x522+RAND()*2,2),
            t.x021=round((t.x121+t.x221+t.x321+t.x421+t.x521),2),
			t.x122=round(x122+RAND()*2,2),
            t.x222=round(x222+RAND()*2,2),
            t.x322=round(x322+RAND()*2,2),
            t.x422=round(x422+RAND()*2,2),
            t.x522=round(x522+RAND()*2,2),
            t.x022=round((t.x122+t.x222+t.x322+t.x422+t.x522),2);
            
update t_data_drug t set
             t.update_time = now(),
            t.x141= '1',
            t.x241= '0',
            t.x341= '1',
            t.x441= '0',
			t.x121=round(x122+RAND()*2,2),
            t.x221=round(x222+RAND()*2,2),
            t.x321=round(x322+RAND()*2,2),
            t.x421=round(x422+RAND()*2,2),
            t.x021=round((t.x121+t.x221+t.x321+t.x421),2),
			t.x122=round(x122+RAND()*2,2),
            t.x222=round(x222+RAND()*2,2),
            t.x322=round(x322+RAND()*2,2),
            t.x422=round(x422+RAND()*2,2),
            t.x022=round((t.x122+t.x222+t.x322+t.x422),2);
            
update t_data_swell t set
            t.update_time = now(),
           t.x124 = '3.4',
		   t.x224 = '3.7';

update t_data_ys_pump t set
            t.update_time = now(),
            t.x002=round(0.15+RAND()/10,2),	
             t.x121=round((5000+RAND()*1000),0),
            t.x221=round((5000+RAND()*1000),0),
		
            t.x122=round(t.x122+RAND()*2,0),
            t.x222=round(t.x222+RAND()*2,0),
        
			t.x124=round(2.9+rand()/10*2,2),
            t.x224=round(2.9+rand()/10*2,2),
			t.x125=round(0.29+rand()/100*2,2),
            t.x225=round(0.29+rand()/100*2,2),
		    t.x027=round(rand()*10,1),
            t.x028=round(RAND()*2,2);

update t_data_pump t set
            t.update_time = now(),
			t.x031=round(40+rand()*10,1),		
			t.x032=round((200+RAND()*10),1),
            t.x033=round(rand(),2),
			t.x034=round((380+RAND()*10),2),
			t.x023=round(0.12+rand()/100*2,2),
            t.x025=round(0.3+rand()/10*2,2),
            t.x026=round(0.3+rand()/10*2,2),
            t.x041='1',
            t.x044='0',
            t.x042=round(0.12+rand()/100*2,2),
            t.x043=round(40+rand()*5,1)
            where pump_id not in ('402806494d22f12e014d22f1f3cc0007','402806494d22f12e014d22f17eda0002','402806494d22f12e014d22f158a50001','297efa274cf8a8a1014cf8a8a41a000a','297efa274cf8a8a1014cf8a8a49c000d','297efa274cf8a8a1014cf8a8bdac0013','297efa274cf8a8a1014cf8a8be750022','297efa274cf8a8a1014cf8a8bcb3000f','297efa274cf8a8a1014cf8a8bd2c0011','297efa274cf8a8a1014cf8a8a2830005','297efa274cf8a8a1014cf8a8a1d20001');
 
  
 update t_data_pipe t set 
             t.update_time = now();
   
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
