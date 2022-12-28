# learn-sql

## SQL

- [SQL 教程](https://www.runoob.com/sql/sql-tutorial.html)
- [SQL 快速参考](https://www.runoob.com/sql/sql-quickref.html)
- [SQLite 教程](https://www.runoob.com/sqlite/sqlite-tutorial.html)
  - https://sqlite.org/fiddle/index.html

## sls 文档

【必读】

- [查询语法](https://help.aliyun.com/document_detail/29060.html)
  - [SQL分析语法与功能](https://help.aliyun.com/document_detail/63443.html)
  - [SQL 函数](https://help.aliyun.com/document_detail/322173.html)
    - [窗口函数](https://help.aliyun.com/document_detail/34994.html#section-y0h-psg-py3)
    - [日期和时间函数](https://help.aliyun.com/document_detail/63451.html)
  - [SQL语法](https://help.aliyun.com/document_detail/322174.html)

## 大数据计算服务 MaxCompute

- [大数据计算服务 MaxCompute](https://help.aliyun.com/apsara/enterprise/v_3_16_2_20220708/odps/enterprise-ascm-user-guide/what-is-maxcompute.html)
- [内建函数](https://help.aliyun.com/document_detail/48969.html)
  - [分位数](https://help.aliyun.com/document_detail/48975.html#section-do0-b0t-s3q)

### SDK

- [API 参考](https://help.aliyun.com/document_detail/29006.html)
  - [日志库相关接口](https://help.aliyun.com/document_detail/29014.html)
  - [GetLogs](https://help.aliyun.com/document_detail/29029.html)
    - 请求参数from和to定义的时间区间遵循左闭右开原则
  - [ListLogStores](https://help.aliyun.com/document_detail/426970.html)
- [SLS SDK](https://help.aliyun.com/document_detail/141789.html)
- [采集-通过WebTracking采集日志](https://help.aliyun.com/document_detail/67246.htm)
  - [使用Web Tracking采集日志](https://help.aliyun.com/document_detail/31752.htm)
  - [浏览器JavaScript SDK](https://help.aliyun.com/document_detail/427748.htm)

### sls 查询

日志数据默认返回前100条，您可以使用LIMIT语法修改返回数据的条数。

- https://help.aliyun.com/document_detail/63470.htm

### 数据可视化

- [ECharts Examples](https://echarts.apache.org/examples/zh/index.html)
- 数据分析，可使用
  - 日历热力图（绿色 -> 红色）
  - markLine 折线图（均线，目标线，最大值与最小值）


## SQL 练习题

- https://blog.csdn.net/weixin_39683021/article/details/111297321
- https://blog.csdn.net/qq_41652136/article/details/105949372
- https://zhuanlan.zhihu.com/p/92654574

- 用户访问次数表，列名包括用户编号、用户类型、访问量。要求在剔除访问次数前20%的用户后，每类用户的平均访问次数。(拼多多、网易面试题)
- 拆解为 3 个子问题
   1. 找出访问次数前 20% 的用户（窗口函数）
   2. 剔除访问次数前 20% 的用户
   3. 每类用户的平均访问次数（汇总函数）

```sql
-- 子问题 1
-- 对所有用户的访问量按从低到高的顺序用窗口函数排名, 然后筛选出排名前20%
select *
from (select
  *,
  row_number() over (order by pv desc) as rank
  from pv_table) a
where rank<= (select max(rank) from a) * 0.2

-- 子问题 2
-- 剔除前 20，将上面的<= 改为 > 即可
select *
from (
  select
  *,
  row_number() over(order by pv desc) as rank
  from pv_table
) as a
where rank > (select max(rank) from a) * 0.2;


-- 子问题 3
-- 每类用户的平均访问次数, 分组求平均
select
  user_type,
  avg(pv)
from (
  select *
  from (
    select *,
    row_number() over(order by pv desc) as rank
    from pv_table
  ) as a
  where rank > (select max(rank) from a) * 0.2
) as b
group by user_type;


-- 最终方案
select
  用户类型,
  avg(访问量)
from (
    select *
    from (
        select *,
        row_number() over(order by 访问量 desc) as 排名
        from 用户访问次数表
    ) as a
where 排名 > (
  select max(排名) from a) * 0.2
) as b
group by 用户类型;
```

我们计算 75% 分位数，可以先找出 70% 到 80% 的数据，再求平均值

```sql
t: perf
and fmp >= 0
and environment: prod |
select
  fmp,
  rank,
  cnt
FROM  (
    select
        fmp,
        row_number() over(order by fmp) as rank,
        (select count(1) FROM log) cnt
    FROM log
    limit 1000000
    ) as t1
where
  rank > cnt * 0.75


-- 直接用 max 怎么不行
t: perf
and fmp >= 0
and environment: prod |
select *
from (
    select
        fmp,
        row_number() over(order by fmp) as rank
    FROM  log
    limit 1000000
    ) as t1
where
  rank > (select max(rank)) * 0.75
```

- row_number()
- count(列名) 求某列的行数
- sum(列名) 对某列数据求和（只能对数值类型的列计算）
- avg(列名) 对某列数据求平均值
- max(列名) 求某列的最大值
- min(列名) 求某列的最小值
- distinct(列名) 计数指定列的唯一非空值行
