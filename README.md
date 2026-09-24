淘宝用户行为分析项目
基于阿里天池 UserBehavior 数据集，通过 Python 抽样 + SQL 分析 + 可视化，完成用户行为全链路分析。

项目背景
原始数据集约1亿条用户行为记录（98万用户），核心挑战：在大数据量、有限内存条件下完成完整分析流程。

技术栈
Python（pandas / matplotlib）：分块读取、抽样、清洗、可视化
MySQL：数据入库、窗口函数计算留存
Jupyter Notebook
Tableau

分析流程
数据抽样：分块读取，按用户维度随机抽样1万人
数据清洗：时间戳转换、剔除异常记录
指标构建：PV/UV、跳失率、复购率、D1/D3/D7留存率
可视化与结论

文件说明
notebooks/ ：Jupyter 分析笔记本
sql/ ：建表与查询脚本
data/ ：数据下载说明（数据量大不入库）
Tableau可视化链接：https://public.tableau.com/views/_17902206378000/1_1?:language=zh-CN&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link