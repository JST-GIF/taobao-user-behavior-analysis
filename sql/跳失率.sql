#跳失率，只进行了浏览没有进行深一步的行为的用户
use taobaoyonghu;

with tb as (
	select user_id,max(case when behavior_type in ('cart','fav','buy') then 1 else 0 end ) as ha_deep from userbehavior_clean group by user_id
)
select
	count(*) as `总分人数`,sum(case when ha_deep=0 then 1 else 0 end ) as `跳失用户数`,
	round(100*sum(case when ha_deep=0 then 1 else 0 end)/count(*),2) as `跳失率_pct`
from tb;
