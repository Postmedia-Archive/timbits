timbits = require 'timbits' 
assert = require 'assert' 
path = require 'path'

homeFolder = "#{process.cwd()}"

#start serving timbits

server = timbits.serve( {home: homeFolder, port: 8785 })

module.exports =

## Test Case #1 - check we have a valid server running
	"test that the express server object returned is functioning, note by default the root redirects to the help page so we get a http status code of 302": (beforeExit)->
		assert.response server, 
			url: "/"
			method: "GET"
		,
			status: 302
		, (res) ->
			assert.ok res, "Expected a response, perhaps something is wrong our status was: #{res.status}"