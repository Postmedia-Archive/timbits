# Chocolate Timbit

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

timbit.eat = (req, res, context) ->
	
	# specify the data source
	src = {
		name: 'tweets'
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch req, res, context, src, (req, res, context) ->
		# let's just re-use the chocolate timbit views
		res.render "chocolate/#{context.view}", context