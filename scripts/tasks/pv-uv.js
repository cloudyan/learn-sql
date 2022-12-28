
// pv, uv 曲线

`
t:pv
and environment: prod |
select
    sum(times) as pv,
    approx_distinct(uid) as uv,
    date_format(date / 1000, '%Y-%m-%d') as dt
group by dt
order by dt
`
