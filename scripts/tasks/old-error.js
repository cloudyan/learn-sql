
const config = require('../config.private');
const { getLogsPromise } = require('../sls');

// 从各个仓库拉取数据，然后汇总

// 输入一个日期，获取上周五到这周五的时间段数据
// new Date('2022/10/14 00:00:00').toJSON()

const today = new Date().toJSON().substr(0,10).replace('-', '/');
const to = Math.floor(new Date(`${today} 00:00:00`).getTime() / 1000)
const from = to - 86400*7;

// JS 错误与 PV 比例
const getErrorAndPv = ({
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
  sum(if(t = 'pv', times, 0)) pv,
  sum(if(t = 'error', times, 0)) err_cnt,
  (SELECT
    count(DISTINCT pv_id) as err_pv
    FROM log
    WHERE t = 'error') err_pv
from log
  `});
};

Promise.all(
  config.err_rate_projects.map(getErrorAndPv)
).then(res => {
  // console.log('res:', JSON.stringify(res, null, 2));

  const all = res.map(item => {
    const temp = item.body[0]
    return {
      ...temp,
      err_rate: temp.err_cnt/temp.pv,
      err_rate_new: temp.err_pv/temp.pv,
    }
  })

  console.log(all);
  const result = all.reduce((err_result, item) => {
    err_result.pv_total += Number(item.pv)
    err_result.err_cnt_total += Number(item.err_cnt)
    err_result.err_pv_total += Number(item.err_pv)
    return err_result
  }, {pv_total: 0, err_pv_total: 0, err_cnt_total: 0})

  result.err_rate = result.err_cnt_total/result.pv_total;
  result.err_rate_new = result.err_pv_total/result.pv_total;
  console.log('all', result);
}).catch(err => {
  console.log('err:', err);
})
