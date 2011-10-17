# Plain Timbit

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.about = '
	Example of the simplest timbit that could possibly be created.
	This timbit will simply render a view using data from the query string.
	'

timbit.examples = [
	{href: '/plain/', caption: 'Anonymous'}
	{href: '/plain/?who=world', caption: 'Hello World'}
	{href: '/plain/?who=Kevin&year=1999', caption: 'Flashback'}
	{href: '/plain/with-help?who=Handy%20Manny', caption: 'With Help'}]

timbit.params = {
	who: {description: 'Name of person to greet', default: 'Anonymous', multiple: false, required: false, strict: false, values: ['Ed', 'World']}
	year: {description: 'To test multi parameters and drive Kevin crazy', values: [1999, 2011]}
}