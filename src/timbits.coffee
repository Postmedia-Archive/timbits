express = require 'express'		
pantry = require 'pantry'
fs = require 'fs'
connectESI = require 'connect-esi'
ck = require 'coffeekup'

config = { appName: "Timbits", engine: "coffee", port: 5678, home: process.cwd() }

# creates, configures, and returns a standard express server instance
@serve = (options) ->
	config[key] = value for key, value of options
	@server = express.createServer()
	
	# support coffekup
	@server.register '.coffee', require('coffeekup')
	
	# configure server (still needs some thought) 	
	@server.set 'views', "#{config.home}/views"
	@server.set 'view engine', config.engine
	@server.set 'view options', {layout: false}
		
	@server.configure =>
		@server.use connectESI.setupESI()
		@server.use express.static("#{config.home}/public")
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
	
	# configure help
	@server.get ("/#{name}/help"), (req, res) ->
		res.send ck.render(timbit.help, context: timbit)
	
	@server.get ("/#{name}/test"), (req, res) ->
		res.send ck.render(test, context: null)
	
	# configure the route
	@server.get ("/#{name}/:view?"), (req, res) ->
		
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
		
help = ->
	h1 'Timbits - Help'

	ul ->
		for k, v of @
			li -> a href: "/#{k}/help", -> k
			
test = ->
	h1 'Testing? LOL!!!!!!'

# definition of a timbit
class @Timbit
	
	# default render implementation
	render: (req, res, context) ->
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
			table border: 1, ->
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
						td key
						td attr.description
						td attr.type or 'String'
						td (attr.required or false).toString()
						td (attr.multiple or false).toString()
						td attr.default
						td "#{if attr.strict then 'One of:' else 'Examples:'} #{attr.values.join()}"
		else
			p 'None defined'
	
		p -> a href: '/timbits/help', -> '<< Help Index'
		
	test: () ->
		console.log 'LOL!'
		