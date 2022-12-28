
-- 页面 pv 及占比

* |
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
