fs = require 'fs'
path = require 'path'
querystring = require 'querystring'
url = require 'url'
views = require './timbits-views'
ck = require 'coffeekup'
Log = require 'coloured-log'
express = require 'express'
@pantry = pantry = require 'pantry'
request = require 'request'

config = {
	appName: 'Timbits'
	engine: 'coffee'
	base: ''
	port: 5678
	home: process.cwd()
	maxAge: 60
	secret: 'secret'
	discovery: true  # support automatic discovery via /timbits/json
	help: true # allow automatic help pages at /timbits/help and /[name]/help
	test: true # allow automatic test pages at /timbits/test and /[name]/test
	json: true # allow built in json view at /[name]/json
	jsonp: true # allow jsonp calls via /[name]/json?callback=
}

server = {}
log = new Log(process.env.TIMBITS_VERBOSITY or Log.NOTICE)

# creates, configures, and returns a standard express server instance
@serve = (options) ->
	config[key] = value for key, value of options
	@server = express.createServer()

	# support coffeekup
	@server.register '.coffee', ck

	# configure server
	@server.set 'views', "#{config.home}/views"
	@server.set 'view engine', config.engine
	@server.set 'view options', {layout: false}
	
	@server.set 'jsonp callback', config.jsonp

	@server.configure =>
		@server.use express.bodyParser()
		@server.use express.cookieParser()
		@server.use express.session({ secret: config.secret })
		@server.use express.static(path.join(config.home, "public"))
		@server.use express.static(path.join(path.dirname(__filename),"../resources"))

	@server.configure 'development', =>
		@server.use express.errorHandler({ dumpExceptions: true, showStack: true })

	@server.configure 'production', =>
		@server.use express.errorHandler()

	# route root to help page
	if config.help
		@server.all "#{config.base}/", (req, res) ->
			res.redirect "#{config.base}/timbits/help"

	# route json discovery
	@server.get "#{config.base}/timbits/json", (req, res) =>
		if config.discovery
			res.json @box
		else
			res.send "Automatic Discovery has been disabled", 404

	# route help page
	@server.get "#{config.base}/timbits/help", (req, res) =>
		if config.help
			res.send ck.render(views.help, {box: @box} )
		else
			res.send "Automatic Help has been disabled", 404
			

	# route master test page
	@server.get "#{config.base}/timbits/test/:which?", (req, res) =>
		if config.test
			alltests = req.params.which is 'all'
			all_results = []
			pending = Object.keys(@box).length
			if pending
				for name, timbit of @box
					timbit.test "http://#{req.headers.host}", alltests, (results) ->
						all_results.push result for result in results
						if --pending is 0
							res.send ck.render(views.test, {results: all_results} )
			else
				res.send ck.render(views.test, {})
		else
			res.send "Automatic Test has been disabled", 404
		

	# automagically load helpers found in the ./helpers folder
	helper_path = path.join(config.home, "helpers")
	helpers = {}
	if fs.existsSync(helper_path)
		for file in fs.readdirSync(helper_path)
			if file.match(/\.(coffee|js)$/)?
				helper_name = file.substring(0, file.lastIndexOf("."))
				log.notice "Loading dynamic helpers: #{helper_name}"
				helpers[helper_name] = require(path.join(helper_path, file))
				@server.helpers helpers

	# automagically load timbits found in the ./timbits folder
	timbit_path = "#{config.home}/timbits"
	
	files = []
	
	for file in fs.readdirSync(timbit_path) 
		files.push file if file.match(/\.(coffee|js)$/)?
	
	pending = files.length
	for file in files
		@add file.substring(0, file.lastIndexOf(".")), require( path.join(timbit_path, file)), =>
			pending--
			
			# start the server once all the timbits have been loaded
			if pending is 0
				try
					@server.listen process.env.PORT || process.env.C9_PORT || config.port
					log.notice "Timbits server listening on port #{@server.address().port} in #{@server.settings.env} mode"
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
@add = (name, timbit, callback) ->
	#place the timbit in the box
	log.notice "Placing #{name} in the box"
	timbit.name = name
	timbit.viewBase ?= name
	timbit.defaultView ?= 'default'
	timbit.maxAge ?= config.maxAge
	
	# generate list of views
	timbit.views = []
	viewpath = path.join(config.home, 'views', timbit.viewBase)
	
	if fs.existsSync(viewpath)
		for file in fs.readdirSync(viewpath)
			if file.match(/\.coffee/)?
				timbit.views.push file.substring(0, file.lastIndexOf("."))
	else
		# We will attempt the default view anyway and hope the timbit knows what it is doing.
		timbit.views.push @defaultView
	
	@box[name] = timbit

	# configure help
	@server.get ("#{config.base}/#{name}/help"), (req, res) ->
		if config.help
			res.send ck.render(views.timbit_help, timbit)
		else
			res.send "Automatic Help has been disabled", 404

	# configure test
	@server.get ("#{config.base}/#{name}/test/:which?"), (req, res) ->
		if config.test
			alltests = req.params.which is 'all'
			timbit.test "http://#{req.headers.host}", alltests, (results) ->
				res.send ck.render(views.timbit_test, {name: timbit.name, results: results} )
		else
			res.send "Automatic Test has been disabled", 404


	# configure the route
	@server.all ("#{config.base}/#{name}/:view?"), (req, res) ->
		try
			# initialize current request context
			context = {}
			
			# add query string parameters to context
			for k,v of req.query when v? and v isnt '' 
				key = k.toLowerCase()
				
				# handle aliased parameters
				has_alias = false
				for p, attr of timbit.params when attr.alias is key
					has_alias = true
					context[p] = v
				
				# no alias found
				context[key] = v if not has_alias
				
			context.name = timbit.name
			context.view = "#{timbit.viewBase}/#{req.params.view ?= timbit.defaultView}"
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
			try
				timbit.eat req, res, context
			catch err
				log.error "Error eating timbit #{timbit.name}: #{err.stack}"
				res.send "There was an error processing this request.", 500
				
				
		catch ex
			log.error "#{req.url} - #{ex}"
			throw ex
			
	# update example urls if base vpath specified
	if config.base? and timbit.examples?
		for example in timbit.examples
			example.href = "#{config.base}#{example.href}"
			
	# callback after timbit has been loaded
	callback()

