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
	{href: '/plain', caption: 'Anonymous'}
	{href: '/plain?who=world', caption: 'Hello World'}
]

timbit.params = {
	who: {description: 'Name of person to greet', default: 'Anonymous', multiple: false, required: false, strict: false, values: ['Ed', 'World']}
}