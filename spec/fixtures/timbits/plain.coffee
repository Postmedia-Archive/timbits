# Plain Timbit
# Example of the simplest timbit that could possibly be created.  
# This timbit will simply render a view using data from the query string
# pass in 'who' via the querystring
# e.g. /plain?who=World

# load the timbits module
timbits = require 'timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...