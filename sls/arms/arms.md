# arms

统计指标说明：

- https://help.aliyun.com/document_detail/60288.html
- https://help.aliyun.com/document_detail/447696.html
- https://www.freshworks.com/website-monitoring/what-is-apdex/

共 11 类指标

1. api      API类型
2. pv       PV类型，主要计算PV、UV等指标
3. perf     页面性能情况
4. health   页面健康度
5. speed    自定义测速上报，测速关键字，取值范围为s0~s10
6. behavior 当异常出现后上报用户行为
7. error    JS 错误
8. resourceError 资源错误
9. sum      主动上报统计总和
10. avg      主动上报统计平均值
11. custom   自定义上报接口，所有字段不能超过20个字符，上报时会自动在字段前加上x -的前缀

### arms 的一些说明

1. sample 采样率字段仅对**性能**和**成功 API** 日志进行随机采样上报。
   1. arms 后台展示性能及性能告警相关数据，是经过结合采样率推导出的数据。
2. pvSample 会对 **pv** 日志进行随机采样上报。
   1. arms 后台展示的 pv 数据，是结合采样率推导出的数据。
   2. 但经过推导后，pv 和 uv 的比例失真了。
3. 官方推荐日均 pv 在 100 万以上的站点使用采样配置。

## 指标分析

1. 监控指标数据分析
2. JS 错误分析
   1. 错误率
   2. 错误数
   3. 样本数
   4. pv
   5. page
   6. 页面错误率排行 错误率/出错pv/总pv/分析样本量
3. 页面性能分析
   1. 访问速度 对比
      1. DNS
      2. FPT
      3. FMP/LCP
   2. 低访问速度 Top5
4. API 请求分析
5. 页面资源分析
6. 告警分析
   1. JS 错误告警 ERROR_RATE
   2. 首次渲染超时告警 FPT
   3. 首屏时间超时告警 FMP/LCP
7. 整体指标（前端核心指标）
   1. 日 pv,uv
   2. 10 分钟错误率
   3. 10 分钟首屏时间

指标计算方式：线性插值

- 直线计算：https://www.mathsisfun.com/straight-line-graph-calculate.html

核心指标-JS 错误率

 指标   |  60分  | 100分 | 实际达成 | 推导 0 分 | 斜率 | 截距 | 备注
------- | ----- | ----- | ------ | ---- | ---- |
2021-Q1 |       | 2%    | 1.7%
2021-Q2 |       | 1%    | 1.0%
2021-Q3 |       | 0.35% | 0.5%
2021-Q4 |       | 0.4%  | 0.98%
2022-Q1 |       |       | 0.47%
2022-Q2 | 1.94% | 0.35% | 0.15%
2022-Q3 | 0.97% | 0.20% | 0.13%
优化指标
2022-Q4 | 0.50% | 0.10% |      | y = −x + 110 |

核心指标-首屏时间

 指标   |  60分   | 100分 | 实际达成 | 推导 0 分 | 斜率 | 截距 | 备注
------- | ------ | ----- | ------ | ---- | ---- |
2021-Q1 |        | 900   | 438
2022-Q2 |        | 400   | 388
2022-Q3 |        | 370   | 379
2022-Q4 |        | 300   | 305
2022-Q1 |        | 300   | 266
2022-Q2 | 854.38 | 300   | 244
2022-Q3 | 390.47 | 300   | 252
优化指标，调整为百分比(当前值 65%)
2022-Q4 | 60%    | 70%   |     | y = 4x − 180 |


### 监控指标数据分析

可观测发现监控数据的统计特征以及异常

```sql
-- 监控指标数据分析
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
  sum(if(t = 'pv', 1, 0)) pv,
  approx_distinct(uid) as uv,
  sum(if(t = 'health', times, 0)) health,
  sum(if(t = 'error', times, 0)) error,
  sum(if(t = 'behavior', 1, 0)) behavior,
  sum(if(t = 'perf', 1, 0)) perf,
  sum(if(t = 'res', 1, 0)) res,
  sum(if(t = 'resourceError', 1, 0)) resourceError,
  sum(if(t = 'api', 1, 0)) api,
  sum(if(t = 'sum', 1, 0)) sum
  -- sum(if(t = 'avg', 1, 0)) avg,
  -- sum(if(t = 'speed', 1, 0)) speed,
  -- sum(if(t = 'custom', 1, 0)) custom
FROM      log
limit
  1000000
```

### JS 错误分析

计算错误率，前提是统计样本正常（样本量足够多）

```sql
-- 错误率 由 health 计算
t: health and environment: prod |
select
  (sum(times) - sum(healthy_times) * 1.0)/sum(times) as rate,
  sum(times) as health,
  approx_distinct(uid) as uv
limit 10000000
```

#### 页面错误排行 Top5

```sql

```

错误率整体统计指标

```js
var fmpList = [...document.querySelectorAll('[class^="style__progress-text"]')].map(item => {
  const score = Number(item.title.replace('%', ''));
  if (!Number.isNaN(score)) return score;
  return -1
}).filter(item => item != -1);

console.log(fmpList.length)
console.log(fmpList.reduce((sum, item) => {return sum + item}, 0)/fmpList.length)
```

### 页面访问性能分析

```sql

```

#### 高访问量 Top5

```sql

```

#### 低访问速度 Top5

```sql

```


### API 请求分析

```sql

```

### 页面资源分析

访问速度指标

```sql

```


### 告警设置

```sql

```
