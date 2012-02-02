fs = require 'fs'
path = require 'path'
querystring = require 'querystring'
url = require 'url'
views = require './timbits-views'
ck = require 'coffeekup'
Log = require 'coloured-log'
assets = require 'connect-assets'
connectESI = require 'connect-esi'
express = require 'express'
pantry = require 'pantry'
request = require 'request'
jsonp = require 'jsonp-filter'
less = require 'connect-less'

config = { appName: "Timbits", engine: "coffee", port: 5678, home: process.cwd(), maxAge: 60, secret: "secret" }
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
	@server.set 'jsonp callback', true;

	@server.configure =>
		@server.use express.bodyParser()
		@server.use express.cookieParser()
		@server.use express.session({ secret: config.secret })
		@server.use jsonp.setupJSONP()
		@server.use connectESI.setupESI()
		@server.use express.static(path.join(config.home, "public"))
		@server.use express.static(path.join(path.dirname(__filename),"../resources"))
		@server.use assets({src: path.join(config.home, "public")}) # serve static files or compile coffee and serve js
		@server.use less({src: path.join(config.home, "public")})

	@server.configure 'development', =>
		@server.use express.errorHandler({ dumpExceptions: true, showStack: true })

	@server.configure 'production', =>
		@server.use express.errorHandler()

	# route root to help page
	@server.all '/', (req, res) ->
		res.redirect '/timbits/help'

	# route json page
	@server.get '/timbits/json', (req, res) =>
		res.json @box

	# route help page
	@server.all '/timbits/help', (req, res) =>
		res.send ck.render(views.help, {box: @box} )

	# route master test page
	@server.all '/timbits/test', (req, res) =>
		res.setHeader 'Content-Type', 'text/html; charset=UTF-8'
		master = ''
		pending = Object.keys(@box).length
		if pending
			for timbit of @box
				request {uri: "http://#{req.headers.host}/#{timbit}/test" }, (error, response, body) ->
					master += body
					res.end master unless --pending
		else
			master += ck.render(views.test, {})
			res.end master

	# automagically load helpers found in the ./helpers folder
	helper_path = path.join(config.home, "helpers")
	helpers = {}
	fs.readdir helper_path, (err, files) =>
		if not err?
			for file in files
				if file.match(/\.(coffee|js)$/)?
					helper_name = file.substring(0, file.lastIndexOf("."))
					log.info "Loading dynamic helpers: #{helper_name}"
					helpers[helper_name] = require(path.join(helper_path, file))
					@server.helpers helpers

	# automagically load timbits found in the ./timbits folder
	timbit_path = "#{config.home}/timbits"
	fs.readdir timbit_path, (err, files) =>
		throw err if err
		for file in files
			if file.match(/\.(coffee|js)$/)?
				@add file.substring(0, file.lastIndexOf(".")), require( path.join(timbit_path, file))

	# starts the server
	try
		@server.listen process.env.PORT || process.env.C9_PORT || config.port
		log.info "Timbits server listening on port #{@server.address().port} in #{@server.settings.env} mode"
		server.address = @server.address().address
		server.port = @server.address().port
	catch err
		log.error "Server could not start on port #{process.env.PORT || process.env.C9_PORT || config.port}. (#{err})"
		console.log "\nPress Ctrl+C to Exit"
		process.kill process.pid, 'SIGTERM'
	@server

# the box that holds each of the individual timbits created
@box = {}

