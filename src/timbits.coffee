express = require 'express'
pantry = require 'pantry'
fs = require 'fs'
path = require 'path'
request = require 'request'
async = require 'async'
connectESI = require 'connect-esi'
ck = require 'coffeekup'
Log = require 'coloured-log'

config = { appName: "Timbits", engine: "coffee", port: 5678, home: process.cwd() }
server = {}

log = new Log()

# creates, configures, and returns a standard express server instance
@serve = (options) ->
	config[key] = value for key, value of options
	@server = express.createServer()

	log = new Log(if @server.settings.env is 'development' then Log.DEBUG else Log.INFO)

	# support coffekup
	@server.register '.coffee', ck

	# configure server (still needs some thought)
	@server.set 'views', "#{config.home}/views"
	@server.set 'view engine', config.engine
	@server.set 'view options', {layout: false}

	@server.configure =>
		@server.use connectESI.setupESI()
		@server.use express.static("#{config.home}/public")
		@server.use express.static("#{config.home}/views")
		@server.use express.bodyParser()
		@server.use express.cookieParser()

	@server.configure 'development', =>
		@server.use express.errorHandler({ dumpExceptions: true, showStack: true })

	@server.configure 'production', =>
		@server.use express.errorHandler()

	# route help page
	@server.get '/', (req, res) ->
		res.redirect '/timbits/help'

	@server.get '/timbits/help', (req, res) =>
		res.send ck.render(help, context: @box)

	@server.get '/timbits/test', (req, res) =>
		res.send ck.render(test, context: null)

	#automagically load timbits found in the ./timbits folder
	path = "#{config.home}/timbits"
	fs.readdir path, (err, files) =>
		throw err if err
		for file in files
			name = file.replace('.coffee', '')
			@add name, require("#{path}/#{name}")

	# starts the server
	@server.listen process.env.PORT || process.env.C9_PORT || config.port
	log.info "Timbits server listening on port #{@server.address().port} in #{@server.settings.env} mode"
	server.address = @server.address().address
	server.port = @server.address().port
	return @server

# the box that holds each of the individual timbits created
@box = {}

# use the 'add' method to place a timbit in the box
@add = (name, timbit) ->
	#place the timbit in the box
	log.notice "Placing #{name} in the box"
	timbit.name = name
	@box[name] = timbit

	# configure help
	@server.get ("/#{name}/help"), (req, res) ->
		res.send ck.render(timbit.help, context: timbit)

	@server.get ("/#{name}/test"), (req, res) ->
		timbit.test server, timbit, (results) ->
			#res.render "#{context.name}/#{context.view}", context: context
			res.send ck.render(test, context: results)

	# configure the route
	@server.get ("/#{name}/:view?"), (req, res) ->

		try
			# initialize current request context
			context = {}
			context[k] = v for k,v of req.query

			context.name = name
			context.view = req.params.view ?= 'default'

			# validate the request
			for key, attr of timbit.params
				context[key] ?= attr.default
				value = context[key]

				if attr.required and not value
					throw "#{key} is a required parameter"

				if value and attr.strict and attr.values.indexOf(value) is -1
					throw "#{value} is not a valid value for #{key}.  Must be one of [#{attr.values.join()}]"

				if value instanceof Array and not attr.multiple
					throw "#{key} must be a single value"

			# with context created, it's time to consume this timbit
			timbit.eat req, res, context
		catch ex
			log.error "#{req.url} - #{ex}"
			throw ex

