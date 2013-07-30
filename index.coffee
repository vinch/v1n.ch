# initialization

fs = require 'fs'
http = require 'http'
express = require 'express'
ca = require 'connect-assets'
request = require 'request'
log = require('logule').init(module)

app = express()
server = http.createServer app

# error handling

process.on 'uncaughtException', (err) ->
  log.error err.stack

# configuration

app.configure ->
  app.set 'views', __dirname + '/app/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.favicon __dirname + '/public/img/favicon.ico'
  app.use express.static __dirname + '/public'
  app.use ca {
    src: 'app/assets'
    buildDir: 'public'
  }

app.configure 'development', ->
  app.set 'BASE_URL', 'http://localhost:3333'

app.configure 'production', ->
  app.set 'BASE_URL', 'http://v1n.ch'

# middlewares

logRequest = (req, res, next) ->
  log.info req.method + ' ' + req.url
  next()

# routes

app.all '*', logRequest, (req, res, next) ->
  next()

app.get '/', (req, res) ->
  res.render 'home'

# 404

app.all '*', (req, res) ->
  res.statusCode = 404
  res.render '404', {
    code: '404'
  }

# server creation

server.listen process.env.PORT ? '3333', ->
  log.info 'Express server listening on port ' + server.address().port + ' in ' + app.settings.env + ' mode'