# Dutchie Timbit
# Similar (in function, not taste) to the chocolate timbit
# This timbit displays some more advanced features such as:
# - specify a custom route
# - overiding the render implementation with custom code
# - um, that's it for now.  more to come...
# e.g. /dutchie/postmedia/alternate

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.route = "/dutchie/:q?/:view?"

timbit.eat = (context) ->
	
	context.q = context.request.params.q || 'timbits'
	
	# specify the data source
	src = {
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch context, 'tweets', src, (context) ->
		# let's just re-use the chocolate timbit views
		context.response.render "chocolate/#{context.view}", context