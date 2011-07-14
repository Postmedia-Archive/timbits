express = require 'express'		
http = require 'http'
fs = require 'fs'

# creates, configures, and returns a standard express server instance
@serve = (@appName = 'Timbits', engine = 'coffee', port = 5678) ->
	@server = express.createServer()
	
	# support coffekup
	@server.register '.coffee', require('coffeekup')
	
	# configure server (still needs some thought) 	
	@server.set 'views', "#{process.cwd()}/views"
	@server.set 'view engine', engine
	@server.set 'view options', {layout: false}
		
	@server.configure =>
		@server.use express.static("#{process.cwd()}/public")
		@server.use express.bodyParser()
		@server.use express.cookieParser()

	@server.configure 'development', =>
		@server.use express.errorHandler({ dumpExceptions: true, showStack: true })

	@server.configure 'production', =>
		@server.use express.errorHandler()
		
	# route help page
	@server.get '/', (req, res) ->
		res.render 'help'
	
	#automagically load timbits found in the ./timbits folder	
	path = "#{process.cwd()}/timbits"
	fs.readdir path, (err, files) =>
		throw err if err
		for file in files
			name = file.replace('.coffee', '')
			@add name, require("#{path}/#{name}")

	# starts the server
	@server.listen port
	console.log "Timbits server listening on port #{@server.address().port} in #{@server.settings.env} mode"
	
	return @server 

# the box that holds each of the individual timbits created							
@box = {}	

# use the 'add' method to place a timbit in the box
@add = (name, timbit) ->
	#place the timbit in the box
	console.log "\t Placing #{name} in the box"
	timbit.name = name
	@box[name] = timbit
	
	# configure the route
	@server.get (timbit.route || "/#{name}/:view?"), (req, res) ->
		# initialize current request context
		context = {
			name: name
			view: req.params.view ?= 'default'
			request: req
			response: res
		}
		
		# with context created, it's time to consume this timbit
		timbit.eat context

# definition of a timbit
class @Timbit

	# default render implemenetation
	render: (context) ->
		context.response.render "#{context.name}/#{context.view}", context: context
	
	# helper method to retrieve data via REST	
	fetch: (context, key, url, next = @render) ->

		http.get url, (client) =>	
			console.log "#{key} STATUS: #{client.statusCode}"
			body = ""
			client.on 'data', (chunk) =>
				body += chunk.toString()
			client.on 'end', =>
				context[key] = JSON.parse(body)
				
				# we're done, will now execute rendor method unless otherwise specified
				next(context)
	
	# this is the method exectuted after a matching route.  overwritten on most implementations				
	eat: (context) ->
		@render context
			
		