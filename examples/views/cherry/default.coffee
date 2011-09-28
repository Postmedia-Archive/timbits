view = ->
	h1 ->
		"The current server date/time is #{@now}"
if window?
	window.view = view
else
	view()