timbits = require '../src/timbits'
vows = require 'vows'
assert = require 'assert'
path = require 'path'
request = require 'request'

homeFolder = path.join("#{process.cwd()}", "examples")
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
		'inspect loaded timbits':
			topic: timbits.box
				
			'should contain four timbits': (box) ->
				assert.equal Object.keys(box).length, 4
		
		#test main help page
		'GET /timbits/help': respondsWith 200
		
		#test json directory
		'GET /timbits/json': respondsWith 200
		
		#test individual help pages
		'GET /plain/help': respondsWith 200
		'GET /cherry/help': respondsWith 200
		'GET /chocolate/help': respondsWith 200
		'GET /dutchie/help': respondsWith 200

		#execute automated test pages
		'GET /plain/test': respondsWith 200
		'GET /cherry/test': respondsWith 200
		'GET /chocolate/test': respondsWith 200
		'GET /dutchie/test': respondsWith 200
		
		#retrieve json view
		'GET /plain/json': respondsWith 200
		
		#retrieve an non-existant timbit
		'GET /fake': respondsWith 404
		
		#use an non-existant view
		'GET /plain/fake': respondsWith 500
		
		#enforcement of required parameters
		'GET /chocolate': respondsWith 500

	.export module