
const config = require('../config.private');
const { getLogsPromise } = require('../sls');

const today = new Date().toJSON().substr(0,10).replace('-', '/');
const todayZero = Math.floor(new Date(`${today} 00:00:00`).getTime() / 1000);
const to = Math.floor(new Date()/1000)
const from = todayZero - 86400*7;

// to 取现在
// from 取过去的 N 天数

// 制作整体图表或错误率，推荐使用原始库(因加工 err_pv，可临时使用 arms 汇总库）
// 其他情况，可以直接使用原始库
// js 错误率
function getErrorRate() {
  return getLogsPromise({
    from,
    to,
    query: `
* |
select
  sum(err_pv)*1.0/sum(t_pv) err_rate,
  sum(t_pv) pv,
  sum(err_pv) err_pv,
  sum(t_error) err_cnt
  `});
}

function getErrorRateByApp() {
  return getLogsPromise({
    from,
    to,
    query: `
* |
select
  app_name,
  round(sum(err_pv)*1.0/sum(t_pv)*1000, 1) err_rate,
  sum(t_pv) pv,
  sum(err_pv) err_pv,
  sum(t_error) err_cnt
group by
  app_name
order by
  app_name
  `});
}

// 错误率 by APP 及汇总
// Promise.all([
//   getErrorRateByApp(),
//   getErrorRate(),
// ]).then(res => {
//   console.log(res)
//   let [ byApp, all ] = res;
//   byApp = byApp.body;
//   all = all.body[0];
//   console.log('byApp:', byApp);
//   console.log('all:', all);
// }).catch(err => {
//   console.log('err:', err);
// });


// 错误率汇总 byDay 趋势变化
// 先取各项目 err_pv total_pv，加起来 by Day


// 使用 arms-summary 数据
function getErrorRateByDay() {
  return getLogsPromise({
    from,
    to,
    logStoreName: config.logStoreName,
    query: `
* |
select
  sum(err_pv)*1.0/sum(t_pv) err_rate,
  sum(t_pv) pv,
  sum(err_pv) err_pv,
  sum(t_error) err_cnt,
  date_format(date, '%Y-%m-%d') as dt
group by dt
order by dt
  `});
}

// 无法使用arms-summary 按天分组 date
// 400: {"errorCode":"ParameterInvalid","errorMessage":"line 7:15: Column 'date' cannot be resolved;please add the column in the index attribute"}
// Promise.all([
//   getErrorRateByDay()
// ]).then(res => {
//   console.log(res);
// })


// 使用原始 store 数据
const getErrorRateByOriginStore = ({
  appName,
  logStoreName,
}) => {
  return getLogsPromise({
    from,
    to,
    logStoreName,
    query: `
environment: prod |
select
  '${appName}' app_name,
  sum(if(t = 'pv', times, 0)) t_pv,
  sum(if(t = 'error', times, 0)) t_error,
  (SELECT
    count(DISTINCT pv_id) as err_pv
    FROM log
    WHERE t = 'error') err_pv
from log
  `});
};

// 参考
// t: pv |
// select
//   sum(times) as pv ,
//   approx_distinct(uid) as uv ,
//   (date- 28800000 - date%86400000) as date
// WHERE date>=1667890860000 AND date<1668582060000
// group by date

const query1 = appName => `
environment: prod |
select
  '${appName}' app_name,
  sum(if(t = 'pv', times, 0)) t_pv,
  sum(if(t = 'error', times, 0)) t_error,
  (SELECT
    count(DISTINCT pv_id) as err_pv
    FROM log
    WHERE t = 'error') err_pv,
  date_trunc('day', __time__) as dt
from log
group by dt
order by dt
`

// 按自然日划分天数, byDay 输出 ByApp 及汇总的指标
// https://help.aliyun.com/document_detail/63451.html
// 计算思路：按天分组查询错误 pv 和总 pv，按天左连接汇总
const query2 = appName => `
environment: prod |
select
  '${appName}' app_name,
  t1.t_pv,
  if(t2.t_error is null, 0, t2.t_error) t_error,
  if(t2.err_pv is null, 0, t2.err_pv) err_pv,
  t1.dt
FROM
  (select
      sum(if(t = 'pv', times, 0)) t_pv,
      date_trunc('day', __time__) as dt
    FROM log
    where(t = 'pv')
    group by dt
    order by dt
  ) t1
  left join
  (select
      count(times) t_error,
      count(DISTINCT pv_id) as err_pv,
      date_trunc('day', __time__) as dt
    FROM log
    where(t = 'error')
    group by dt
    order by dt
  ) t2
on t1.dt = t2.dt
`


