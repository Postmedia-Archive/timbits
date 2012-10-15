# set logging level
process.env.TIMBITS_VERBOSITY = 'debug'
process.env.PANTRY_VERBOSITY = 'debug'

# Module dependencies.
timbits = require '../src/timbits'

# start serving timbits
server = timbits.serve {home: __dirname}
