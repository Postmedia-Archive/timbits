h1 "Alternate #{@name} Timbit View"
h2 "Recent tweets for '#{@q}'"

ul ->
	for result in @tweets.results
		li ->
			b -> h "#{result.from_user}: "
			h result.text