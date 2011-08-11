# Module dependencies.
timbits = require '../src/timbits'

homeFolder = "#{process.cwd()}/examples"
# start serving timbits
server = timbits.serve( {home: homeFolder })