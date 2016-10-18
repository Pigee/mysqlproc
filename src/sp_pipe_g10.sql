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

-- 导出  过程 fh_xydd.sp_pipe_g10 结构
DROP PROCEDURE IF EXISTS `sp_pipe_g10`;
DELIMITER //
CREATE DEFINER=`fh_xyddadmin`@`%` PROCEDURE `sp_pipe_g10`(paraId varchar(36) charset gbk,paraDate varchar(30) charset gbk,paraInter varchar(12) charset gbk)
BEGIN

declare s1 int;
declare daycounts int;
declare initime varchar(30) charset gbk;

drop temporary table if exists pipeg10;
create temporary table pipeg10(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk);

drop temporary table if exists pipend;
create temporary table pipend(timecol varchar(30) charset gbk,valuecol varchar(30) charset gbk);

insert into pipend(timecol) values ('最大值');
insert into pipend(timecol) values ('最大时间');
insert into pipend(timecol) values ('最小值');
insert into pipend(timecol) values ('最小时间');
insert into pipend(timecol) values ('平均值');
insert into pipend(timecol) values ('总计');
set initime = paraDate;


if paraInter = '30' then
set s1 = 1;
while s1 <= 48 do
insert into pipeg10 select initime,round(t1.g10-t2.g10,3) from (select g10 from t_data_pipe_his where update_time = date_add(initime,interval 30 minute) and local_id = paraId) t1,(select g10 from t_data_pipe_his where update_time = initime and local_id = paraId) t2;
set s1 = s1 + 1;
set initime = date_add(initime,interval 30 minute);
end while;
update pipend set valuecol = (select max(valuecol) from pipeg10 ) where timecol = '最大值';
update pipend set valuecol = (select date_format(timecol,'%H:%i:%s') from pipeg10 order by valuecol desc limit 1 ) where timecol = '最大时间';
update pipend set valuecol = (select min(valuecol) from pipeg10 ) where timecol = '最小值';
update pipend set valuecol = (select date_format(timecol,'%H:%i:%s') from pipeg10 where valuecol is not null order by valuecol asc limit 1 ) where timecol = '最小时间';
update pipend set valuecol = (select round(avg(valuecol),3) from pipeg10 ) where timecol = '平均值';
update pipend set valuecol = (select round(sum(valuecol),3) from pipeg10 ) where timecol = '总计';
insert into pipend select date_format(timecol,'%H:%i:%s'),valuecol from pipeg10;
end if;

if paraInter = '60' then
set s1 = 1;
while s1 <= 24 do
insert into pipeg10 select initime,round(t1.g10-t2.g10,3) from (select g10 from t_data_pipe_his where update_time = date_add(initime,interval 60 minute) and local_id = paraId) t1,(select g10 from t_data_pipe_his where update_time = initime and local_id = paraId) t2;
set s1 = s1 + 1;
set initime = date_add(initime,interval 60 minute);
end while;
update pipend set valuecol = (select max(valuecol) from pipeg10 ) where timecol = '最大值';
update pipend set valuecol = (select date_format(timecol,'%H:%i:%s') from pipeg10 order by valuecol desc limit 1 ) where timecol = '最大时间';
update pipend set valuecol = (select min(valuecol) from pipeg10 ) where timecol = '最小值';
update pipend set valuecol = (select date_format(timecol,'%H:%i:%s') from pipeg10 where valuecol is not null order by valuecol asc limit 1 ) where timecol = '最小时间';
update pipend set valuecol = (select round(avg(valuecol),3) from pipeg10 ) where timecol = '平均值';
update pipend set valuecol = (select round(sum(valuecol),3) from pipeg10 ) where timecol = '总计';
insert into pipend select date_format(timecol,'%H:%i:%s'),valuecol from pipeg10;
end if;

if paraInter = '120' then
set s1 = 1;
while s1 <= 12 do
insert into pipeg10 select initime,round(t1.g10-t2.g10,3) from (select g10 from t_data_pipe_his where update_time = date_add(initime,interval 120 minute) and local_id = paraId) t1,(select g10 from t_data_pipe_his where update_time = initime and local_id = paraId) t2;
set s1 = s1 + 1;
set initime = date_add(initime,interval 120 minute);
end while;
update pipend set valuecol = (select max(valuecol) from pipeg10 ) where timecol = '最大值';
update pipend set valuecol = (select date_format(timecol,'%H:%i:%s') from pipeg10 order by valuecol desc limit 1 ) where timecol = '最大时间';
update pipend set valuecol = (select min(valuecol) from pipeg10 ) where timecol = '最小值';
update pipend set valuecol = (select date_format(timecol,'%H:%i:%s') from pipeg10 where valuecol is not null order by valuecol asc limit 1 ) where timecol = '最小时间';
update pipend set valuecol = (select round(avg(valuecol),3) from pipeg10 ) where timecol = '平均值';
update pipend set valuecol = (select round(sum(valuecol),3) from pipeg10 ) where timecol = '总计';
insert into pipend select date_format(timecol,'%H:%i:%s'),valuecol from pipeg10;
end if;


if paraInter = '99' then
SELECT  TIMESTAMPDIFF(day,paraDate,(DATE_add(paraDate,INTERVAL 1 month))) into daycounts;
set s1 = 1;
insert into pipeg10 select date_time,g10_day from t_static_pipe where  date_format(date_time,'%Y-%m') = date_format(paraDate,'%Y-%m')  and local_id = paraId;
while s1 <= daycounts do

insert into pipend(timecol) select initime ;
set s1 = s1 + 1;
set initime = date_add(initime,interval 1 day);
end while;
update pipend set valuecol = (select max(valuecol) from pipeg10 ) where timecol = '最大值';
update pipend set valuecol = (select timecol from pipeg10 order by valuecol desc limit 1) where timecol = '最大时间';
update pipend set valuecol = (select min(valuecol) from pipeg10 ) where timecol = '最小值';
update pipend set valuecol = (select timecol from pipeg10 where valuecol is not null order by valuecol asc limit 1 ) where timecol = '最小时间';
update pipend set valuecol = (select round(avg(valuecol),3) from pipeg10 ) where timecol = '平均值';
update pipend set valuecol = (select round(sum(valuecol),3) from pipeg10 ) where timecol = '总计';

update pipend t1,pipeg10 t2 set t1.valuecol = t2.valuecol where t1.timecol=t2.timecol;
end if;

update pipend set valuecol = '' where valuecol IS NULl;
select *  from pipend;

end//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
