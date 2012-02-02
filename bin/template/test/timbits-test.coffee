timbits = require 'timbits'
vows = require 'vows'
assert = require 'assert'
path = require 'path'
request = require 'request'

homeFolder = process.cwd()
port = 8785

server = timbits.serve( {home: homeFolder, port: port })

assertStatus = (code) ->
	return (err, res) ->
		assert.isNull err
		assert.equal res.statusCode, code

respondsWith = (status) ->
	context = {
		topic: ->
			req = @context.name.split(' ')
			method = req[0].toLowerCase()
			path = req[1]
			uri = "http://localhost:#{port}#{path}"
			console.log uri
			
			request[method] uri, @callback
			return
	}
			
	context["should respond with a #{status}"] = assertStatus(status)
	return context

vows
	.describe('timbits')
	.addBatch
		
		#test main help page
		'GET /timbits/help': respondsWith 200
		
		#test json directory
		'GET /timbits/json': respondsWith 200

	.export module