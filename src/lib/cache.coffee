md5 = require 'MD5'
chalk = require 'chalk'

# private

cache = {}

getKey = (config) ->
  md5 JSON.stringify config

# public

exports.add = (config, response) ->
  cache[getKey(config)] = response

exports.find = (config) ->
  try
    res = cache[getKey(config)]
    return res
  catch err
    return false

exports.summary = ->
  count = Object.keys(cache).length
  console.log chalk.black.bgCyan(" ➥ Cached items: #{count} ")
