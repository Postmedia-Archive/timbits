# Module dependencies.
timbits = require '../src/timbits'

# use redis for caching
RedisStorage = require 'pantry/lib/pantry-redis'
timbits.pantry.storage = new RedisStorage(null, null, null, 'DEBUG')
timbits.pantry.configure {verbosity: 'DEBUG'}

# start serving timbits
server = timbits.serve {home: __dirname}
