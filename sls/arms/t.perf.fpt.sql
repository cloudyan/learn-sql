
-- 首次渲染时间
t :perf
and environment :prod
and fpt |
select
  count(1),
  count_if(fpt > 900)
FROM  log
limit
  1000000

-- fpt 波动较大（fpt>900） 告警指标
-- 1. 按页面聚合
-- 2. 按 fpt 排序
-- 3. 取 均值 超过 900
--    排除过长时间长尾的影响，可通过排序取前 90% 求平均值
--    排除样本总量较低的误报，至少采样量达到多少量级
--    排除采样率的影响



-- 页面访问排名
t: perf
and environment :prod
and fpt > 900 |
select
  "page",
  pv as PV,
  pv * 1.0 / sum(pv) over() as Percentage
from(
    select
      count(1) as pv,
      "page"
    FROM      (
        select
          "page"
        FROM          log
        limit
          100000
      )
    group by
      "page"
    order by
      pv desc
  )
order by
  pv desc
limit
  10



