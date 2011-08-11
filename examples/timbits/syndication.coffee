# Syndication Timbit
# Another prototype of a 'real world' widget
# This one will display a list of stories from an RSS or ATOM feed
# but uses the same templates as List

# load the timbits module
timbits = require '../../src/timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...

timbit.eat = (context) ->
	
	# specify the data source
	options = {
		uri: context.request.query.source
	}
	
	# use the helper method to @fetch the data
	@fetch context, 'raw', options, (context) ->		
		context.feed = []
		
		if context.raw.channel
			# assume RSS
			for item in context.raw.channel.item
				context.feed.push {
					Abstract: item.description
					Credit: null
					CreatedOn: item.pubDate
					PublishedOn: item.pubDate
					Title: item.title
					Uri: item.link
				}
		else
			# assume ATOM
			for item in context.raw.entry
				context.feed.push {
					Abstract: item.content
					Credit: item.author.name
					CreatedOn: item.published
					PublishedOn: item.updated
					Title: item.title
					Uri: getUri(item.link)
				}
		
		context.response.render "list/#{context.view}", context

getUri = (obj) ->
	links =  if obj instanceof Array then obj else [obj]
	
	for link in links when link['@'].type is 'text/html' and link['@'].rel is 'alternate'
		return link['@'].href
		
	return null