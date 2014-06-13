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

validateRequest = (vpath, expect = 'html') ->
	describe vpath, ->
		test_msg = "should respond with #{expect} and status 200"
		if typeof expect isnt 'string'
			test_msg = "should respond with status #{expect}"

		it test_msg, (done) ->
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
			

describe 'timbits', ->
	
	describe 'automated test cases', ->
		for name, timbit of timbits.box
			if timbit.examples?
				describe "specified examples for #{name}", ->
					for example in timbit.examples
						validateRequest example.href
			
			dynatests = timbit.generateTests(alltests)
			if dynatests.length
				describe "dynamic tests for #{name}", ->
					for href in dynatests
						validateRequest href
