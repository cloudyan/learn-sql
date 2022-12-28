
-- FMP 性能分布图

-- 默认 100 行数据

t: perf
and fmp: * |
select
  fmp / 100 * 1.0 / 10 fmp_time,
  count(1) cnt
from  log
group by
  fmp_time
order by
  fmp_time
limit
  1000000



-- fmp 时间分布图(去除长尾的数据)
t :perf
and environment :prod
and fmp: * and fmp<=10000 |
select
  fmp / 100 * 1.0 / 10 as fmp,
  count(1) cnt
FROM  log
GROUP BY
  fmp
ORDER BY
  fmp
LIMIT
  1000000



-- 告警设置，混入 context
t: perf
and environment: prod
and fmp >= 0 |
select
  'app_name' context,
  round((0.0 + t1.cnt1 + t1.cnt2 / 2) * 100 / t1.total, 2) result,
  t1.total
FROM  (
    select
      count_if(fmp <= 2000) cnt1,
      count_if(
        fmp > 2000
        and fmp <= 8000
      ) cnt2,
      count(1) total
    FROM      log
  ) t1


-- 时间对比
t :perf
and fmp: * |
select
  context,
  diff1 [1] as thisDayScore,
  diff1 [2] as lastDayScore,
  diff1 [3] as ratioScore,
  diff2 [1] as thisDayCnt,
  diff2 [2] as lastDayCnt,
  diff2 [3] as ratioCnt
FROM  (
    select
      compare(result, 86400) as diff1,
      compare(total, 86400) as diff2,
      context
    FROM      (
        select
          'app_name' context,
          round(
            (0.0 + t1.cnt1 + t1.cnt2 / 2) * 100 / t1.total,
            2
          ) result,
          t1.total
        FROM          (
            select
              count_if(fmp <= 2000) cnt1,
              count_if(
                fmp > 2000
                and fmp <= 8000
              ) cnt2,
              count(1) total
            FROM              log
          ) t1
      )
    group by
      context
  )


-- 多列展示数据（柱状图）
t:perf and environment: prod
and fmp: * |
select
  count_if(fmp <= 1000) s1,
  count_if(fmp > 1000 and fmp <= 2000) s2,
  count_if(fmp > 2000 and fmp <= 3000) s3,
  count_if(fmp > 3000 and fmp <= 4000) s4,
  count_if(fmp > 4000 and fmp <= 8000) s8,
  count_if(fmp > 8000) so,
  count(1) total
from      log
limit 1000000


-- 多行展示数据（支持线图，也支持饼图，自动计算占比）
t:perf and environment: prod
and fmp: * |
select
  CASE
    WHEN fmp <= 1000 THEN 's1'
    WHEN fmp > 1000 and fmp <= 2000 THEN 's2'
    WHEN fmp > 2000 and fmp <= 3000 THEN 's3'
    WHEN fmp > 3000 and fmp <= 4000 THEN 's4'
    WHEN fmp > 4000 and fmp <= 8000 THEN 's8'
    ELSE 'so'
  END as fmp_cnt,
  COUNT(*) cnt
FROM  log
GROUP by
  fmp_cnt
ORDER by
  fmp_cnt
limit
  1000000


-- 如果横坐标不等距，会导致数据峰值偏移，图上表现不真实
t:perf and environment: prod
and fmp: * |
select
  CASE
    WHEN fmp <= 500 THEN 's05'
    WHEN fmp > 500 and fmp <= 1000 THEN 's10'
    WHEN fmp > 1000 and fmp <= 1500 THEN 's15'
    WHEN fmp > 1500 and fmp <= 2000 THEN 's20'
    WHEN fmp > 2000 and fmp <= 3000 THEN 's30'
    WHEN fmp > 3000 and fmp <= 4000 THEN 's40'
    WHEN fmp > 4000 and fmp <= 8000 THEN 's80'
    ELSE 'so'
  END as fmp_cnt,
  COUNT(*) cnt
FROM  log
GROUP by
  fmp_cnt
ORDER by
  fmp_cnt
limit
  1000000


t:perf and environment: prod
and fmp: * |
select
  CASE
    WHEN fmp <= 500 THEN '0.5'
    WHEN fmp > 500 and fmp <= 1000 THEN '1.0'
    WHEN fmp > 1000 and fmp <= 1500 THEN '1.5'
    WHEN fmp > 1500 and fmp <= 2000 THEN '2.0'
    WHEN fmp > 2000 and fmp <= 2500 THEN '2.5'
    WHEN fmp > 2500 and fmp <= 3000 THEN '3.0'
    WHEN fmp > 3000 and fmp <= 3500 THEN '3.5'
    WHEN fmp > 3500 and fmp <= 4000 THEN '4.0'
    WHEN fmp > 4000 and fmp <= 4500 THEN '4.5'
    WHEN fmp > 4500 and fmp <= 5000 THEN '5.0'
    WHEN fmp > 5000 and fmp <= 6000 THEN '6.0'
    WHEN fmp > 6000 and fmp <= 8000 THEN '8.0'
    ELSE 'so'
  END as fmp_cnt,
  COUNT(*) cnt
FROM  log
GROUP by
  fmp_cnt
ORDER by
  fmp_cnt
limit
  1000000


-- 细分数据



t:perf and environment: prod
and fmp: * |
select
  t1.s1,
  t1.s2,
  t1.s3,
  t1.s4,
  t1.s8,
  t1.so,
  total
FROM  (
    select
      count_if(fmp <= 1000) s1,
      count_if(fmp > 1000 and fmp <= 2000) s2,
      count_if(fmp > 2000 and fmp <= 3000) s3,
      count_if(fmp > 3000 and fmp <= 4000) s4,
      count_if(fmp > 4000 and fmp <= 8000) s8,
      count_if(fmp > 8000) so,
      count(1) total
    from      log
    limit 1000000
  ) t1


t:perf and environment: prod
and fmp: * |
select
  CASE
    WHEN fmp <= 500 THEN '0.5'
    WHEN fmp > 500 and fmp <= 1000 THEN '1.0'
    WHEN fmp > 1000 and fmp <= 1500 THEN '1.5'
    WHEN fmp > 1500 and fmp <= 2000 THEN '2.0'
    WHEN fmp > 2000 and fmp <= 2500 THEN '2.5'
    WHEN fmp > 2500 and fmp <= 3000 THEN '3.0'
    WHEN fmp > 3000 and fmp <= 3500 THEN '3.5'
    WHEN fmp > 3500 and fmp <= 4000 THEN '4.0'
    WHEN fmp > 4000 and fmp <= 4500 THEN '4.5'
    WHEN fmp > 4500 and fmp <= 5000 THEN '5.0'
    WHEN fmp > 5000 and fmp <= 5500 THEN '5.5'
    WHEN fmp > 5500 and fmp <= 6000 THEN '6.0'
    WHEN fmp > 6000 and fmp <= 8000 THEN '8.0'
    ELSE 'so'
  END as fmp_cnt,
  COUNT(1) cnt
FROM  log
GROUP by
  fmp_cnt
ORDER by
  fmp_cnt
limit
  1000000

