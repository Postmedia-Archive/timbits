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
		