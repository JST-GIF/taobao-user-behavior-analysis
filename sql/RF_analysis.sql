USE taobaoyonghu;

WITH user_rf AS (
    #只看购买行为，算 R 和 F
    SELECT
        user_id,
        DATEDIFF('2017-12-03', MAX(date)) AS R,   # 最近购买距截止日的天数，越小越好
        COUNT(*)                          AS F    #购买次数，越大越好
    FROM userbehavior_clean
    WHERE behavior_type = 'buy'                        #列名按你表的实际调整
    GROUP BY user_id
),
rf_avg AS (
    SELECT AVG(R) AS avg_R, AVG(F) AS avg_F FROM user_rf
),
user_score AS (
    #R小于等于均值→"高"（最近买过）；F大于等于均值→"高"
    SELECT
        u.user_id, u.R, u.F,
        CASE WHEN u.R <= a.avg_R THEN '高' ELSE '低' END AS R_tag,
        CASE WHEN u.F >= a.avg_F THEN '高' ELSE '低' END AS F_tag
    FROM user_rf u
    CROSS JOIN rf_avg a
)

#四类映射 + 人数占比
SELECT
    CASE
        WHEN R_tag='高' AND F_tag='高' THEN '重要价值用户'
        WHEN R_tag='低' AND F_tag='高' THEN '重要保持用户'
        WHEN R_tag='高' AND F_tag='低' THEN '重要发展用户'
        ELSE '一般挽留用户'
    END AS 用户分层,
    COUNT(*) AS 人数,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS 占比pct
FROM user_score
GROUP BY 用户分层
ORDER BY 人数 DESC;
