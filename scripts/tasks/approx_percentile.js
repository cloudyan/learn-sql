// 计算分位数
//  @link: 这个才是sls的分位数的文档 https://help.aliyun.com/document_detail/63447.htm?#section-408-f86-n42
//  @link: 这个是 MaxCompute 的文档 https://help.aliyun.com/document_detail/48975.html#section-do0-b0t-s3q
//
// percentile_approx与percentile的区别如下：
//  - percentile_approx 用于计算近似的百分位数，percentile用于计算精确的百分位数。在数据量较大时，percentile可能会因内存限制而执行失败，而percentile_approx 无此问题。
//  - percentile_approx的实现与Hive的percentile_approx函数实现一致，计算的算法与percentile不同，因此在数据量非常少的部分场景下的执行结果与percentile的执行结果会有一定差别。
// TIP: 上面两个链接中文档不一样，函数命名也不一致
//    percentile_approx 用于 MaxCompute
//    approx_percentile 用于 sls 日志查询

/*
参考

context:xxx
and host:xxx-b-112-6phtd
and httpin |
select
    "msg.requestApi" as "应用api",
    count(1) as "调用量",
    round(avg("msg.responseInterval"),2) as "平均耗时",
    approx_percentile("msg.responseInterval", 0.50) as "TP50线",
    approx_percentile("msg.responseInterval", 0.90) as "TP90线",
    approx_percentile("msg.responseInterval", 0.95) as "TP95线",
    approx_percentile("msg.responseInterval", 0.99) as "TP99线"
group by "msg.requestApi"
order by count(1) desc


// 为保证数据可靠，调用量至少要 300
t:perf
and fmp>=0
and environment:prod |
select
    count(1) as "调用量",
    round(avg("fmp"),2) as "平均耗时",
    approx_percentile("fmp", 0.50) as "TP50线",
    approx_percentile("fmp", 0.75) as "TP75线",
    approx_percentile("fmp", 0.90) as "TP90线",
    approx_percentile("fmp", 0.95) as "TP95线",
    approx_percentile("fmp", 0.99) as "TP99线",
    (date / 1000) - (date / 1000)%600 as dt
    -- date_format(date / 1000, '%Y-%m-%d %H') as dt
group by dt
order by dt
limit 100000

每 10 分钟
__time__ - __time__ %600 as dt

*/

// 计算所有项目的分位数 75%, 90%
// 在所有项目中查找

const config = require('../config.private')
const { getLogsPromise } = require('../sls')

const endTime = new Date(new Date().toJSON().substr(0, 10))
const to = Math.floor(endTime / 1000)
const from = to - 86400 * 7

// 最近 30 天，各项目的每日 Apdex，含秒开率
const getPercentile = ({
  appName,
  logStoreName,
}) => {
  return getLogsPromise({
    from,
    to,
    logStoreName,
    query: `
t: perf
and environment: prod
and fmp >= 0 |
select
  '${appName}' app_name,
  -- 计算多个百分位
  percentile_approx(fmp, array(0.75, 0.9), 1000) fmp_p75_p90
from log
`,
  })
}

// 报错提示未注册
Promise.all(
  config.fmp_projects.map(getPercentile),
  // config.fmp_projects.map(getFmpApdexByDay),
)
  .then((res) => {
    const result = res.map((item) => item.body)
    console.log('result:', result)

    // const temp = result.reduce((obj, proj) => {
    //   const app_name = proj[0].app_name.padEnd(20, ' ')
    //   if (!obj[app_name]) obj[app_name] = []
    //   for (let key in proj) {
    //     const cur = proj[key]
    //     obj[app_name].push({
    //       fmp_apdex: Number(cur.fmp_apdex).toFixed(2),
    //       s1: Number(cur.s1_rate).toFixed(2),
    //       s2: Number(cur.s2_rate).toFixed(2),
    //     })

    //     total.fmp_s1 += Number(cur.fmp_s1)
    //     total.fmp_s2 += Number(cur.fmp_s2)
    //     total.fmp_s3 += Number(cur.fmp_s3)
    //     total.fmp_s4 += Number(cur.fmp_s4)
    //     total.fmp_total += Number(cur.total)
    //   }
    //   return obj
    // }, {})

    // console.log('fmpApdexByApp:', temp)

    // 计算比例

    // console.log('all:', all)
  })
  .catch((err) => {
    console.log('err:', err)
  })

// 思考: 找 75% 点位
//  1. 查找总数
//  2. 总数*0.75
//  3. 按 fmp 排序

// 在所有项目中执行，找出每个项目的点位

// const temp = result.reduce((obj, proj) => {
//   const app_name = proj[0].app_name;
//   if (!obj[app_name]) obj[app_name] = [];
//   for (const v of proj) {
//     obj[app_name].push(v.fmp_apdex)
//   }
//   return obj;
// }, {})
