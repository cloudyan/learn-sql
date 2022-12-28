
-- 流入流出流量统计

-- nginx 流入流出的流量统计
-- 通过date_trunc函数将__time__对齐到小时（__time__为系统字段，日志采集的时间，默认为秒时间戳），
-- 用date_format函数将对齐的结果进行格式化，
-- 用group by将对齐的时间聚合，用sum函数计算出每小时流量合计
-- 通过线图进行展示，X轴设置为time，左Y轴选择net_out和net_in

* |
select
  sum(body_bytes_sent) as net_out,
  sum(request_length) as net_in,
  date_format(date_trunc('hour', __time__), '%m-%d %H:%i') as time
group by
  date_format(date_trunc('hour', __time__), '%m-%d %H:%i')
order by
  time
limit
  10000

