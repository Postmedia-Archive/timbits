h1 "Default #{@name} Timbit View"
h2 "Recent tweets for '#{@q}'"

ul ->
	for result in @tweets.results
		li -> h result.text