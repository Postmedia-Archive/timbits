ck = require 'coffeekup'

@sayHello = (name) ->
	"Hello #{name}!"
	
@linkIt = (href, caption) ->
	ck.render link, href: href, caption: caption
		
link = ->
	a href: @href, -> @caption