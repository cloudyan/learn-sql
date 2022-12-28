
-- 错误排行

t: error |
select
  "msg",
  pv as PV,
  pv * 1.0 / sum(pv) over() as Percentage
from(
    select
      count(1) as pv,
      "msg"
    FROM      (
        select
          "msg"
        FROM          log
        limit
          100000
      )
    group by
      "msg"
    order by
      pv desc
  )
order by
  pv desc
limit
  10


-- 错误率 由 health 计算
t: health and environment: prod |
select
  (sum(times) - sum(healthy_times) * 1.0)/sum(times) as rate,
  sum(times) as health,
  approx_distinct(uid) as uv
limit 10000000


-- 错误率计算 ✅
-- 当 health 数据不准确时，使用如下公式计算错误率指标
environment: prod |
SELECT
  err_cnt,
  err_pv,
  pv,
  ((err_pv * 1.0) / (pv * 1.0)) as rate
FROM (
    SELECT count(DISTINCT pv_id) as err_pv,
      count(times) as err_cnt
    FROM log
    WHERE t = 'error'
  ),
  (
    SELECT sum(times) as pv
    FROM log
    WHERE t = 'pv'
  )



-- 原始数据不准
environment: prod |
select
  sum(if(t = 'pv', times, 0)) t_pv,
  sum(if(t = 'health', times, 0)) t_health,
  sum(if(t = 'health', healthy_times, 0)) t_healthy_times,
  sum(if(t = 'error', times, 0)) t_error,

  -- 错误PV 监控汇总
  (select
    count(distinct pv_id) as err_pv
    from log
    where t = 'error') err_pv
from log
