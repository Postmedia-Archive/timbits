# Chocolate Timbit

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.about = '
	Example of a timbit which transforms remote data.
	This timbit will query twitter and display the results
	There are two views available, the default and the alternate
	'

timbit.examples = [
	{href: '/chocolate?q=winning', caption: 'Winning - Default View'}
	{href: '/chocolate/alternate?q=winning', caption: 'Winning - Alternate View'}
]

timbit.params = [
	{name: 'q', description: 'Keyword to search for',required: true, strict: false, values: ['Coffee', 'Timbits']}
]

timbit.eat = (context) ->
	
	context.q = context.request.query.q
	
	# specify the data source
	src = {
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch context, 'tweets', src