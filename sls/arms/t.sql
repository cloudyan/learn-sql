
-- 各 api 占比
-- 统计指标说明: https://help.aliyun.com/document_detail/60288.html
-- 前端监控数据说明: https://help.aliyun.com/document_detail/447696.html
-- 共 11 类指标
-- api      API类型
-- pv       PV类型，主要计算PV、UV等指标
-- perf     页面性能情况
-- health   页面健康度
-- speed    自定义测速上报，测速关键字，取值范围为s0~s10
-- behavior 当异常出现后上报用户行为
-- error    JS 错误
-- resourceError 资源错误
-- sum      主动上报统计总和
-- avg      主动上报统计平均值
-- custom   自定义上报接口，所有字段不能超过20个字符，上报时会自动在字段前加上x -的前缀
-- res      资源加载情况



-- 指标样本量
environment: prod |
select
  "t",
  pv as PV,
  pv * 1.0 / sum(pv) over() as Percentage
from(
    select
      count(1) as pv,
      "t"
    FROM      (
        select
          "t"
        FROM          log
        limit
          10000000
      )
    group by
      "t"
    order by
      pv desc
  )
order by
  pv desc
limit
  100


-- 监控数据分析
environment: prod |
select
  t,
  count(1) as cnt
FROM log
group by t
order by t
limit 10000000

-- order by,      sampling -> times
-- pv,            10
-- health,        1
-- error,         times 各不同
-- behavior,      1
-- perf,          10
-- res,           10
-- resourceError, 1
-- api,           1
-- sum,           1
-- avg,
-- speed,
-- custom
environment: prod |
SELECT
  sum(if(t = 'pv', times, 0)) pv,
  approx_distinct(uid) as uv,
  sum(if(t = 'health', times, 0)) health,
  sum(if(t = 'error', times, 0)) error,
  sum(if(t = 'behavior', times, 0)) behavior,
  sum(if(t = 'perf', times, 0)) perf,
  sum(if(t = 'res', times, 0)) res,
  sum(if(t = 'resourceError', 1, 0)) resourceError,
  sum(if(t = 'api', times, 0)) api,
  sum(if(t = 'sum', times, 0)) sum
  sum(if(t = 'avg', times, 0)) avg,
  sum(if(t = 'speed', times, 0)) speed,
  sum(if(t = 'custom', times, 0)) custom
FROM      log
limit
  1000000






environment: prod |
select
  t1.cnt
FROM  (
    select
      t,
      count(1) as cnt
    FROM      log
    group by
      t
    limit
      1000000
  ) t1

environment: prod |
select
  pv,
  health,
  error,
  behavior,
  perf,
  res,
  resourceError as resErr,
  api,
  sum,
  avg,
  speed,
  custom
select
  t,
  count(1)
from log
group by t
limit 10000000


-- 是否可以用作告警？可以整体做粗略告警，无页面聚合分类

-- 每天汇总 report 报告
-- pv, uv 用于趋势观察
-- 75% 90% 性能指标点位？ 用于性能分析
-- 按应用
--    pv, uv 趋势观察
--    top10 错误通知
--    75% 90% 性能指标点位


-- 注意: perf 中可能存在无 fpt,fmp 的数据
environment: prod and t: perf and not fmp>=0
environment: prod and t: perf and not fpt>=0



-- 应用性能概要 summary 汇总 ✅
-- 10 分钟转存汇总数据 arms-summary
-- 参见 ./summary/summary.sql

-- 输出整体指标，以及每个应用的日稳定指标
-- JS 错误率
* |
select
  sum(err_pv)*1.0/sum(t_pv) err_rate,
  sum(t_pv) pv,
  sum(err_pv) err_pv,
  sum(t_error) err_cnt
-- 首屏秒开率
* |
select
  sum(fmp_s1)*1.0/sum(fmp_total) fmp_rate,
  sum(fmp_total) fmp_total,
  sum(fmp_s1) fmp_s1
-- 首屏秒开满意度 (T + (1~4T)/2)/total
* |
select
  round((0.0 + t1.cnt1 + t1.cnt2 / 2)*100 / t1.total, 2) fmp_apdex,
  t1.total fmp_total,
  t1.cnt1 fmp_good,
  t1.cnt2 fmp_mid,
  t1.total - t1.cnt1 - t1.cnt2 fmp_poor
from (
    select
      sum(fmp_s1) cnt1,
      sum(fmp_s2) + sum(fmp_s3) + sum(fmp_s4) cnt2,
      sum(fmp_s2) + sum(fmp_s3) + sum(fmp_s4) cnt2,
      sum(fmp_total) total
    from log
  ) t1



-- 小汇总
* |
select
  app_name,
  sum(fmp_s1)*1.0/sum(fmp_total) fmp_rate,
  sum(fmp_total) fmp_total,
  sum(fmp_s1) fmp_s1
group by
  app_name
order by
  app_name



* |
select
  app_name,
  round((0.0 + sum(fmp_s1) + (sum(fmp_s2) + sum(fmp_s3) + sum(fmp_s4)) / 2)*100 / sum(fmp_total), 2) fmp_apdex,
  sum(fmp_total) fmp_total,
  sum(fmp_s1) fmp_good,
  sum(fmp_s2) + sum(fmp_s3) + sum(fmp_s4) fmp_mid,
  sum(fmp_total) - sum(fmp_s1) - (sum(fmp_s2) + sum(fmp_s3) + sum(fmp_s4)) fmp_poor
group by
  app_name
order by
  app_name



-- 分析错误类型
environment: prod and t: error |
select
  '1.0' log_version,
  'xxx' app_name,
  'error_msg' log_type,

  -- 错误 msg 汇总，分析错误类型
  -- 怎么汇总？group by 分组排序

from log



