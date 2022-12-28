

const config = require('../config.private');
const { getLogsPromise } = require('../sls');

const to = Math.floor(new Date().getTime() / 1000)
const from = to - 86400*30;

// 最近 30 天，各项目的每日 Apdex
const getFptApdexByAppByDay = ({
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
and fpt >= 0 |
select
  '${appName}' app_name,
  round((0.0 + t1.cnt1 + t1.cnt2 / 2) * 100 / t1.total, 2) fpt_apdex,
  t1.total,
  t1.dt
FROM  (
    select
      count_if(fpt <=  50) cnt1,
      count_if(
        fpt >  50
        and fpt <= 200
      ) cnt2,
      count(1) total,
      date_format(date / 1000, '%Y-%m-%d') as dt
    FROM      log
    group by dt
    order by dt
  ) t1
  `});
};

Promise.all(
  config.fpt_projects.map(getFptApdexByAppByDay),
).then(res => {
  const result = res.map(item => item.body)
  // console.log('result:', result)
  const temp = result.reduce((obj, proj) => {
    const app_name = proj[0].app_name;
    if (!obj[app_name]) obj[app_name] = [];
    for (let key in proj) {
      const cur = proj[key]
      obj[app_name].push({
        dt: cur.dt,
        fpt_apdex: cur.fpt_apdex,
      })
    }
    return obj;
  }, {});

  console.log('fptApdexbyAppByDay:', temp);
}).catch(err => {
  console.log('err:', err);
});


// 看趋势变化
// 拉取一个项目，获取每天的趋势变化
// 按天分组
// date_trunc('day', __time__) as dt
// date_format(date / 1000, '%Y-%m-%d') as dt
//
// apdex 算法
`
t: perf
and environment: prod
and fpt >= 0 |
select
  round((0.0 + t1.cnt1 + t1.cnt2 / 2) * 100 / t1.total, 2) result,
  t1.total,
  t1.dt
FROM  (
    select
      count_if(fpt <=  1000) cnt1,
      count_if(
        fpt >  1000
        and fpt <= 4000
      ) cnt2,
      count(1) total,
      date_format(date / 1000, '%Y-%m-%d') as dt
      -- date_trunc('day', __time__) as dt
    FROM      log
    group by dt
    order by dt
  ) t1
`


// 思考: 找 75% 点位
//  1. 查找总数
//  2. 总数*0.75
//  3. 按 fpt 排序

// 在所有项目中执行，找出每个项目的点位


// const temp = result.reduce((obj, proj) => {
//   const app_name = proj[0].app_name;
//   if (!obj[app_name]) obj[app_name] = [];
//   for (const v of proj) {
//     obj[app_name].push(v.fpt_apdex)
//   }
//   return obj;
// }, {})
