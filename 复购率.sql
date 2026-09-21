#复购率：已经买过一次的用户里，有多少人又回来买了第二次
use taobaoyonghu;
with buy_users as(
	select user_id from userbehavior_clean where behavior_type ='buy'
),
buy_users_count as(
	select user_id ,count(*) as `buy_counts` from buy_users group by user_id having count(*)>=2
),
unique_buy_users as (
	select distinct user_id from buy_users 
)
select ROUND(100*(select count(*)from buy_users_count )/count(*),2) as '复购率' 
from unique_buy_users 