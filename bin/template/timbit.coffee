# Timbit

# load the timbits module
timbits = require 'timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...

#timbit.about = 'a description about this timbit'

#timbit.examples = [
#	{href: '/timbit/?q=winning', caption: 'Default View'}
#	{href: '/timbit/alternate?q=winning', caption: 'Alternate View'}
#]

#timbit.params = {
#	q: {description: 'Keyword to search for',required: true, strict: false, values: ['Coffee', 'Timbits']}
#}

timbit.eat = (req, res, context) ->
	
	src = {
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch req, res, context, src