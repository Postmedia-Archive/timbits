# Chocolate Timbit
# Example of a timbit which transforms remote data
# This timbit will query twitter and display the results
# There are two views available, the default and the alternate
# /chocolate?q=timbits
# /chocolate/alternate?q=timbits

# load the timbits module
timbits = require 'timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.eat = (context) ->
	
	context.q = context.request.query.q || 'timbits'
	
	# specify the data source
	src = {
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch context, 'tweets', src