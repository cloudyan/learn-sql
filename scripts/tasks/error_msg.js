

const config = require('../config.private');
const { getLogsPromise } = require('../sls');

const endTime = new Date(new Date().toJSON().substr(0, 10));
const to = Math.floor(endTime / 1000)
const from = to - 86400*7;

// 汇总错误消息
// 应存档记录，用于总结优化及对比
const getTotalErrorMsg = ({
  appName,
  logStoreName,
}) => {
  return getLogsPromise({
    from,
    to,
    logStoreName,
    query: `
t: error
and environment: prod |
select
  '${appName}' app_name,
  url_decode(msg) err_msg,
  url_extract_host(concat('https://', url_decode(page))) err_host,
  url_extract_path(concat('https://', url_decode(page))) err_path,
  count(1) err_msg_cnt
group by
  err_msg,
  err_host,
  err_path
order by
  err_msg_cnt desc
  `});
};

Promise.all(
  config.err_msg_projects
    // .filter(item => item.appName === 'applywebmpaash5')
    .map(getTotalErrorMsg),
).then(res => {
  const result = res.map(item => item.body);
  console.log('result:', result);

  // 先汇总再分析
  let total = {};
  const temp = result.reduce((obj, proj) => {
    if (proj[0] && proj[0].app_name) {
      console.log(proj[0].app_name)
      const app_name = proj[0].app_name.padEnd(20, ' ');
      if (!obj[app_name]) obj[app_name] = {};
      for (let key in proj) {
        const cur = proj[key]
        if (!obj[app_name][cur.err_msg]) {
          obj[app_name][cur.err_msg] = 0;

        }
        if (!total[cur.err_msg]) {
          total[cur.err_msg] = 0;
        }
        obj[app_name][cur.err_msg] += Number(cur.err_msg_cnt);
        total[cur.err_msg] += Number(cur.err_msg_cnt);
      }
    }
    return obj;
  }, {});

  // console.log('temp:', temp);
  // 汇总分类及排序:
  total = Object.keys(total).map(key => {
    return [total[key], key];
  }).sort((a, b) => b[0] - a[0])
  console.log('total:', JSON.stringify(total, null, 2));
}).catch(err => {
  console.log('err:', err);
});


