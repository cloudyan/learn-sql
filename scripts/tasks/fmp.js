

const config = require('../config.private');
const { getLogsPromise } = require('../sls');

const today = new Date().toJSON().substr(0,10).replace('-', '/');
const to = Math.floor(new Date(`${today} 00:00:00`).getTime() / 1000)
const from = to - 86400*7;

// 各项目的每日 Apdex，含秒开率
const getFmpApdexByDay = ({
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
  round((0.0 + t1.cnt1) * 100 / t1.total, 2) s1_rate,
  round((0.0 + t1.cnt2) * 100 / t1.total, 2) s2_rate,
  round((0.0 + t1.cnt1 + (t1.cnt4 - t1.cnt1) / 2) * 100 / t1.total, 2) fmp_apdex,
  t1.cnt1 s1_cnt,
  t1.cnt2 s2_cnt,
  t1.cnt3 s3_cnt,
  t1.cnt4 s4_cnt,
  t1.total,
  t1.dt
FROM  (
    select
      count_if(fmp <=  1000) cnt1,
      count_if(fmp <=  2000) cnt2,
      count_if(fmp <=  3000) cnt3,
      count_if(fmp <=  4000) cnt4,
      count(1) total,
      date_format(date / 1000, '%Y-%m-%d') as dt
    FROM      log
    group by dt
    order by dt
  ) t1
  `});
};

const getFmpApdex = ({
  appName,
  logStoreName,
}) => {
  return getLogsPromise({
    from,
    to,
    logStoreName,
    query: `
t: perf
and fmp >= 0
and environment: prod |
select
  '${appName}' app_name,
  round((0.0 + t1.cnt1) * 100 / t1.total, 2) s1_rate,
  round((0.0 + t1.cnt2) * 100 / t1.total, 2) s2_rate,
  round((0.0 + t1.cnt1 + (t1.cnt4 - t1.cnt1) / 2) * 100 / t1.total, 2) fmp_apdex,
  t1.cnt1 s1_cnt,
  t1.cnt2 s2_cnt,
  t1.cnt3 s3_cnt,
  t1.cnt4 s4_cnt,
  t1.total
FROM  (
    select
      count_if(fmp <= 1000) cnt1,
      count_if(fmp <= 2000) cnt2,
      count_if(fmp <= 3000) cnt3,
      count_if(fmp <= 4000) cnt4,
      count(1) total
    FROM      log
  ) t1
  `});
};

// arms-summary 汇总库

// 首屏时间满意度
// function getFmpApdex() {
//   return getLogsPromise({
//     query: `
// * and not app_name: taroweb |
// select
//   round((0.0 + sum(fmp_s1) + (sum(fmp_s4) - sum(fmp_s1)) / 2)*100 / sum(fmp_total), 2) fmp_apdex,
//   sum(fmp_total) fmp_total,
//   sum(fmp_s1) fmp_good,
//   sum(fmp_s4) - sum(fmp_s1) fmp_mid,
//   sum(fmp_total) - sum(fmp_s4) fmp_poor
// `});
// };

// function getFmpApdexByApp() {
//   return getLogsPromise({
//     query:`
// * and not app_name: taroweb |
// select
//   app_name,
//   round((0.0 + sum(fmp_s1) + (sum(fmp_s4) - sum(fmp_s1)) / 2)*100 / sum(fmp_total), 1) fmp_apdex,
//   sum(fmp_total) fmp_total,
//   sum(fmp_s1) fmp_good,
//   sum(fmp_s4) - sum(fmp_s1) fmp_mid,
//   sum(fmp_total) - sum(fmp_s4) fmp_poor
// group by
//   app_name
// order by
//   app_name
// `});
// };

// summary
// Promise.all([
//   getFmpApdexByApp(),
//   getFmpApdex(),
// ]).then(res => {
//   console.log(res)
//   let [
//     byApp,
//     all,
//   ] = res;
//   byApp = byApp.body;
//   console.log('byApp:', byApp);
//   all = all.body[0];
//   console.log('all:', all);
// }).catch(err => {
//   console.log('err:', err);
// });


// 各应用按天分组
// Promise.all(
//   // config.fmp_projects.map(getFmpApdex),
//   config.fmp_projects.map(getFmpApdexByDay),
// ).then(res => {
//   const result = res.map(item => item.body)
//   // console.log('result:', result)
//   const temp = result.reduce((obj, proj) => {
//     const app_name = proj[0].app_name;
//     if (!obj[app_name]) obj[app_name] = [];
//     for (let key in proj) {
//       const cur = proj[key]
//       obj[app_name].push({
//         dt: cur.dt,
//         fmp_apdex: Number(cur.fmp_apdex).toFixed(2),
//         s1: Number(cur.s1_rate).toFixed(2),
//         s2: Number(cur.s2_rate).toFixed(2),
//       })
//     }
//     return obj;
//   }, {});

//   console.log('fmpApdexByDay:', temp);
// }).catch(err => {
//   console.log('err:', err);
// });

// 按天分组后汇总

function fmpDataHandler(data) {
  const result = data.map(item => item.body)

  // console.log('result:', result)
  // 每项数据格式
  // {
  //   '0': {
  //     app_name: 'hbmembership',
  //     s1_rate: '36.58',
  //     s2_rate: '80.15',
  //     fmp_apdex: '66.8',
  //     s1_cnt: '833',
  //     s2_cnt: '1825',
  //     s3_cnt: '2148',
  //     s4_cnt: '2210',
  //     total: '2277',
  //     dt: '2022-11-13',
  //     __source__: '',
  //     __time__: '1667865600'
  //   },
  // }

  // 输出
  // [{
  //   dt: '2022-11-15',
  //   fmp_apdex: '',
  //   s1_cnt: 1,
  //   s2_cnt: 1,
  //   s3_cnt: 1,
  //   s4_cnt: 1,
  // }]

  let dataTotal = {
    s1_cnt: 0,
    s2_cnt: 0,
    s3_cnt: 0,
    s4_cnt: 0,
    total_cnt: 0,
  };
  const temp = result.reduce((arr, proj) => {
    let index = 0;
    for (let key in proj) {
      const cur = proj[key]
      // console.log('cur', cur)
      const arrItem = arr[index]
      if (!arrItem) {
        arr[index] = {
          dt: cur.dt,
          s1_cnt: Number(cur.s1_cnt),
          s2_cnt: Number(cur.s2_cnt),
          s3_cnt: Number(cur.s3_cnt),
          s4_cnt: Number(cur.s4_cnt),
          total_cnt: Number(cur.total),
        };
      } else {
        arr[index] = {
          dt: cur.dt,
          s1_cnt: Number(arrItem.s1_cnt) + Number(cur.s1_cnt),
          s2_cnt: Number(arrItem.s2_cnt) + Number(cur.s2_cnt),
          s3_cnt: Number(arrItem.s3_cnt) + Number(cur.s3_cnt),
          s4_cnt: Number(arrItem.s4_cnt) + Number(cur.s4_cnt),
          total_cnt: Number(arrItem.total_cnt) + Number(cur.total),
        };
      }
      dataTotal = {
        s1_cnt: Number(dataTotal.s1_cnt) + Number(cur.s1_cnt),
        s2_cnt: Number(dataTotal.s2_cnt) + Number(cur.s2_cnt),
        s3_cnt: Number(dataTotal.s3_cnt) + Number(cur.s3_cnt),
        s4_cnt: Number(dataTotal.s4_cnt) + Number(cur.s4_cnt),
        total_cnt: Number(dataTotal.total_cnt) + Number(cur.total),
      }
      index++;
    }
    return arr;
  }, [])


  const dataByDay = temp.map(item => {
    const fmp_apdex = (item.s1_cnt + (item.s4_cnt - item.s1_cnt)/2)/item.total_cnt*100
    return {
      dt: item.dt,
      fmp_apdex: (Math.round(fmp_apdex*100)/100).toFixed(2),
    }
  })

  dataTotal.fmp_apdex = (dataTotal.s1_cnt + (dataTotal.s4_cnt - dataTotal.s1_cnt)/2)/dataTotal.total_cnt*100
  dataTotal.fmp_apdex = (Math.round(dataTotal.fmp_apdex*100)/100).toFixed(2)
  return {dataTotal, dataByDay}
}

Promise.all(
  // config.fmp_projects.map(getFmpApdex),
  config.fmp_projects.map(getFmpApdexByDay),
).then(fmpDataHandler)
.then(({dataByDay, dataTotal}) => {
  console.log('fmpApdexByDay:', dataByDay);
  console.log('fmpApdexAll:', dataTotal.fmp_apdex);
}).catch(err => {
  console.log('err:', err);
});

Promise.all(
  // config.fmp_projects.map(getFmpApdex),
  config.fmp_projects.map(getFmpApdexByDay),
).then(fmpDataHandler)
.then(({dataByDay, dataTotal}) => {
  console.log('fmpApdexByDay:', dataByDay);
  console.log('fmpApdexAll:', dataTotal.fmp_apdex);
}).catch(err => {
  console.log('err:', err);
});


// const temp = result.reduce((obj, proj) => {
//   const app_name = proj[0].app_name;
//   if (!obj[app_name]) obj[app_name] = [];
//   for (let key in proj) {
//     const cur = proj[key]
//     obj[app_name].push({
//       app_name,
//       dt: cur.dt,
//       // fmp_apdex: Number(cur.fmp_apdex).toFixed(2),
//       s1_cnt: Number(cur.fmp_s1),
//       s2_cnt: Number(cur.fmp_s2),
//       s3_cnt: Number(cur.fmp_s3),
//       s4_cnt: Number(cur.fmp_s4),
//     })
//   }
//   return obj;
// }, {});

// {
//   creditweb: [
//     {
//       dt: '2022-11-08',
//       s1_cnt: 6326,
//       s2_cnt: 12935,
//       s3_cnt: 16672,
//       s4_cnt: 19697
//     },
//   ]
// }


// 总指标，按 app 汇总
// Promise.all(
//   config.fmp_projects.map(getFmpApdex),
//   // config.fmp_projects.map(getFmpApdexByDay),
// ).then(res => {
//   const result = res.map(item => item.body)
//   // console.log('result:', result)
//   const total = {
//     fmp_s1: 0,
//     fmp_s2: 0,
//     fmp_s3: 0,
//     fmp_s4: 0,
//     fmp_total: 0,
//   };
//   const temp = result.reduce((obj, proj) => {
//     const app_name = proj[0].app_name.padEnd(20, ' ');
//     if (!obj[app_name]) obj[app_name] = [];
//     for (let key in proj) {
//       const cur = proj[key]
//       obj[app_name].push({
//         fmp_apdex: Number(cur.fmp_apdex).toFixed(2),
//         s1: Number(cur.s1_rate).toFixed(2),
//         s2: Number(cur.s2_rate).toFixed(2),
//       });

//       total.fmp_s1 += Number(cur.fmp_s1);
//       total.fmp_s2 += Number(cur.fmp_s2);
//       total.fmp_s3 += Number(cur.fmp_s3);
//       total.fmp_s4 += Number(cur.fmp_s4);
//       total.fmp_total += Number(cur.total);
//     }
//     return obj;
//   }, {});

//   console.log('fmpApdexByApp:', temp);

//   // 计算比例
//   total.s1 = total.fmp_s1 / total.fmp_total;
//   total.s2 = total.fmp_s2 / total.fmp_total;
//   total.apdex = (total.fmp_s1 + (total.fmp_s4 - total.s1)/2) / total.fmp_total;

//   console.log('fmpTotal:', total);
// }).catch(err => {
//   console.log('err:', err);
// });


// 总指标，按日期汇总


// 看随时间的趋势变化 https://help.aliyun.com/document_detail/63451.html#section-0mz-vuv-not
// 拉取一个项目，获取每天的趋势变化
// 按天分组
//    date_trunc('day', __time__) as dt
//    date_format(date / 1000, '%Y-%m-%d') as dt
// 按小时
//    date_format(date / 1000, '%Y-%m-%d %H') logDay, '%Y-%m-%d %H:%i'
// apdex 算法
`
t: perf
and environment: prod
and fmp >= 0 |
select
  round((0.0 + t1.cnt1 + t1.cnt2 / 2) * 100 / t1.total, 2) result,
  t1.total,
  t1.dt
FROM  (
    select
      count_if(fmp <=  1000) cnt1,
      count_if(
        fmp >  1000
        and fmp <= 4000
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

