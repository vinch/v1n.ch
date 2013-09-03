# initialization

fs = require 'fs'
http = require 'http'
express = require 'express'
ca = require 'connect-assets'
request = require 'request'
feedparser = require 'feedparser'
scraper = require 'scraper'
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

redirectWWW = (req, res, next) ->
  if req.headers.host.match(/^www/) isnt null
    res.redirect 301, 'http://' + req.headers.host.replace(/^www\./, '') + req.url
  else
    next()


# routes

app.all '*', redirectWWW, logRequest, (req, res, next) ->
  next()

app.get '/', (req, res) ->
  res.render 'home'

app.get '/about', (req, res) ->
  res.render 'about'

app.get '/experiments', (req, res) ->
  res.render 'experiments'

app.get '/klout.be', (req, res) ->
  res.render 'klout'

# API

app.get '/api/posts', (req, res) ->
  limit = req.query.limit || 10
  posts = []
  request('http://feeds.feedburner.com/vinch')
    .pipe(new feedparser())
    .on('error', (error) ->
      log.error error
    )
    .on('readable', ->
      stream = @
      while (item = stream.read())
        posts.push {
          title: item.title
          summary: item.summary
          link: item.link
          date: item.date
        }
    )
    .on('end', ->
      res.header 'Content-Type', 'application/json; charset=utf-8'
      res.send posts.slice(0, limit)
    )

app.get '/api/photos', (req, res) ->
  limit = req.query.limit || 20
  photos = []
  request.get('https://api.instagram.com/v1/users/' + process.env.INSTAGRAM_USER_ID + '/media/recent/?access_token=' + process.env.INSTAGRAM_ACCESS_TOKEN + '&count=' + limit, {
    json: true
  }, (error, response, body) ->
    body.data.forEach (item) ->
      photos.push {
        title: item.caption?.text
        thumbnail: item.images.thumbnail.url
        link: item.link
      }
    res.send photos
  )

# 404

app.all '*', (req, res) ->
  res.statusCode = 404
  res.render '404', {
    code: '404'
  }

# server creation

server.listen process.env.PORT ? '3333', ->
  log.info 'Express server listening on port ' + server.address().port + ' in ' + app.settings.env + ' mode'