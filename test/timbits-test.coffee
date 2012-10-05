timbits = require '../src/timbits'
should = require 'should'
path = require 'path'
request = require 'request'

homeFolder = path.join("#{process.cwd()}", "examples")
port = 8785

server = timbits.serve( {home: homeFolder, port: port })

###
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
###

validateRequest = (path, expect = 'html') ->
	describe path, ->
		test_msg = "should respond with #{expect} and status 200"
		if typeof expect isnt 'string'
			test_msg = "should respond with status #{expect}"

		it test_msg, (done) ->
			request "http://localhost:#{port}#{path}", (err, res) ->
				should.not.exist err
				if typeof expect is 'string'
					res.should.have.status 200
					if expect is 'json'
						res.should.be.json
					else
						res.should.be.html
				else
					res.should.have.status expect
				done()
			

describe 'timbits', ->
	describe 'configuration and loading', ->
		it 'should contain four timbits', ->
			Object.keys(timbits.box).length.should.equal 4
			timbits.box.should.have.property 'cherry'
			timbits.box.should.have.property 'chocolate'
			timbits.box.should.have.property 'dutchie'
			timbits.box.should.have.property 'plain'
	
	
	describe 'default resources', ->
		validateRequest '/timbits/help'
		validateRequest '/timbits/json', 'json'
		
	describe 'individual help pages', ->
		validateRequest '/plain/help'
		validateRequest '/cherry/help'
		validateRequest '/chocolate/help'
		validateRequest '/dutchie/help'
		
	describe 'individual test pages', ->
		validateRequest '/plain/test'
		validateRequest '/cherry/test'
		validateRequest '/chocolate/test'
		validateRequest '/dutchie/test'
	
	describe 'individual json views', ->
		validateRequest '/plain/json', 'json'
		validateRequest '/cherry/json', 'json'
		validateRequest '/chocolate/json?q=winning', 'json'
		validateRequest '/dutchie/json', 'json'
		
	describe 'expected errors', ->
		validateRequest '/fake', 404
		validateRequest '/fake/json', 404
		validateRequest '/plain/fake', 500	
		validateRequest '/chocolate', 500	