
-- 采样量级要高，数据才趋于稳定 1000+

t: health
and environment: prod |
select
  date_trunc('day', __time__) as dt,
  count(1) as h_all
group by
  dt
order by
  dt
limit
  1000000

-- JS 错误率, JS 错误影响用户数
-- 计算公式：JS 错误率=发生过错误的 PV/总 PV
-- 错误率，这样的统计因为涉及到的查询量比较大，前端监控针对性的做了优化，在页面进行了预聚合，也就是health类型的上报，这个类型的上报会统计页面打开期间的错误数量，接口数量
-- 错误率是基于这个 health 做的统计
-- health 参看 https://help.aliyun.com/document_detail/447696.html#section-ulj-bk4-l7n
-- 注意：
-- 页面停留时间。为了防止页面停留时间过短，此处存在stay ≥ 2000的限制，逻辑与PV上报保持一致。
-- 因此，如果不停地切换页面，Health 日志中的API数据会比实际的数据少。

-- 错误率 由 health 计算
t: health and environment: prod |
select
  (sum(times) - sum(healthy_times) * 1.0)/sum(times) as rate,
  sum(times) as health,
  approx_distinct(uid) as uv
limit 10000000

-- health 数据的问题
-- 根据 pv,health 数据量对比，发现多个项目的 health 的数据存在异常，同 pv 数据量差异非常大。
-- 分析：
-- health 是页面卸载时上报，虽然有考虑使用 `Navigator.sendBeacon()` 保证数据可靠上报
-- 但我们项目还是大量项目该数据异常，几乎没都上报上来


-- 同时显示 pv,uv,health,h_y,h_n,error 样本量
environment: prod
and (
  t: health
  or t: pv
  or t: error
) |
select
  t1.pv,
  t1.uv,
  t1.health,
  t1.h_y,
  t1.health - t1.h_y as h_n,
  t1.e_t as error
FROM  (
    SELECT
      sum(if(t = 'health', times, 0)) health,
      sum(if(t = 'health', healthy_times, 0)) h_y,
      sum(if(t = 'error', times, 0)) e_t,
      sum(if(t = 'pv', 1, 0)) pv,
      approx_distinct(uid) as uv
    FROM      log
    limit
      1000000
  ) as t1

-- 所有样本量



-- 按天分组
t:health |
select
  count(1) as h_all,
  approx_distinct(uid) as uv,
  date_trunc('day', __time__) as dt
group by
  dt
order by
  dt
limit
  10000000

-- 按天分组, pv,error,uv,health,healthy,un_healthy
environment:prod |
select
  sum(if(t = 'health', times, 0)) health,
  sum(if(t = 'health', healthy_times, 0)) healthy,
  (sum(times) - sum(healthy_times)) as un_healthy,
  sum(if(t = 'error', times, 0)) error
  sum(if(t = 'pv', times, 0)) pv
  date_trunc('day', __time__) as dt
group by
  dt
order by
  dt
limit
  10000000


-- uv 比对(有点误差)
environment: prod and t:pv |
select
  count(1) as pv,
  approx_distinct(uid) as uv
limit
  1000000

environment: prod and t:health |
select
  approx_distinct(uid) as uv
limit
  1000000




-- 筛选域名分布
* |
select
  count(1) as pv,
  split_part(page, '%2F', 1) as path
group by
  path
order by
  pv desc
limit
  10

