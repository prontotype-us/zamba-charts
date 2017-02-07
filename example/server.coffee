polar = require 'somata-socketio'

app = polar port: 3614

app.get '/', (req, res) -> res.render 'index'

app.start()
