# Chocolate Timbit

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# let's just re-use the chocolate timbit views
timbit.viewBase = 'chocolate'
timbit.maxAge = 300

timbit.eat = (req, res, context) ->
	
	# specify the data source
	src = {
		name: 'tweets'
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch req, res, context, src