
-- PV预测

-- nginx访问日志的PV预测 __time__ - __time__ % 60 ，将time时间戳减去，time时间戳对60的余数，得到按分钟对齐的时间stamp，用group by对stamp聚合，用COUNT函数计算每分钟的次数，将得到的结果作为一个子查询，用ts_predicate_simple函数，预测未来6个点的情况 点击查询后自动按时序图进行展示


* |
select
  ts_predicate_simple(stamp, value, 6)
from
  (
    select
      __time__ - __time__ % 60 as stamp,
      COUNT(1) as value
    from
      log
    GROUP BY
      stamp
    order by
      stamp
  )
LIMIT
  1000
