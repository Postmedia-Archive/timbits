# Cherry Timbit
# Example of a timbit which actually does something.
# This timbit will display the current server time

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.eat = (context) ->
	context.now = new Date() 
	@render context