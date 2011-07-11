express = require 'express'		

exports.createServer = ->
	console.log "Creating Timbits Server..."
	
	app = express.createServer()

	# Configuration

	app.configure ->
		app.set 'views',"#{process.cwd()}/views"
		#app.register '.coffee', require('coffeekup')
		app.set 'view engine', 'jade'
		app.use express.bodyParser()
		app.use express.methodOverride()
		app.use app.router
		app.use express.static("#{process.cwd()}/public")
		
		app.configure 'development', ->
			app.use express.errorHandler({ dumpExceptions: true, showStack: true })

		app.configure 'production', ->
			app.use express.errorHandler()
			
		exports.app = app
		return app

class Timbit
	constructor: (@name) ->
	
	route: ->
		"/timbits/#{@name}/:view?"

exports.Timbit = Timbit

exports.addFlavour = (app, timbit) ->
	app.get timbit.route(), (req, res) ->
		res.send "#{timbit.name}: #{timbit.route()}"
	
	#flavour.add timbit