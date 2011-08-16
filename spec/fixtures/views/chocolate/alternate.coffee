h1 "Alternate #{@name} Timbit View"
h2 "Recent tweets for '#{@q}'"

ul ->
	for result in @tweets.results
		li ->
			b "#{result.from_user}: "
			result.text