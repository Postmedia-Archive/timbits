# Module dependencies.
timbits = require '../src/timbits'

console.log process.cwd()

homeFolder = "#{process.cwd()}/examples"
# start serving timbits
server = timbits.serve( {home: homeFolder })


