# Plain Timbit
# Example of the simplist timbit that could possibly be created.  
# This timbit will simply render a view using data from the query string
# pass in 'item' via the querystring
# e.g. /plain?item=World

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...