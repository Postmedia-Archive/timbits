doctype 5
html ->
	head ->
		title 'Timbits - Examples'
	body ->
		h1 'Timbits - Examples'
		
		h2 'Plain Timbit'
		
		p 'Example of the simplest timbit that could possibly be created.  
			 This timbit will simply render a view using data from the querystring.'
			
		ul ->
			(li -> a href: '/plain', -> '/plain')
			(li -> a href: '/plain?who=World', -> '/plain?who=World')
		
		h2 'Cherry Timbit'
		
		p 'Example of a timbit which actually does something.
			 This timbit will display the current server time.'
			
		ul ->
			(li -> a href: '/cherry', -> '/cherry')
		
		h2 'Chocolate Timbit'
		
		p 'Example of a timbit which transforms remote data.
			 This timbit will query twitter and display the results.
			 There are two views available, the default and the alternate.'
			
		ul ->
			(li -> a href: '/chocolate', -> '/chocolate')
			(li -> a href: '/chocolate?q=coffeescript', -> '/chocolate?q=coffeescript')
			(li -> a href: '/chocolate/alternate?q=coffeescript', -> '/chocolate/alternate?q=coffeescript')
		
		h2 'Dutchie Timbit'
		
		p 'Similar (in function, not taste) to the chocolate timbit
			 This timbit displays some more advanced features such as 
			 specifing a custom route and overiding the render implementation
			 with custom code (just because)'
			
		ul ->
			(li -> a href: '/dutchie', -> '/dutchie')
			(li -> a href: '/dutchie/nodejs', -> '/dutchie/nodejs')
			(li -> a href: '/dutchie/nodejs/alternate', -> '/dutchie/nodejs/alternate')
		
		h2 'Story Timbit'
		
		p 'Our prototype of a "real world" widget.
			This one will retrieve and display a story from our CMS (SouthPARC)'
			
		ul ->
			
			(li -> a href: '/story/5196970', -> 'Egypt puts Mubarak, bedridden and caged, on trial')
			(li -> a href: '/story/5239143', -> 'British PM pledges tough action to quell unrest')
			(li -> a href: '/story/5240676', -> 'Montreal&rsquo;s Festival Mode & Design: The high street')
			
		h2 'List Timbit'

		p 'Our prototype of a "real world" widget.
			This one will display a list of stories from our CMS (SouthPARC)'

		ul ->
			(li -> a href: '/list/764023', -> '/list/764023')
			(li -> a href: '/list/5239143', -> '/list/5239143')
			(li -> a href: '/list/5239143?type=STRY', -> '/list/5239143?type=STRY')
			(li -> a href: '/list/5239143?type=PHOT', -> '/list/5239143?type=PHOT')
			(li -> a href: '/list/764023/full', -> '/list/764023/full')
			(li -> a href: '/list/5239143/full', -> '/list/5239143/full')
			
		h2 'Syndication Timbit'

		p 'Our prototype of a "real world" widget.
			This one will display a list of stories from an RSS or ATOM feed but uses the same templates as List'

		ul ->
			(li -> a href: '/syndication?source=http://rss.cbc.ca/lineup/topstories.xml', -> '/syndication?source=http://rss.cbc.ca/lineup/topstories.xml')
			(li -> a href: '/syndication/full?source=http://rss.cbc.ca/lineup/topstories.xml', -> '/syndication/full?source=http://rss.cbc.ca/lineup/topstories.xml')
			(li -> a href: '/syndication?source=http://search.twitter.com/search.atom?q=winning', -> '/syndication?source=http://search.twitter.com/search.atom?q=winning')
>>>>>>> New examples - List and Syndication
		