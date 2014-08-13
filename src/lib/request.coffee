cache = require './cache'
chalk = require 'chalk'
supertest = require 'supertest'

# private

serverCount = 0
cachedCount = 0

makeServerRequest = (config, callback) ->
  method = config.method.toLowerCase()
  url = config.url
  server = config.server
  body = config.body
  supertest(server)[method](url).send(body).end callback

summary = ->
  total = serverCount + cachedCount
  percent = parseInt(cachedCount/total*100) || 0
  message = " ➥ Total requests: #{total} (~#{percent}% cached) "
  console.log chalk.black.bgCyan message

# public

exports.makeRequest = (config = {}, done=->null) ->
  # try and find the response in the cache
  res = cache.find(config) unless config.ignore
  if res
    cachedCount++
    @res = res
    done null, res
  else
    serverCount++
    makeServerRequest config, (err, res) ->
      return done err if err
      cache.add(config, res) unless config.ignore
      done null, res

exports.summary = ->
  console.log ""
  summary()
  cache.summary()