# use the 'add' method to place a timbit in the box
@add = (name, timbit) ->
	#place the timbit in the box
	log.notice "Placing #{name} in the box"
	timbit.name = name
	timbit.viewBase ?= name
	timbit.maxAge ?= config.maxAge
	timbit.listviews (views) =>
		timbit.views = views
	@box[name] = timbit

	# configure help
	@server.all ("/#{name}/help"), (req, res) ->
		renderHelp = ->
			res.send ck.render(views.timbit_help, timbit)
		timbit.listviews (views) ->
			timbit.views = views
			renderHelp()

	# configure test
	@server.all ("/#{name}/test"), (req, res) ->
		timbit.test "http://#{req.headers.host}", timbit, (results) ->
			res.send ck.render(views.timbit_test, results)

	# configure the route
	@server.all ("/#{name}/:view?"), (req, res) ->
		try
			# initialize current request context
			context = {}
			context[k.toLowerCase()] = v for k,v of req.query when v? and v isnt '' 

			context.name = timbit.name
			context.view = "#{timbit.viewBase}/#{req.params.view ?= 'default'}"
			context.maxAge = timbit.maxAge

			# validate the request
			for k, attr of timbit.params
				key = k.toLowerCase()
				context[key] ?= attr.default
				value = context[key]

				if value?
					attr.type ?= 'String'
					switch attr.type.toLowerCase()
						when 'number'
							context[key] = Number(value)
							throw "#{value} is not a valid Number for #{key}" if isNaN(context[key])
						when 'boolean'
							if value.toLowerCase() is 'true'
								context[key] = true
							else if value.toLowerCase() is 'false'
								context[key] = false
							else
								throw "#{value} is not a valid value for #{key}.  Must be true or false."
						when 'date'
							context[key] = Date.parse(value)
							throw "#{value} is not a valid Date for #{key}" if isNaN(context[key])

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

# definition of a timbit
class @Timbit

	log: log

	# default render implementation
	render: (req, res, context) ->

		# add caching headers
		res.setHeader "Cache-Control", "max-age=#{context.maxAge}"
		res.setHeader "Edge-Control", "max-age=#{context.maxAge}"

		if /^\w+\/json$/.test(context.view)
			res.json context
		else
			res.render context.view, context

	# helper method to retrieve data via REST
	fetch: (req, res, context, options, callback = @render) ->
		name = options.name or 'data'
		pantry.fetch options, (error, results) ->
			if context[name]?
				if Object::toString.call(context[name][0]) is "[object Array]" # check if first item is array
					context[name].push results
					context["#{name}_uri"].push options.uri
				else
					context[name] = [context[name], results]
					context["#{name}_uri"] = [context["#{name}_uri"], options.uri]
			else
				context[name] = results
				context["#{name}_uri"] = options.uri

			# we're done, will now execute rendor method unless otherwise specified
			callback(req, res, context)

	# this is the method executed after a matching route.  overwritten on most implementations
	eat: (req, res, context) ->
		@render req, res, context

	# this method returns a list of views available to this timbit
	listviews: (callback) ->
		view = []
		fs.readdir path.join(config.home, 'views', @viewBase), (err,list) ->
			if err || list is undefined
				view.push 'default' # We will attempt the default view anyway and hope the timbit knows what it is doing.
			else
				for file in list then do (file) ->
					if file.match(/\.coffee/)?
						view.push file.substring(0, file.lastIndexOf("."))
			callback(view)

	test: (host, context, callback) ->
		results = {
			timbit: context.name
			views: []
			required: []
			optional: []
			queries: []
			tests: []
			warnings: []
		}

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
				results.tests.push { type: type, uri: uri, status: response.statusCode, error: (if error? then error else '') }
				callback()

		testRunQueries = (callback) ->
			if results.queries?.length is 0
				# Test each view if no query parameters present
				pending = results.views.length
				for view in results.views then do (view) ->
					testRequest "views", "#{host}/#{context.name}/#{view}", ->
						callback() unless --pending
			else
				# Test each query for each view
				pending = results.queries.length * results.views.length
				for query in results.queries then do (query) ->
					for view in results.views then do (view) ->
						testRequest "queries","#{host}/#{context.name}/#{view}?#{query}", ->
							callback() unless --pending

		testRunExamples = (callback) ->
			# Test the example links provided.
			if context.examples?
				pending = context.examples.length
				for example in context.examples then do (example) ->
					testRequest "example", "#{host}#{example.href}", ->
						callback() unless --pending
			else
			 	callback()

		runTests = ->
			# Execute the tests based on provided querystrings, views and examples.
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
			for warning in results.warnings
					log.warning "Message: #{warning.message}"
			callback results

		@listviews (views) ->
			results.views = views
			runTests()
