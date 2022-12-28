
const { getLogsPromise } = require('../sls');

// js 错误率
function getErrorRate() {
  return getLogsPromise({
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

// 首屏时间满意度
function getFmpApdex() {
  return getLogsPromise({
    query: `
* and not app_name: taroweb |
select
  round((0.0 + sum(fmp_s1) + (sum(fmp_s4) - sum(fmp_s1)) / 2)*100 / sum(fmp_total), 2) fmp_apdex,
  sum(fmp_total) fmp_total,
  sum(fmp_s1) fmp_good,
  sum(fmp_s4) - sum(fmp_s1) fmp_mid,
  sum(fmp_total) - sum(fmp_s4) fmp_poor
`});
};

function getFmpApdexByApp() {
  return getLogsPromise({
    query:`
* and not app_name: taroweb |
select
  app_name,
  round((0.0 + sum(fmp_s1) + (sum(fmp_s4) - sum(fmp_s1)) / 2)*100 / sum(fmp_total), 1) fmp_apdex,
  sum(fmp_total) fmp_total,
  sum(fmp_s1) fmp_good,
  sum(fmp_s4) - sum(fmp_s1) fmp_mid,
  sum(fmp_total) - sum(fmp_s4) fmp_poor
group by
  app_name
order by
  app_name
`});
};

Promise.all([
  getErrorRate(),
  getFmpApdex(),
  // getErrorRateByApp(),
  // getFmpApdexByApp(),
]).then(res => {
  console.log('err_rate:', res[0].body[0]);
  console.log('fmp_apdex:', res[1].body[0]);
}).catch(err => {
  console.log('error:', err);
})



