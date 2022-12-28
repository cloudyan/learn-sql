const { listLogStoresPromise } = require('../sls')

listLogStoresPromise()
  .then((res) => {
    console.log('success:', res)
  })
  .catch((err) => {
    console.log('err:', err)
  })
