# reduce logging levels to provide clean test feedback
process.env.TIMBITS_VERBOSITY = 'critical'
process.env.PANTRY_VERBOSITY = 'critical'

# Module dependencies.
timbits = require 'timbits'
should = require 'timbits/node_modules/should'
request = require 'timbits/node_modules/request'

# should http extensions
require 'timbits/node_modules/should-http'

port = 8785
alltests = process.env.TIMBITS_TEST_WHICH is 'all'

server = timbits.serve( {port: port })

validateRequest = (method, vpath, expect = 'html') ->
	describe vpath, ->
		test_msg = "should respond with #{expect} and status 200"
		if typeof expect isnt 'string'
			test_msg = "should respond with status #{expect}"

		it test_msg, (done) ->
			if method is "GET"
				request "http://localhost:#{port}#{vpath}", (err, res) ->
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
			else if method is "POST"
				request.post "http://localhost:#{port}#{vpath}", (err, res) ->
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
	
	describe 'automated test cases', ->
		for name, timbit of timbits.box
			if timbit.examples? and timbit.methods["GET"]
				describe "specified examples for #{name}", ->
					for example in timbit.examples
						validateRequest "GET", example.href
			
			if timbit.examples? and timbit.methods["POST"]
				describe "specified examples for #{name}", ->
					for example in timbit.examples
						validateRequest "POST", example.href
			
			dynatests = timbit.generateTests(alltests)
			if dynatests.length
				describe "dynamic tests for #{name}", ->
					for href in dynatests
						validateRequest "GET", href if timbit.methods["GET"]
						validateRequest "POST", href if timbit.methods["POST"]

