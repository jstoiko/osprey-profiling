const express = require('express')
const osprey = require('osprey')
const path = require('path')

const router = osprey.Router()

router.get('/songs', function (req, res) {
  res.json([{ username: 'johndoe', password: 'doe' }])
})

osprey.loadFile(path.join(__dirname, '../world-music-api/api.raml'))
  .then(function (middleware) {
    const app = express()
    app.use('/', middleware, router)
    app.listen(3000, function () {
      console.log('Application listening on ' + 3000 + '...')
    })
  })
