
-- PV group by path TOP10

* |
select
  count(1) as pv,
  split_part(request_uri, '?', 1) as path
group by
  path
order by
  pv desc
limit
  10