# definition of a timbit
class @Timbit

	pantry: pantry
	log: log

	# default render implementation
	render: (req, res, context) ->

		# add caching headers
		res.setHeader "Cache-Control", "max-age=#{context.maxAge}"
		res.setHeader "Edge-Control", "!no-store, max-age=#{context.maxAge}"

		if /^\w+\/json$/.test(context.view)
			if config.json
				res.json context
			else
				res.send "JSON view has been disabled", 404
		else
			res.render context.view, context, (err, str) =>
				if err
					log.error "Error rendering view #{context.view}: #{err.stack}"
					res.send "There was an error processing this request.", 500
				else
					if context.callback?
						# remote client side include
						res.json str
					else
						res.send str

	# helper method to retrieve data via REST
	fetch: (req, res, context, options, callback = @render) ->
		name = options.name or 'data'
		pantry.fetch options, (error, results) ->
			if error?
				log.error "Error fetching resource '#{options.uri}': #{(error.stack || error)}"
				res.send 'There was an error fetching the requested resource', 500
			else
				if context[name]?
					if Object::toString.call(context[name][0]) is "[object Array]" # check if first item is array
						context[name].push results
					else
						context[name] = [context[name], results]
				else
					context[name] = results

				# we're done, will now execute rendor method unless otherwise specified
				callback(req, res, context)

	# this is the method executed after a matching route.  overwritten on most implementations
	eat: (req, res, context) ->
		@render req, res, context

	generateTests: (alltests) ->
		
		getTestValues = (values, alltests) ->
			if values? and values.length? and values.length isnt 0
				if alltests
					return values
				else
					return values[0..0]
			else
				return []
		
		# create combination of required parameters
		required = []
		for name, param of @params when param.required is true
			temp = []
			for value in getTestValues(param.values, alltests)
				if required.length is 0
					temp.push "#{name}=#{value}"
				else
					for item in required
						temp.push "#{item}&#{name}=#{value}"
			required = temp

		# create list of possible queries using required and optional parameters
		queries = []
		queries.push item for item in required

		# only include optional parameters if all tests are requested
		if alltests
			for name, param of @params when param.required isnt true
				for value in getTestValues(param.values, alltests)
					if required.length is 0
						queries.push "#{name}=#{value}"
					else
						for item in required
							queries.push "#{item}&#{name}=#{value}"
						
		# create list of testable paths using available views and quiries
		hrefs = []
		
		# add examples to test cases
		for view in @views
			if queries.length
				for query in queries
					hrefs.push "/#{@name}/#{view}?#{query}"
			else
				hrefs.push "/#{@name}/#{view}"
			
		return hrefs

		
	test: (host, alltests, callback) ->

		# generate dynamic list of test urls
		tests = @generateTests(alltests)
		
		# add examples to list of tests
		if @examples
			for example in @examples
				tests.push example.href
			
		# run the tests
		name = @name
		results = []
		for href in tests
			do (href) ->
				request "#{host}#{href}", (error, response, body) ->
					error ?= if response.statusCode is 200 then '' else body
						
					results.push {
						timbit: name
						href: href
						error: error
						status: response.statusCode
					}
					if results.length is tests.length
						# we are done
						callback results
		
