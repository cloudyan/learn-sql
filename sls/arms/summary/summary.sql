
-- 数据转存


-- 注意: perf 中可能存在无 fpt,fmp 的数据
environment: prod and t: perf and not fmp>=0
environment: prod and t: perf and not fpt>=0


-- 应用性能概要 summary 汇总 ✅
-- 10 分钟转存汇总数据 arms-summary
environment: prod |
select
  '' app_name,
  'summary' log_type,
  'v1.1' log_version,

  -- 所有日志计算 uv
  approx_distinct(uid) as uv,

  -- 监控指标分布及真实日志条数
  sum(if(t = 'pv', times, 0)) t_pv,
  sum(if(t = 'pv', 1, 0)) t_pv_cnt,
  sum(if(t = 'health', times, 0)) t_health,
  sum(if(t = 'health', healthy_times, 0)) t_healthy_times,
  sum(if(t = 'health', 1, 0)) t_health_cnt,
  sum(if(t = 'error', times, 0)) t_error,
  sum(if(t = 'error', 1, 0)) t_error_cnt,
  sum(if(t = 'behavior', times, 0)) t_behavior,
  sum(if(t = 'behavior', 1, 0)) t_behavior_cnt,
  sum(if(t = 'perf', times, 0)) t_perf,
  sum(if(t = 'perf', 1, 0)) t_perf_cnt,
  sum(if(t = 'res', times, 0)) t_res,
  sum(if(t = 'res', 1, 0)) t_res_cnt,
  sum(if(t = 'resourceError', times, 0)) t_resourceError,
  sum(if(t = 'resourceError', 1, 0)) t_resourceError_cnt,
  sum(if(t = 'api', times, 0)) t_api,
  sum(if(t = 'api', success, 0)) t_api_success,
  sum(if(t = 'api', 1, 0)) t_api_cnt,
  sum(if(t = 'avg', times, 0)) t_avg,
  sum(if(t = 'avg', 1, 0)) t_avg_cnt,
  sum(if(t = 'speed', times, 0)) t_speed,
  sum(if(t = 'speed', 1, 0)) t_speed_cnt,
  sum(if(t = 'custom', times, 0)) t_custom,
  sum(if(t = 'custom', 1, 0)) t_custom_cnt,
  sum(if(t = 'sum', times, 0)) t_sum,
  sum(if(t = 'sum', 1, 0)) t_sum_cnt,

  -- fpt 监控(仅使用右区间)
  count_if(t = 'perf' and fpt <= 50) fpt_s0_5,
  count_if(t = 'perf' and fpt <= 100) fpt_s1,
  count_if(t = 'perf' and fpt <= 150) fpt_s1_5,
  count_if(t = 'perf' and fpt <= 200) fpt_s2,
  count_if(t = 'perf' and fpt <= 300) fpt_s3,
  count_if(t = 'perf' and fpt <= 400) fpt_s4,
  count_if(t = 'perf' and fpt <= 800) fpt_s8,
  count_if(t = 'perf' and fpt >= 0) fpt_total,

  -- fmp 监控汇总
  count_if(t = 'perf' and fmp <= 500) fmp_s0_5,
  count_if(t = 'perf' and fmp <= 1000) fmp_s1,
  count_if(t = 'perf' and fmp <= 1500) fmp_s1_5,
  count_if(t = 'perf' and fmp <= 2000) fmp_s2,
  count_if(t = 'perf' and fmp <= 3000) fmp_s3,
  count_if(t = 'perf' and fmp <= 4000) fmp_s4,
  count_if(t = 'perf' and fmp <= 5000) fmp_s5,
  count_if(t = 'perf' and fmp <= 6000) fmp_s6,
  count_if(t = 'perf' and fmp <= 7000) fmp_s7,
  count_if(t = 'perf' and fmp <= 8000) fmp_s8,
  count_if(t = 'perf' and fmp >= 0) fmp_total,

  -- api 监控汇总
  count_if(t = 'api' and time <= 50) api_time_s0_5,
  count_if(t = 'api' and time <= 100) api_time_s1,
  count_if(t = 'api' and time <= 150) api_time_s1_5,
  count_if(t = 'api' and time <= 200) api_time_s2,
  count_if(t = 'api' and time <= 300) api_time_s3,
  count_if(t = 'api' and time <= 400) api_time_s4,
  count_if(t = 'api' and time <= 500) api_time_s5,
  count_if(t = 'api' and time <= 600) api_time_s6,
  count_if(t = 'api' and time <= 700) api_time_s7,
  count_if(t = 'api' and time <= 800) api_time_s8,
  count_if(t = 'api' and time >= 0) api_time_total,

  -- 错误PV 监控汇总
  (SELECT
    count(DISTINCT pv_id) as err_pv
    FROM log
    WHERE t = 'error') err_pv,

  -- 采样率
  (SELECT
    sampling
    FROM log
    WHERE t = 'pv' limit 1) pv_sampling,
  (SELECT
    sampling
    FROM log
    WHERE t = 'perf' limit 1) perf_sampling
from log


-- 小程序无 fmp 改为 launch

-- fmp 监控汇总
  count_if(t = 'perf' and launch <= 500) launch_s0_5,
  count_if(t = 'perf' and launch <= 1000) launch_s1,
  count_if(t = 'perf' and launch <= 1500) launch_s1_5,
  count_if(t = 'perf' and launch <= 2000) launch_s2,
  count_if(t = 'perf' and launch <= 3000) launch_s3,
  count_if(t = 'perf' and launch <= 4000) launch_s4,
  count_if(t = 'perf' and launch <= 5000) launch_s5,
  count_if(t = 'perf' and launch <= 6000) launch_s6,
  count_if(t = 'perf' and launch <= 7000) launch_s7,
  count_if(t = 'perf' and launch <= 8000) launch_s8,
  count_if(t = 'perf' and launch >= 0) launch_total,


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
  round((0.0 + sum(fmp_s1) + (sum(fmp_s4) - sum(fmp_s1)) / 2)*100 / sum(fmp_total), 2) fmp_apdex,
  sum(fmp_total) fmp_total,
  sum(fmp_s1) fmp_good,
  sum(fmp_s4) - sum(fmp_s1) fmp_mid,
  sum(fmp_total) - sum(fmp_s4) fmp_poor
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
