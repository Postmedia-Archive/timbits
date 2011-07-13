# Story Timbit
# Our 'prototype of a 'real world' widget
# This one will retrieve and display a story from our CMS (SouthPARC)

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...
timbit.route = '/story/:id/:view?'

timbit.eat = (context) ->
	
	# determine story id
	id = context.request.params.id
	
	# specify the data source
	src = {
		host: 'app.canada.com'
		path: "/southparc/query.svc/content/#{id}?format=json"		
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch context, 'story', src