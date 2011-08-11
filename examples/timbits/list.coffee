# List Timbit
# Another prototype of a 'real world' widget
# This one will display a list of stories from our CMS (SouthPARC)

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.route = '/list/:id/:view?'

timbit.eat = (context) ->
	
	# determine story id
	id = context.request.params.id
	type = context.request.query.type or ''
	
	# specify the data source
	options = {
		uri: "http://app.canada.com/southparc/query.svc/relatedcontent/#{id}?format=json&type=#{type}"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch context, 'feed', options