view = ->
	h1 ->
		"The current server date/time is #{@now}"
if callback ?= false
	viewCallback(view)
else
	view()