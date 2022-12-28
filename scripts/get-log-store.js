var sls = require('./sls')
var config = require('./config.private')

// -------------------------------
// list logStores
// -------------------------------

// sls.getLogstore(
//   {
//     // 必选字段
//     projectName: config.projectName,
//     LogStoreName: config.logStoreName,
//   },
//   function (err, data) {
//     if (err) {
//       console.log('error:', err)
//       return
//     }

//     console.log('success:', data)
//   },
// )

var listLogStores = function (fn) {
  sls.listLogStores(
    {
      projectName: config.projectName,
    },
    function (err, data) {
      console.log('----listLogStores----')
      if (err) console.error('error:', err)
      else {
        console.log(data)
        // fn(data)
      }
    },
  )
}

listLogStores();
