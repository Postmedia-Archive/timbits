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
	{href: '/chocolate/?q=winning', caption: 'Winning - Default View'}
	{href: '/chocolate/alternate?q=winning&rpp=20', caption: 'Winning - Alternate View'}
]

timbit.params = {
	q: {description: 'Keyword to search for',required: true, strict: false, values: ['Coffee', 'Timbits']}
	rpp: {description: 'Maximum number of tweets to display', type: 'Number', default: 10, values: [1, 8, 16]}
}

timbit.eat = (req, res, context) ->
	
	# specify the data source
	src = {
		name: 'tweets'
		uri: "http://search.twitter.com/search.json?q=#{context.q}&rpp=#{context.rpp}"
	}
	
	@log.debug src.uri
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch req, res, context, src