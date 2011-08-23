# Chocolate Timbit

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

timbit.eat = (context) ->
	
	context.q = context.request.query.q || 'timbits'
	
	# specify the data source
	src = {
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch context, 'tweets', src, (context) ->
		# let's just re-use the chocolate timbit views
		context.response.render "chocolate/#{context.view}", context: context