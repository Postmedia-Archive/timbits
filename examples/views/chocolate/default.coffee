h1 "Default #{@name} Timbit View"
h2 "Recent tweets for '#{@q}'"

ul ->
	li result.text for result in @tweets.results