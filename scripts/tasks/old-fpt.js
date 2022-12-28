
const config = require('../config.private');
const { getLogsPromise } = require('../sls');

// 从各个仓库拉取数据，然后汇总

// 输入一个日期，获取上周五到这周五的时间段数据
// new Date('2022/10/14 00:00:00').toJSON()

const today = new Date().toJSON().substr(0,10).replace('-', '/');
const to = Math.floor(new Date(`${today} 00:00:00`).getTime() / 1000)
const from = to - 86400*7;

const getFpt = ({
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
  avg(if(t = 'perf', fpt, 0)) fpt_avg,
  sum(if(t = 'pv', times, 0)) pv,
  sum(if(t = 'pv', 1, 0)) pv_cnt
  `});
};

Promise.all(
  config.fpt_projects.filter(item => {
    return ![
      'creditwebmpaash5',
      'applywebmpaash5',
      'businesswebmpaash5',
      'cmscommonmpaash5',
      'taroweb',
    ].includes(item.appName)
  }).map(getFpt)
).then(res => {
  // console.log('res:', JSON.stringify(res, null, 2));

  const all = res.map(item => {
    const temp = item.body[0]
    return {
      ...temp,
      //
    }
  })

  console.log(all);
  const result = all.reduce((obj, item) => {
    obj.fpt_total += Number(item.fpt_avg) * Number(item.pv)
    obj.pv_total += Number(item.pv)
    obj.pv_cnt_total += Number(item.pv_cnt)
    return obj
  }, {fpt_total: 0, pv_cnt_total: 0, pv_total: 0})

  result.fpt_avg = result.fpt_total/result.pv_total;
  console.log('all', result);
}).catch(err => {
  console.log('err:', err);
})