const getErrorRateByDayByOriginStore = ({
  appName,
  logStoreName,
}) => {
  return getLogsPromise({
    from,
    to,
    logStoreName,
    query: query2(appName),
  });
};





// 处理时间（各有优劣）
// --(date- 28800000 - date%86400000) as dt
// date_trunc('day', __time__) as dt
// date_format(date / 1000, '%Y-%m-%d') as dt

// environment: prod |
// SELECT
//   count(DISTINCT pv_id) as err_pv,
//   date_format(date / 1000, '%Y-%m-%d') as dt
//   FROM log
//   WHERE t = 'error'
// group by dt
// order by dt


// select
//  t1.t_pv,
//  t1.t_error,
//  t2.err_pv,
//  t1.dt
// select (select
//   sum(if(t = 'pv', times, 0)) t_pv,
//   sum(if(t = 'error', times, 0)) t_error,
//   date_format(date / 1000, '%Y-%m-%d') as dt
//   from log
//   group by dt
//   order by dt) join (SELECT
//     sum(if(t = 'pv', times, 0)) t_pv,
//     count(DISTINCT pv_id) as err_pv,
//     date_format(date / 1000, '%Y-%m-%d') as dt
//     FROM log
//     WHERE t = 'error'
//   group by dt
//   order by dt) t2

// group by t1.dt
// order by t1.dt



// SELECT
//   sum(if(t = 'pv', times, 0)) t_pv,
//   count(DISTINCT pv_id) as err_pv,
//   date_format(date / 1000, '%Y-%m-%d') as dt
//   FROM log
//   WHERE t = 'error'
// group by dt
// order by dt



Promise.all(
  config.err_rate_projects.map(getErrorRateByDayByOriginStore),
  // config.err_rate_projects.map(getErrorRateByOriginStore),
).then(res => {
  const result = res.map(item => item.body)
  // console.log(result)

  // 第一层为 store 即应用，第二层为日期
  const temp = result.reduce((obj, proj) => {
    let index = 0;
    for (let key in proj) {
      const cur = proj[key]
      // console.log('cur', cur.app_name, cur.dt.substr(0, 10), Number(cur.t_pv), Number(cur.err_pv))

      // ByAppByDay 输出结果
      // [app_name, x1, x2, x3, xx]
      const appItem = obj.app[cur.app_name];
      const appErrPvRate = (Math.round(cur.err_pv/cur.t_pv*10000*100)/100).toFixed(1);
      // const appErrCntRate = (Math.round(cur.t_error/cur.t_pv*10000*100)/100).toFixed(1);
      if (!appItem) {
        obj.app[cur.app_name] = [appErrPvRate];
        // obj.app[cur.app_name] = [appErrCntRate];
      } else {
        obj.app[cur.app_name].push(appErrPvRate);
        // obj.app[cur.app_name].push(appErrCntRate);
      }

      // TotalByDay 汇总，输出结果为每天所有应用的汇总
      // [x1, x2, x3]
      const dtItem = obj.dt[index] // dt 日期
      if (!dtItem) {
        obj.dt[index] = {
          dt: cur.dt,
          t_pv: Number(cur.t_pv),
          t_error: Number(cur.t_error),
          err_pv: Number(cur.err_pv),
        };
      } else {
        obj.dt[index] = {
          dt: cur.dt,
          t_pv: Number(dtItem.t_pv) + Number(cur.t_pv),
          t_error: Number(dtItem.t_error) + Number(cur.t_error),
          err_pv: Number(dtItem.err_pv) + Number(cur.err_pv),
        };
      }
      index++;
    }
    return obj;
  }, {dt: [], app: {}})

  console.log('err_rate_byApp', temp.app);

  const totalResult = temp.dt.map(item => {
    const error_cnt_rate = item.t_error/item.t_pv*10000
    const error_pv_rate = item.err_pv/item.t_pv*10000
    const temp2 = {
      ...item,
      dt: item.dt,
      error_cnt_rate: (Math.round(error_cnt_rate*100)/100).toFixed(1),
      error_pv_rate: (Math.round(error_pv_rate*100)/100).toFixed(1),
    };
    // return Number(temp2.error_cnt_rate); // 老指标
    return Number(temp2.error_pv_rate);
  })

  console.log('err_rate_total', totalResult);

}).catch(err => {
  console.log('err:', err);
});