help = ->
	style '''body {
		background: #d2d5dc; /* Old browsers */
		background: -moz-linear-gradient(top, #d2d5dc 0%, #ffffff 75%); /* FF3.6+ */
		background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#d2d5dc), color-stop(75%,#ffffff)); /* Chrome,Safari4+ */
		background: -webkit-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Chrome10+,Safari5.1+ */
		background: -o-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Opera11.10+ */
		background: -ms-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* IE10+ */
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d2d5dc', endColorstr='#ffffff',GradientType=0 ); /* IE6-9 */
		background: linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* W3C */
		background-repeat: no-repeat;
		margin: 0;
		padding: 0;
		font: 14px Tahoma, Geneva, sans-serif;
	}
	#content {
	    background: #fff none;
	    width: 750px;
	    padding: 5px 20px 20px 20px;
		box-shadow: 0 0px 20px #666;
		min-height: 500px;
	}

	a {color: #4E5989; text-decoration: underline;}
	a:hover {text-decoration: none;}

	#wrapper {width: 750px; margin: 0 auto;}

	h1 {border-bottom: 1px solid #999; width: 100%; font: 30px Tahoma, Geneva, sans-serif}

	p, h3 {margin: 0 0 5px 0;}
	h2 {margin: 40px 0 5px 0;}

	ul {
	    margin: 0 0 10px 0;
	    list-style: none;
		padding: 0;
	}

	li {padding: 0 0 10px 0; text-transform: uppercase;}
	'''

	div id:'wrapper', ->
		div id:'content', ->
			h1 'Timbits - Help'

			ul ->
				for k, v of @
					li -> a href: "/#{k}/help", -> k + ' &raquo;'

test = ->
	h1 ->
		"Test Timbit '#{@timbit}'"

	h3 'Testing Summary'

	h4 'Views'
	ul ->
		for view in @views
			li -> view

	if @required?.length > 0
		h4 'Required Parameters'
		ul ->
			for required in @required
				li -> required

	if @optional?.length > 0
		h4 'Optional Parameters'
		ul ->
			for optional in @optional
				li -> optional

	passed = 0
	failed = 0
	for test in @tests
		if test.status == 200 then passed++ else failed++

	if passed > 0
		h3 "Passed (#{passed})"
		table ->
			thead ->
				tr ->
					td 'Type'
					td 'URL'
			tbody ->
				for test in @tests
					if test.status is 200
						tr ->
							td test.type
							td test.uri

	if failed > 0
		h3 "Failed (#{failed})"
		table ->
			thead ->
				tr ->
					td 'Type'
					td 'URL'
					td 'HTTP Status'
					td 'Error Message'
			tbody ->
				for test in @tests
					if test.status isnt 200
						tr ->
							td test.type
							td test.uri
							td test.status
							td test.error

