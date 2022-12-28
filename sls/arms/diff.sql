t: perf
and fmp>=0 |
select
  context,
  diff1 [1] as thisDayScore,
  diff1 [2] as lastDayScore,
  diff1 [3] as ratioScore, -- 今天与昨天比例
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
          'xxx' context,
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
