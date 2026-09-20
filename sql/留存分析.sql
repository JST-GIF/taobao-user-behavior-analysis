USE taobaoyonghu;

WITH first_date AS (
#每个用户的首次活跃日期
    SELECT user_id, MIN(date) AS first_date
    FROM userbehavior_clean
    GROUP BY user_id
),
user_flag AS (
#每个用户是否在+N天回访：0/1标志
    SELECT 
        f.user_id, 
        f.first_date,
        MAX(CASE WHEN u.date = f.first_date + INTERVAL 1 DAY THEN 1 ELSE 0 END) AS flag_1d,
        MAX(CASE WHEN u.date = f.first_date + INTERVAL 3 DAY THEN 1 ELSE 0 END) AS flag_3d,
        MAX(CASE WHEN u.date = f.first_date + INTERVAL 7 DAY THEN 1 ELSE 0 END) AS flag_7d
    FROM first_date f
    JOIN userbehavior_clean u ON u.user_id = f.user_id
    GROUP BY f.user_id, f.first_date
),
max_date AS (
#数据最晚日期，作为成熟度判断基准
    SELECT MAX(date) AS max_dt FROM userbehavior_clean
)

#cohort级留存率（不成熟窗口=NULL）
SELECT 
    uf.first_date AS 首次活跃日,
    COUNT(*) AS 新增用户数,
    #次日留存：first_date + 1 <= 最晚日期 才计算
    ROUND(AVG(CASE WHEN uf.first_date + INTERVAL 1 DAY <= m.max_dt 
              THEN uf.flag_1d END), 2) AS rate_1d,
    #3日留存：first_date + 3 <= 最晚日期 才计算
    ROUND(AVG(CASE WHEN uf.first_date + INTERVAL 3 DAY <= m.max_dt 
              THEN uf.flag_3d END), 2) AS rate_3d,
    # 7日留存：first_date + 7 <= 最晚日期 才计算
    #注：数据窗口仅9天（11-25~12-03），无cohort能完整观测7日窗口，预期全列为NULL
    ROUND(AVG(CASE WHEN uf.first_date + INTERVAL 7 DAY <= m.max_dt 
              THEN uf.flag_7d END), 2) AS rate_7d
FROM user_flag uf
CROSS JOIN max_date m
GROUP BY uf.first_date
ORDER BY uf.first_date;
