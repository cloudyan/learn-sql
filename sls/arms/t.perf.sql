
-- 满意度 https://www.freshworks.com/website-monitoring/what-is-apdex/
-- 通过 APDEX 计算用户满意度
-- APDEX（全称Application Performance Index）应用程序性能指数是一个国际通用的应用性能计算标准。
-- 用于衡量用户对 Web 应用程序和服务响应时间的满意度。
--   Apdex 由公司联盟开发，旨在指定一种统一的方式来报告和衡量应用程序的性能。
--   Apdex 可帮助您以人性化的方式将您的测量结果转化为您的用户满意度的见解。
--   Apdex 以数字方式对满意度水平进行评分，分数范围为 0（用户不满意）到 1（用户满意）。
--   使用 Apdex，您可以提高应用程序的性能并在一段时间内跟踪用户满意度。
-- 该标准将用户对应用的体验定义为三个等级：
--   ● 满意（0~T）Good 具有高应用响应能力的满意用户。
--   ● 容忍（T~4T）Meh 应用程序响应明显缓慢的用户。
--   ● 沮丧（大于4T）Poor 无法接受的性能，导致用户放弃应用程序。

-- 为什么要使用 apdex 分数？
-- 仅计算应用程序响应时间是不够的。单独来看，它们并不能揭示使用您的应用程序的人是否对您的服务感到满意或沮丧。衡量您的应用程序性能以及它如何影响用户体验对您的业务非常重要。
-- 在企业中，留住客户并让他们满意与获得客户一样重要。Apdex 可帮助您了解和识别随着时间的推移对应用程序性能的影响。跟踪您的 Apdex 分数将帮助您专注于提高应用程序的性能并让您的用户满意。这会将他们变成忠诚的客户，并帮助您留住客户。

-- 计算公式：Apdex=(满意数+可容忍数/2)/总样本量

-- 什么是好的 Apdex 分数？
-- 一般来说，优秀的分数落在 1.00 - 0.94 之间。一个好的分数在 0.93 - 0.85 左右。公平分数在 0.84 - 0.70 之间，而差的分数在 0.69 到 0.49 之间。低于任何分数都被认为是不可接受的，用户可能会放弃该过程。
-- [0, 0.5, 0.7, 0.85, 0.94, 1]
-- [0, 0.5, 0.7, 0.8,  0.9,  1]
-- unacceptable, poor, fair, good, excellent

-- 定指标基准（并不是越严格越好？）
-- Apdex 以人性化的方式将您的测量结果转化为您的用户满意度的见解
-- 所以重点在定满意的基准 T
-- 什么值才算感觉到满意，可取 75% 参考。

-- 首屏时间满意度
-- 这里取 T = 两秒，计算 ADEPX, https://help.aliyun.com/document_detail/60288.html
-- 需要去排除 null 数据

t: perf and environment: prod and fmp:* |
select
  round((0.0 + t1.cnt1 + t1.cnt2 / 2) / t1.total, 2) result, t1.total
from  (
    select
      count_if(fmp <= 2000) cnt1,
      count_if(
        fmp > 2000
        and fmp <= 8000
      ) cnt2,
      count(1) total
    from      log
    limit 1000000
  ) t1



t: perf
and fpt: * |
select
  fpt / 100 * 1.0 / 10 fpt,
  count(1) cnt
from  log
group by
  fpt
order by
  fpt
limit
  1000000


t: perf
and fmp: * |
select
  fmp / 100 * 1.0 / 10 fmp,
  count(1) cnt
from  log
group by
  fmp
order by
  fmp
limit
  1000000




t: perf
and (
  fmp: *
  or fpt: *
) | with t1 as (
  select
    fmp / 100 * 1.0 / 10 time,
    count(1) fmp_cnt,
    0 fpt_cnt
  FROM    log
  group by
    time
  order by
    time
),
t2 as (
  select
    fpt / 100 * 1.0 / 10 time,
    0 fmp_cnt,
    count(1) fpt_cnt
  FROM    log
  group by
    time
  order by
    time
),
t3 as (
  SELECT
    *
  FROM    t1
  union
  SELECT
    *
  FROM    t2
)
SELECT
  time,
  max(fmp_cnt) fmp_cnt,
  max(fpt_cnt) fpt_cnt
FROM  t3
WHERE fpt_cnt < 5000
GROUP BY
  time
ORDER BY
  time
limit
  1000000


-- 哪些指标可观察
-- dns,ssl,tcp,ttfb,trans,firstbyte,dom,res
-- fmp,fpt,ready,tti,load
-- api_time,

-- 网络链路的指标？
-- 渲染性能的指标？
-- 接口性能的指标？api_time

-- 以 miscweb 一个月数据为参考（不同项目还不相同，以下为建议值，可根据实际情况调整）
-- 分区段采样 10 段

-- fpt 百毫秒分布(峰值 60ms, 最大范围 1000ms)
-- 建议汇总采样分段时间间隔: 50ms/100ms
-- [50,100,150,200,400,600,700,800,slow]
t: perf
and environment :prod
and fpt>=0 and fpt<=1000 |
select
  fpt / 10 * 1.0 / 10 as g_time,
  count(1) cnt
FROM  log
GROUP BY
  g_time
ORDER BY
  g_time
LIMIT
  1000000

-- api 耗时百毫秒分布 (峰值 100ms, 最大范围 3000ms)
-- 建议汇总采样分段时间间隔: 50ms/100ms
-- [50,100,150,200,300,400,500,600,700,800,900,slow]
t: api
and environment :prod
and time >= 0 and time <= 3000 |
select
  time / 10 * 1.0 / 10 as g_time,
  count(1) cnt
FROM  log
GROUP BY
  g_time
ORDER BY
  g_time
LIMIT
  1000000

-- fmp 秒分布(峰值 1.7s, 最大范围 10s)
-- 建议汇总采样分段时间间隔: 1000ms
t: perf
and environment :prod
and fmp>=0 and fmp<=10000 |
select
  fmp / 100 * 1.0 / 10 as g_time,
  count(1) cnt
FROM  log
GROUP BY
  g_time
ORDER BY
  g_time
LIMIT
  1000000


-- domReady (峰值 0.6s, 最大范围 10s)
-- 建议汇总采样分段时间间隔: 1000ms
t: perf
and environment :prod
and ready>=0 and ready<=10000 |
select
  ready / 100 * 1.0 / 10 as g_time,
  count(1) cnt
FROM  log
GROUP BY
  g_time
ORDER BY
  g_time
LIMIT
  1000000

-- load  (峰值 1.1s, 最大范围 10s)
-- 建议汇总采样分段时间间隔: 1000ms
t: perf
and environment :prod
and load>=0 and load<=10000 |
select
  load / 100 * 1.0 / 10 as g_time,
  count(1) cnt
FROM  log
GROUP BY
  g_time
ORDER BY
  g_time
LIMIT
  1000000



-- 小程序（峰值 1s, 最大范围 10s）
-- 建议汇总采样分段时间间隔: 1000ms
t: perf
and environment :prod
and launch>=0 and launch<=10000 |
select
  launch / 100 * 1.0 / 10 as g_time,
  count(1) cnt
FROM  log
GROUP BY
  g_time
ORDER BY
  g_time
LIMIT
  1000000


