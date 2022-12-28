const {sls, } = require('./sls')
const config = require('./config.private')
// -------------------------------
// get Logs
// -------------------------------

const getLogsPromise = function(querySQL = '', options) {
  return new Promise((resolve, reject) => {
    sls.getLogs(getSlsConfig(querySQL, options), function (err, data) {
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

exports.getLogsPromise = getLogsPromise
