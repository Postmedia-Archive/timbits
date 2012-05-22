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
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# instead of using the helper method, let's show how to use pantry directly
	@pantry.fetch src, (error, results) =>
		context.tweets = results
		@render req, res, context