# definition of a timbit
class @Timbit

	# default render implementation
	render: (req, res, context) ->
		if context.remote is 'true'
			output = """
					$().ready(function() {
						return $.get("/#{context.name}/#{context.view}.coffee", function(data) {
							context = #{JSON.stringify(context)};
							return $('##{context.timbit_id}').html(CoffeeKup.render(data, context));
						});
					});
			"""
			res.setHeader "Content-Type", "text/plain"
			res.write output
			res.end()
		else
			res.render "#{context.name}/#{context.view}", context: context

	# helper method to retrieve data via REST
	fetch: (req, res, context, key, options, callback = @render) ->

		pantry.fetch options, (error, results) =>
			context[key] = results

			# we're done, will now execute rendor method unless otherwise specified
			callback(req, res, context)

	# this is the method executed after a matching route.  overwritten on most implementations
	eat: (req, res, context) ->
		@render req, res, context

	help: ->
		style '''body {
			background: #d2d5dc; /* Old browsers */
			background: -moz-linear-gradient(top, #d2d5dc 0%, #ffffff 75%); /* FF3.6+ */
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#d2d5dc), color-stop(75%,#ffffff)); /* Chrome,Safari4+ */
			background: -webkit-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Chrome10+,Safari5.1+ */
			background: -o-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Opera11.10+ */
			background: -ms-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* IE10+ */
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d2d5dc', endColorstr='#ffffff',GradientType=0 ); /* IE6-9 */
			background: linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* W3C */
			background-repeat: no-repeat;
			margin: 0;
			padding: 0;
			font: 14px Tahoma, Geneva, sans-serif;
		}
		#content {
		    background: #fff none;
		    width: 750px;
		    padding: 5px 20px 20px 20px;
			box-shadow: 0 0px 20px #666;
			min-height: 500px;
		}

		a {color: #4E5989; text-decoration: underline;}
		a:hover {text-decoration: none;}

		#wrapper {width: 750px; margin: 0 auto;}

		h1 {border-bottom: 1px solid #999; width: 100%; font: 30px Tahoma, Geneva, sans-serif}
		h2 {font: 20px Tahoma, Geneva, sans-serif}

		p, h3 {margin: 0 0 5px 0;}
		h2 {margin: 40px 0 5px 0;}

		ul {
		    margin: 0 0 10px 0;
		    list-style: none;
			padding: 0;
		}

		li {padding: 0 0 10px 0; text-transform: uppercase;}
		#return {margin-top: 20px;}
		table {border: 1px solid #4E5989; width: 100%; border-collapse: collapse; border-spacing: 0;}
		th, tr {text-align: left; border-bottom: 1px solid #4E5989;}
		td, th {border-right: 1px solid #4E5989;}
		td, th {padding: 5px;}
		'''
		div id:'wrapper', ->
			div id:'content', ->
				h1 @name

				p @about or 'Developer was too lazy to describe this widget'

				h2 'Examples:'

				if @examples
					ul ->
						for example in @examples
							li -> a href: example.href, -> example.caption
				else
					p 'Developer was too lazy to define any examples.'

				h2 'Parameters'

				if @params
					table ->
						tbody ->
							tr ->
								th 'Name'
								th 'Description'
								th 'Type'
								th 'Required'
								th 'Multiple'
								th 'Default'
								th 'Values'
							for key, attr of @params
								tr ->
									td key
									td attr.description
									td attr.type or 'String'
									td (attr.required or false).toString()
									td (attr.multiple or false).toString()
									td attr.default
									if attr.values then td ->
										if attr.strict then text('One of:') else text('Examples:')
										ul -> li value for value in attr.values

				else
					p 'None defined'

				div id:'return', -> a href: '/timbits/help', -> '&laquo; Help Index'

	test: (server, context, callback) ->
		results = {
			timbit: context.name
			views: []
			required: []
			optional: []
			queries: []
			tests: []
		}

		testViews = (callback) ->
			# Retrieve list of views form the views directory for this timbit
			fs.readdir "#{config.home}/views/#{context.name}", (err,list) ->
				if err || list is undefined
					results.tests.push { type: 'retrieve list', uri: '', status: '', error: "Unable to retrieve a list of views" }
					results.views.push 'default' # We will attempt the default view anyway and hope the timbit knows what it is doing.
				else
					for file in list then do (file) ->
						if file.match(/\.coffee/)?
							results.views.push (require('path').basename(file, '.coffee'))
				callback()

		testParams = ->
			# Process parameters, seperate into required vs. optional
			for k, v of context.params
				param = "#{k}=#{v.values[0]}"
				if v.required
					results.required.push param
				else
					results.optional.push param

		testQueries = ->
			# Determine whether we have optional and required parameters and build query strings.
			results.queries.push "#{results.required.concat(results.optional).join('&')}"

		testRequest = (type, uri, callback) ->
			# Execute request for uri and store result
			request {uri: "#{uri}" }, (error, response, body) ->
				results.tests.push { type: type, uri: uri, status: response.statusCode, error: (if error? then error else (if body? then body else '')) }
				callback()

		testRunQueries = (callback) ->
			if results.queries?.length is 0
				# Test each view if no query parameters present
				pending = results.views.length
				for view in results.views then do (view) ->
					testRequest "views", "http://#{server.address}:#{server.port}/#{context.name}/#{view}", ->
						callback() unless --pending
			else
				# Test each query for each view
				pending = results.queries.length * results.views.length
				for query in results.queries then do (query) ->
					for view in results.views then do (view) ->
						testRequest "queries", "http://#{server.address}:#{server.port}/#{context.name}/#{view}?#{query}", ->
							callback() unless --pending							

		testRunExamples = (callback) ->
			# Test the example links provided.
			if context.examples?
				pending = context.examples.length
				for example in context.examples then do (example) ->
					testRequest "example", "http://#{server.address}:#{server.port}#{example.href}", ->
						callback() unless --pending
			else
			 	callback()

		runTests = ->
			# Execute the tests based on provided querystrings, views and examples.
			testViews ->
				testParams()
				testQueries()
				testRunQueries ->
					testRunExamples ->
						displayTests()

		displayTests = ->
			log.notice "Testing Timbit - #{context.name}"
			for test in results.tests
				if test.status >= 400 or error?
					log.error "Test: #{test.type} URI: #{test.uri} Status: #{test.status} Error: #{test.error}"
				else
					log.info "Test: #{test.type} URI: #{test.uri} Status: #{test.status}"				
			callback results

		runTests()