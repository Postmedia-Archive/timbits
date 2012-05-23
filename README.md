# Timbits
Widget framework based on Express and CoffeeScript

## Introduction

Timbits is an attempt to build an easy and reusable widget framework on top of Express.  These widgets are meant to render independent HTML snippets based on REST based JSON/XML data sources and brought together on a page via ESI (Edge Side Includes).

It's primarily meant to serve internal purposes as Postmedia Network Inc, however it is being open sourced under the MIT License.  Others may find some use for what we are doing, and still others may be able to help turn this into a more generic and useful solution by contributing and/or correcting our ignorant ways.

Constructive criticism is encouraged.  If you see something odd and think to yourself "WTF?" then by all means, let us know.  We are eager and willing to learn.

## Installing

Just grab [node.js](http://nodejs.org/#download) and [npm](http://github.com/isaacs/npm) and you're set:

	npm install timbits -g
	
Timbits is simplistic and finds most of it's power by running on top of some very cool node libraries such as [express](http://expressjs.com/), [CoffeeScript](http://coffeescript.org) and [CoffeeKup](http://coffeekup.org/).  It also now uses our [Pantry](https://github.com/Postmedia/pantry) package for JSON/XML data sources.  

## Using

Yea, we're not even close to having useful documentation yet.  Stay tuned.  In the mean time, review the example.

The structure of a timbits application is fairly simple.  To start, you need a two lines in your main server.js file.  

	var timbits = require('timbits');
	var server = timbits.serve();

Also ensure (at least for now, due to lack of error handling) that you create the following subfolders:

* /public - images, javascript, stylesheets etc.
* /timbits - this is where we place the individual timbit (widget) files
* /views - views for a particular timbit are placed in a subfolder of the same name

When you start the server, it will automatically load all the timbits loaded in the /timbits folder.  The name of the timbit is determined by the name of the file, and that name in term determines the default route (/name/:view?) and the default view (/views/name/default.coffee).  Aside from the location and name of the timbits, the rest is customizable as shown in the examples.

Note that timbits can be created in JavaScript or CoffeeScript.  This documentation will assume CoffeeScript.

The simplest of timbits takes the following form:

	timbits = require 'timbits'
	timbit = module.exports = new timbits.Timbit()

That's it.  If you created this as /timbits/test.coffee and placed a default view at /views/test/default.coffee, you could "eat" this timbit by going to /test in a browser.  See the "plain" timbit for an example of this.

## How it works

So, how does this all work?

When you start up a timbits based project, the framework will dynamically load each timbit from the /timbits/ folder.  A timbit is
nothing more than a JS or CS file which creates and exports a new instance of the Timbit class.

This Timbit class has one very important method named "eat" which is the entry point for every request.  This method is intended to
be overwritten.   When called, the framework will pass in the following three variables

* req - the http request object
* res - the http response object
* context - a hash of data properties

The req and res parameters come straight from Express.js and are documented [here](http://expressjs.com/guide.html#routing).
The context object originates within Timbits, and will initially contain the following properties:

* name - the name of the timbit being executed
* view - the name of the specified view
* maxAge - the number of seconds the response should be cached for

It's important to note that it is possible to override the view and/or the maxAge during the execution of the request if needed.

In addition, each route, querystring and post parameter is also added to the context as a property.  So, if one included ?page=5 in the request url this value would be made available to you as context.page

Within the eat method, the simplist of implementations will merely call the render method to, well, render the given view using the data found with the context.  The render method takes the same three parameters originally passed into the eat method.  Within the render method Timbits will pass to the context to the view rendering engine so that those values can be 
referenced within the view.  So a very simple eat method could look like this

	eat: (req, res, context) ->
		@render req, res, context

In fact, that's exactly what it looks like within the Timbit class, so if you don't override it, the timbit will simply pass on the request parameters for rendering.  But that's generally not very useful.  The intent in most cases is to add additional data to the context, whether it be generated on the local server (like a timestamp - see the cherry timbit example) or more likely from an external resource like a RSS or JSON feed/API.

For those instances where you do need to pull in remote data, we've incorporated [Pantry](https://github.com/Postmedia/pantry) into Timbits to make fetching (and caching) those resources extra easy.  This is available to you via the built in fetch method.

The fetch method takes five parameters.  The first three are the same as the render method: req, res, context.  It then adds two additional parameters

* options - This is a hash of options passed directly to Pantry's fetch method.  It identifies the source URI of the resource you want to retrieve along with a host of other options as documented within Pantry
* callback - This is an optional parameter which identifies the function to execute once the request has been completed.  It defaults to the render method

The fetch method will automatically add the retrieved resource to context.data by default.  If that isn't acceptable, you can also add a property called "name" to the options parameter to specify an alternate property name to store the data in.  This is shown in the included "dutchie" example as follows:

	# specify the data source
	src = {
		name: 'tweets'
		uri: "http://search.twitter.com/search.json?q=#{context.q}"
	}

	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch req, res, context, src
	
Be aware that if (using the example above) context.tweets already exists, timbits will transform context.tweets into an array (if it isn't already) and append the retrieved resource to the array.

Once the request has been completed and the data added to the context, and no callback is specified, the fetch method will then call the render method for you.  If you need to request some additional resources, or perhaps further manipulate the resource once it's been fetched, simply tack on the optional callback parameter and implement your follow up code.  Timbits will pass on the req, res, and context parameters to the callback, and just be sure to call the render method once you're done.

	@fetch req, res, context, src, (req, res, context) ->
		# run your custom code here
		# ......
		# ......
		
		# and then call render
		@render req, res, context

## Additional Features

### Command Line

Create a new project, generate a timbit (and default view), or run the project with runjs

	timbits n[ew] [project]
	timbits g[enerate] [timbit]
	timbits s[erver]

### Server Configuration

The server object can be configured during initialization as needed.  The only parameter we strongly suggest you specify is 'secret'.  The following is a list of possible configuration parameters and their [default value]

* appName - Friendly name of the timbits application ['Timbits']
* engine - Default view engine ['coffee']
* base - A base path for nested servers.  e.g. '/my/nested/server' ['']
* port - The server port to listen on if PORT or C9_PORT env labels are not present. [5678]
* home - The physical path to the root project folder [process.cwd()]
* maxAge - The default cache length in seconds [60]
* secret - The string used to encrypt sessions ['secret']

The following example shows how to run a nested application using the 'eco' view engine in place of CoffeeKup

	var timbits = require('timbits');
	var eco = require('eco');
	var server = timbits.serve({appName: 'My Nested Timbits', engine: 'eco', base: '/nested/app', secret: '359#^#$KDKS'});
	server.register('.eco', eco);
	console.log("Press Ctrl+C to Exit");

### Parameter declaration and validation

You can now define a list of parameters which are automatically validated during execution.  This also powers the automated help and test functions (see further below).  Parameter attributes you can manipulate are:

* description
* type - data type expected, one of String (default), Number, Boolean, or Date
* default - default value to use if value not specified
* multiple - true/false (defaults to false), indicates whether multiple values are allowed
* required - true/false (defaults to false), indicates whether this is a required parameter
* values - an array of possible values
* strict - true/false (defaults to false), indicates whether the value must be one of the defined possible values 

Example (from plain)

	timbit.params = {
		who: {description: 'Name of person to greet', default: 'Anonymous', multiple: false, required: false, strict: false, values: ['Ed', 'World']}
		year: {description: 'To test multi parameters and drive Kevin crazy', type: 'Number', values: [1999, 2011]}
	}

### Dynamic Help

Along with the list of parameters, one can also augment a timbit definition with a description (timbit.about) and a list of valid examples (timbit.examples).

Example (from plain)

	timbit.about = '
		Example of the simplest timbit that could possibly be created.
		This timbit will simply render a view using data from the query string.
		'

	timbit.examples = [
		{href: '/plain', caption: 'Anonymous'}
		{href: '/plain/?who=world', caption: 'Hello World'}
		{href: '/plain/?who=Kevin&year=1999', caption: 'Flashback'}]
		
Together these all help power the automated, dynamic help page for each timbit, which can be found using the hardcoded 'help' view.  e.g. /plain/help

There is also a built in help index that for any timbits project located at /timbits/help

### Dynamic Testing

The examples and params used to power the help pages are also used to power the automated test pages.  Each timbit has a 'test' view which will utilize this information to define and execute some basic testing of the timbit.  e.g. /plain/test

There is also a master test page located at /timbits/test which will execute tests 
Although not overly sophisticated, it will ensure your definitions, examples, and views are valid and compile properly.  It is also useful for remote monitoring of production systems.

Additional functional testing can and should be implemented via a testing library, such as vows [vows](http://vowsjs.org/)

### Default view

By default, the name of the default view is, well, default!  You do have the ability to specify something more descriptive if you so desire.  Simply set the defaultView property to whatever view name you'd like to use

	# the name default is so booooring.  use my fancy view by default is instead
	timbit.defaultView = 'fancy'
	
### Sharing of views

If you have two or more timbits for which you would like to share views, simply set the viewBase property on the timbit to the name of the timbit who's views you'd like to utilize (see the Dutchie timbit as an example)

	# this timbit should use the views from the chocolate timbit
	timbit.viewBase = 'chocolate'

### Downstream Caching

There is a maxAge property that can set the number of seconds client can/should cache the response for.  If not set, the default value will come from the Timbits configuration, which if not set, is currently 60 seconds by default.  You can also override this value on a request by request basis by setting the context.maxAge value to whatever is appropriate.

	# timbit should be cached for 5 minutes
	timbit.maxAge = 300
	
The maxAge value will be included in two response headers, the standard Cache-Control header as well as a special Edge-Control header (used by Akamai)

### Built in JSON view

If you're interested in rendering the data elsewhere (for example client side) or you simply want to see what's available to you in the current context for debugging purposes, Timbits includes a built in view named "json" that will render the context object as 'application/json'.   e.g.  /dutchie/json

### Dynamic View Helpers

New in v0.3.0, view helpers are now loaded automagically from the ./helpers folder upon startup.  To include new helpers, simply create a [helper_name].coffee or [helper_name].js file in the ./helpers folder and export one or more functions.

For example, if you create a file called ./helpers/handy.coffee (like we did in examples), timbits will automatically include all the  exported functions from handy.coffee under the helper 'handy'.  See the 'with-help' view for the plain timbit as an example.

### Advanced caching via pantry

As of [Pantry](https://github.com/Postmedia/pantry) v0.3.0, you are now able to configure alternate storage caches. As of Timbits v0.5.0 one can now control the pantry configuration properties as well as substitute the default MemoryStorage caching via the exported timbits.pantry property.

	var RedisStorage, server, timbits;

	timbits = require('../src/timbits');

	RedisStorage = require('pantry/lib/pantry-redis');

	timbits.pantry.storage = new RedisStorage(null, null, null, 'DEBUG');

	timbits.pantry.configure({
	  verbosity: 'DEBUG'
	});

	server = timbits.serve({
	  home: __dirname
	});

### Client Side Rendering

Not everyone will be able to utilize an ESI processor in front of their site, or more likely on their development workstation, so we've added a quick and easy way to pull in timbits client side.  Timbits supports an optional callback parameter which will package the rendered response as a simple JSONP package. 

Example:

	/chocolate?q=winning&callback=done

Included with Timbits is a simple client-side JS library (/javascript/timbits-csi.js) which utilizes jQuery to post-process an HTML page for esi:include tags, automatically tacking on the callback parameter and pulling in the results client side.

The timbits-csi.js allows for the use of both the regular esi: namespace OR our very own csi: (for client side include), as there may be times you want your ESI processor to handle some of the widgets while others you may want to only handle client side.  Since any ESI processor wouldn't handle the csi: namespace, they would skipped and delivered to the browser as is for handling there.

Example:

	<csi:include src="http://mytimbitserver.fake/plain/?who=world"></csi:include>
	<esi:include src="http://mytimbitserver.fake/chocolate/?q=winning"></esi:include>


In the example above, if the page was served through an ESI compatible proxy the first item would be rendered on the client (in the browser) while the second would be rendered within the proxy.  If there was no ESI compatible proxy in place, both would be rendered on the client.

To render these tags client side, include the jQuery library and the include /javascript/timbits-csi.js library on your page.

We've also added support for the dynamic insertion of query string values into your client side ESI/CSI calls via the standard $(QUERY\_STRING{'name'}) syntax.  For example, the following will grab the query string parameter 'term' from the host page and insert it into the source url prior to making the request.

	<esi:include src="http://mytimbitserver.fake/chocolate/?q=$(QUERY_STRING{'term'})"></esi:include>


## Road Map

We have a number of items in the pipeline which we believe will provide a lot of power to this platform, such as:

* Integrated benchmarks
* Real-time data updates via Socket.IO


## Created by

* Edward de Groot
* Keith Benedict
* Stephen Veerman
* Kevin Gamble
