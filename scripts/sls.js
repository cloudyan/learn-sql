const ALY = require('aliyun-sdk')
// const ALY = require('../../index.js');
const config = require('./config.private')

// sls SDK 参考概述: https://help.aliyun.com/document_detail/29063.html
const sls = new ALY.SLS({
  accessKeyId: config.accessKeyId,
  secretAccessKey: config.secretAccessKey,
  // securityToken: 'tokens',

  // 根据你的 sls project所在地区选择填入,更多地域请参考
  //    https://help.aliyun.com/document_detail/29008.html
  // 北京：http://cn-beijing.log.aliyuncs.com
  // 杭州：http://cn-hangzhou.log.aliyuncs.com
  // 青岛：http://cn-qingdao.log.aliyuncs.com
  // 深圳：http://cn-shenzhen.log.aliyuncs.com

  // 注意：如果你是在 ECS 上连接 SLS，可以使用内网地址，速度快，没有带宽限制。
  // 杭州：cn-hangzhou-intranet.log.aliyuncs.com
  // 北京：cn-beijing-intranet.log.aliyuncs.com
  // 青岛：cn-qingdao-intranet.log.aliyuncs.com
  // 深圳：cn-shenzhen-intranet.log.aliyuncs.com
  endpoint: 'http://cn-hangzhou.log.aliyuncs.com',

  // 这是 sls sdk 目前支持最新的 api 版本, 不需要修改
  apiVersion: '2015-06-01',

  //以下是可选配置
  //,httpOptions: {
  //    timeout: 1000  //1sec, 默认没有timeout
  //}
});

const getSlsConfig = (options = {}) => {
  return {
    // 必选字段
    projectName: config.projectName,
    logStoreName: config.logStoreName,
    from: config.from, // 开始时间(精度为秒,从 1970-1-1 00:00:00 UTC 计算起的秒数)
    to: config.to, // 结束时间(精度为秒,从 1970-1-1 00:00:00 UTC 计算起的秒数)

    //以下为可选字段
    topic: '', // 指定日志主题(用户所有主题可以通过listTopics获得)
    reverse: false, // 是否反向读取,只能为 true 或者 false,不区分大小写(默认 false,为正向读取,即从 from 开始到 to 之间读取 Line 条)
    line: 10, // 读取的行数,默认值为 100,取值范围为 0-100
    offset: 0, // 读取起始位置,默认值为 0,取值范围>0
    // query: querySQL, // 查询的关键词,不输入关键词,则查询全部日志数据

    ...options,
  }
};

const slsProfisify = (fn, argsFn = (opts = {}) => opts) => {
  return (...rest) => {
    return new Promise((resolve, reject) => {
      fn.call(sls, argsFn(...rest), function(err, data) {
        if (err) {
          // console.log('error:', err)
          reject(err)
          return
        }

        // console.log('success:', data)
        resolve(data)
      })
    })
  }
}

exports.els = sls;

exports.getLogsPromise = slsProfisify(sls.getLogs, (opts) => {
  return getSlsConfig(opts)
});

exports.listLogStoresPromise = slsProfisify(sls.listLogStores, (opts) => {
  return {
    projectName: config.projectName,
    ...opts,
  }
});
