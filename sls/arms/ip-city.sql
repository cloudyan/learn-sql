
-- IP 所在城市


* |
select
  "ip_city",
  pv as PV,
  pv * 1.0 / sum(pv) over() as Percentage
from(
    select
      count(1) as pv,
      "ip_city"
    FROM      (
        select
          "ip_city"
        FROM          log
        limit
          100000
      )
    group by
      "ip_city"
    order by
      pv desc
  )
order by
  pv desc
limit
  10
