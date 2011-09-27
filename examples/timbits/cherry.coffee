# Cherry Timbit

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.about = '
	Example of a timbit which actually does something.
	This timbit will display the current server time.
	'
	
timbit.examples = [
	{href: '/cherry/', caption: 'Current Time'}
]

timbit.eat = (req, res, context) ->
	context.now = new Date() 
	@render req, res, context