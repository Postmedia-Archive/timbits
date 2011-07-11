
# Module dependencies.

timbits = require '../src/timbits'
app = timbits.createServer();

# Routes

app.get '/', (req, res) ->
	
	res.render 'index', {
		title: "Third Timbit"
	}

chocolate = new timbits.Timbit('Chocolate')
timbits.addFlavour app, chocolate

timbits.app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
