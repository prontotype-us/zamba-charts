somata = require 'somata'
client = new somata.Client
client.remote 'reloader', 'reload', ->
    process.exit()
