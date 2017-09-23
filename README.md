# Timbits
Widget framework based on Express

## Introduction

Timbits is an attempt to build an easy, and reusable widget framework on top of Express.  These widgets are meant to render independent HTML snippets based on REST based JSON/XML data sources, and brought together on a page via ESI (Edge Side Includes), or our own proprietary CSI (Client Side Includes).

It's primarily meant to serve internal purposes as Postmedia Network Inc, however, it is being open sourced under the MIT License.  Others may find some use for what we are doing, and still others may be able to help turn this into a more generic, and useful solution via contributions.

Constructive criticism is encouraged.

## Installing

Just grab [node.js](http://nodejs.org/#download) and [npm](http://github.com/isaacs/npm) and you're set:

	npm install timbits -g
	
Timbits is simplistic, and finds most of it's power by running on top of some very cool node libraries such as [Express](http://expressjs.com/) and [Hogan](http://twitter.github.com/hogan.js/).  It also uses our [Pantry](https://github.com/Postmedia/pantry) package for efficient utilization of JSON/XML data sources.

## Changes

We completed a significant rewrite of Timbits, these changes occur between version 0.6.7 and 0.7 release of timbits.  For those using previous versions of Timbits here is a quick rundown of the changes.

* major rewrite of Timbits source to JavaScript (formerly CoffeeScript)
* generates JavaScript files by default (CoffeeScript is optional)
* default view engine is now Hogan (formerly CoffeeKup)
* dynamic helpers are no longer supported
* sessions are no longer enabled by default
* uses Winston for logging (formerly coloured-log)

I'll be making a post on my [blog](http://mred9.com) providing more details on these changes, and the reasoning behind them.

Please be aware that the 0.7.x series should be considered experimental, and not for production use.  Once we've stabilized this rewrite it will be released as v0.8.x

### Running previous versions on 0.7

Projects using timbits prior to v0.7 based on CoffeeScript, and Coffeecup require a few changes in order to run. The instructions here provide the details required to get a simple timbit functional.  

There are two specific modifications required, the first is to include a dependency for CoffeeScript, and Coffeecup in your timbits package.json file:

	"dependencies": {
		"coffee-script": "~1.3.3",
		"coffeecup": "~0.3.20",
		..... additional dependencies here
	}

The second change is to the server.js file, you need to do three things:
* require coffee-script
* specify the engine parameter when instantiating the server object
* set the rendering method to handle coffeecup templates. 

The structure of the main server.js file could look like this:

	require('coffee-script');
	
	var timbits = require('timbits');
	var server = timbits.serve({ engine: 'coffee' });

	server.engine( 'coffee', require('coffeecup').__express );

That is all it will take, unless of course you are using dynamic view helpers, for that we need to make a change to the individual timbits themselves.  

Let's suppose you had a helper file helpers/headlines.coffee in your timbits project, in versions prior to 0.7, timbits dynamically loaded all helpers in the 'helpers' path.  These helpers were automatically loaded into the context based on the helper filename, so the example mentioned would load any helper functionality under context.headlines, now you must do this manually.

Include your helpers in each timbit that requires them, at the start of the fetch method. Assuming for example the helper file is headlines.coffee, you would use:

	@fetch req, res, context, options, =>
		# Add helpers manually at beginning of fetch
		context.headlines =  require("../helpers/headlines.coffee");


## Using

The structure of a Timbits application is fairly simple.  To start, you need a two lines in your main server.js file.  

	var timbits = require('timbits');
	var server = timbits.serve();

Timbits, like many other frameworks, prefers convention over configuration.  It will look for specific folders upon startup, and if you manually create your project (vs using the Timbits command line to generate a new project) you should create the following folders.

* /public - images, javascript, stylesheets etc.
* /timbits - this is where we place the individual timbit (widget) files
* /views - views for a particular timbit are placed in a subfolder of the same name

When you start the server, it will automatically load all the timbits found in the /timbits folder.  The name of the timbit is determined by the name of the file, and that name in turn determines the default route (/name/:view?), and the default view (/views/name/default.coffee).  Aside from the location, and name of the timbits, the rest is customizable as shown in the examples.

Timbits can be created in JavaScript (default), or CoffeeScript.  This documentation will assume JavaScript.

The simplest of timbits takes the following form:

	// Load the timbits module
	var timbits = require('../../lib/timbits');

	// create and export the timbit
	var timbit = module.exports = new timbits.Timbit();

That's it!  If you created this as /timbits/test.js, and placed a default view at /views/test/default.hjs, you could "eat" this timbit by going to /test in a browser.  See the "plain" timbit for an example of this.

## How it works

When you start up a Timbits based project, the framework will dynamically load each timbit from the /timbits/ folder.  A timbit is
nothing more than a .js, or .coffee file which creates, and exports a new instance of the Timbit class.

This Timbit class has one very important method named "eat" which is the entry point for every request.  This method is intended to
be overwritten.   When called, the framework will pass in the following three variables

* req - the http request object
* res - the http response object
* context - a hash of data properties

The req, and res parameters come straight from Express.js and are documented [here](http://expressjs.com/guide.html).
The context object originates within Timbits, and will initially contain the following properties:

* name - the name of the timbit being executed
* view - the name of the specified view
* maxAge - the number of seconds the response should be cached for

It's important to note that it is possible to override the view, and/or the maxAge during the execution of the request if needed.

Each timbit by default supports HTTP GET method, it is possible to support one of the alternativce standard HTTP methods as defined in [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html), specifically we support "GET", "POST", "PUT", "HEAD", and "DELETE".  To specified the methods you want to allow (beyond "GET") define the methods as json properties in the timbit.methods property like this

	timbit.methods = { 'get': false, 'post': true }

Values are boolean, the methods are not case sensitive, you only need to specify the methods you wish to override from the default settings. Any request for your timbit with a method not specified will result in an HTTP 405 "Method Not Supported" error.

Each route, querystring, and post parameter is also added to the context as a property.  So, if one included ?page=5 in the request url this value would be made available to you as context.page

Within the eat method, the simplest of implementations will merely call the render method to, well, render the given view using the data found with the context.  The render method takes the same three parameters originally passed into the eat method.  Within the render method Timbits will pass the context to the view rendering engine so that those values can be 
referenced within the view.  So a very simple eat method could look like this

	timbit.eat = function(req, res, context) {
	  this.render(req, res, context);
	};

In fact, that's exactly what it looks like within the Timbit class, so if you don't override it, the timbit will simply pass on the request parameters for rendering.  But that's generally not very useful.  The intent in most cases is to add additional data to the context, whether it be generated on the local server, like a timestamp (see the cherry timbit example), or more likely from an external resource like a RSS, or JSON feed/API.

In most cases you'll need to pull in remote data, so we've incorporated [Pantry](https://github.com/Postmedia/pantry) into Timbits to make fetching (and caching) those resources extra easy.  This is available to you via the built in fetch method.

The fetch method takes five parameters.  The first three are the same as the render method: req, res, context.  It then adds two additional parameters

* options - This is a hash of options passed directly to Pantry's fetch method.  It identifies the source URI of the resource you want to retrieve along with a host of other options as documented within Pantry
* callback - This is an optional parameter which identifies the function to execute once the request has been completed.  It defaults to the render method

The fetch method will automatically add the retrieved resource to context.data by default.  If that isn't acceptable, you can also add a property called "name" to the options parameter to specify an alternate property name to store the data in.  This is shown in the included "chocolate" example as follows:

	// specify the data source
	var src = {
	  name: 'ip',
	  uri: "http://jsonip.com?q=" + context.q + "&rpp=" + context.rpp
	};

	// use the helper method to fetch the data
	// timbit.fetch will call timbit.render once we have the data
	timbit.fetch(req, res, context, src);
	
Be aware that if (using the example above) context.ip already exists, timbits will transform context.ip into an array (if it isn't already), and append the retrieved resource to the array.

Once the request has been completed, the data added to the context, and no callback is specified, the fetch method will then call the render method for you.  If you need to request some additional resources, or perhaps further manipulate the resource once it's been fetched, simply tack on the optional callback parameter, and implement your follow up code.  Timbits will pass on the req, res, and context parameters to the callback.  Just be sure to call the render method once you're done.

	timbit.fetch(req, res, context, src, function(req, res, context){
		// run your custom code here
		// ......
		// ......
		
		// and then call render
		timbit.render(req, res, context);
	});

## Additional Features

### Command Line

Create a new project, generate a timbit (and default view), or run the project with runjs.  Run timbits -h for complete list of commands, and options available.

	timbits n[ew] [project]
	timbits g[enerate] [timbit]
	timbits s[erver] [filename]
	timbits t[est]
	
### Running timbits

There are a number of ways to run timbits, but the easiest approach during development is to utilize the timbits server command.  Doing so will by default run the server.js file, although an alternate filename (server.coffee) can be given.  The timbits server command has the added benefits of loading up any environment variables from an optional .env file, as well as automatically restarting the server if any files change.

### Server Configuration

The server object can be configured during initialization as needed.  The following is a list of possible configuration parameters and their [default value]

* appName - Friendly name of the timbits application ['Timbits']
* engine - Default view engine ['hjs']
* base - A base path for nested servers.  e.g. '/my/nested/server' ['']
* port - The server port to listen on if PORT or C9_PORT env labels are not present. [5678]
* home - The physical path to the root project folder [process.cwd()]
* maxAge - The default cache length in seconds [60]
* discovery - Enables you to serve out your library definition via /timbits/json [true]
* help - Enables the automated help pages via /timbits/help and /[name]/help [true]
* test - Enables the automated test pages via /timbits/test and /[name]/test
* json - Enables the built in json view for timbits via /[name]/json [true]
* jsonp - Enables jsonp requests to json resources

The following example shows how to run a nested application using the [coffeecup](https://github.com/gradus/coffeecup) view engine in place of Hogan and disables the automated test routes.

	var timbits = require('timbits');
	var server = timbits.serve({appName: 'My Nested Timbits', engine: 'coffee', base: '/nested/app', test: false});
	server.engine('coffee', require('coffeecup').__express);
	console.log("Press Ctrl+C to Exit");

### Parameter declaration and validation

For each timbit, you can define a list of parameters which are automatically validated during execution.  This also powers the automated help, test, and discovery functions (see further below).  Parameter attributes you can manipulate are:

* alias - an alternate name for the parameter
* description
* type - data type expected, one of String (default), Number, Boolean, or Date
* default - default value to use if value not specified
* multiple - true/false (defaults to false), indicates whether multiple values are allowed
* required - true/false (defaults to false), indicates whether this is a required parameter
* values - an array of possible values
* strict - true/false (defaults to false), indicates whether the value must be one of the defined possible values 

Example (from plain)

	timbit.params = {
		who: {description: 'Name of person to greet', alias: 'name', default: 'Anonymous', multiple: false, required: false, strict: false, values: ['Ed', 'World']}
		year: {description: 'To test multi parameters and drive Kevin crazy', type: 'Number', values: [1999, 2011]}
	}

### Dynamic Help

Along with the list of parameters, one can also augment a timbit definition with a description (timbit.about), and a list of valid examples (timbit.examples).

Example (from plain)

	timbit.params = {
	  who: {
	    description: 'Name of person to greet',
	    "default": 'Anonymous',
	    multiple: false,
	    required: false,
	    strict: false,
	    values: ['Ed', 'World']
	  },
	  retro: {
	    description: 'To test multi parameters and drive Kevin crazy',
	    type: 'Boolean'
	  }
	};

Together these all help power the automated, dynamic help page for each timbit, which can be found using the hardcoded 'help' view.  e.g. /plain/help

There is also a built in help index that for any timbits project located at /timbits/help

### Dynamic Testing

The examples, and params used to power the help pages are also used to power the automated test pages.  Each timbit has a 'test' view which will utilize this information to define, and execute some basic testing of the timbit.  e.g. /plain/test

There is also a master test page located at /timbits/test which will execute tests for all timbits

Although not overly sophisticated, it will ensure your definitions, examples, and views are valid and compile properly.  It is also useful for remote monitoring of production systems.

Additional functional testing can, and should be implemented via a testing library, such as [mocha](https://mochajs.org/)

By default, only a limited number of tests are executed, but you can run through a much larger set of tests by appending /all to the test path.  This will generate a much more thorough list of test urls using every possible combination of required parameters, and their sample values, along with each possible sample value for optional parameters.

e.g. /mytimbit/test/all (run through all tests for mytimbit)

e.g. /timbits/test/all (run through all tests for all timbits)

Note that you can provide your own list of test urls in place of the automated ones by simple overriding the generateTests() method for a given timbit, and returning a simply array of virtual paths

Example:

	timbit.generateTests = function(alltests){
		var tests = [
			'/mytimbit/myview?name=bob',
			'/mytimbit/altview?name=sue'
		];
		
		if (alltests)
			tests.push(
				'/mytimbit/myview?name=bob&age=39',
				'/mytimbit/myview?name=sue&gender=F'
			);
			
		return tests;
	};

If you use the test cases provided by the timbit new project template, you can also run through these same tests (and any others you may want to add) from a terminal via the test command

	timbits test
	
Running the test command will invoke the mocha test framework.  The command will also load up any environment variables found in the optional .env file before starting the server, and running the tests.

Just as with running tests via the browser, you can indicate you want to run through all the available tests via the --all flag.  In addition, you can pass a number of options to mocha (run timbits help to see the full list).  For example, to watch for file changes, and retest use the --watch flag.

Example:

	timbits test --all --watch
	
Or (if you want to minimize typing)

	timbits t -aw

### Default view

By default, the name of the default view is, well, default!  You do have the ability to specify something more descriptive if you so desire.  Simply set the defaultView property to whatever view name you'd like to use

	// the name default is so booooring.  use my fancy view by default instead
	timbit.defaultView = 'fancy';
	
### Sharing of views

If you have two, or more timbits for which you would like to share views, simply set the viewBase property on the timbit to the name of the timbit who's views you'd like to utilize (see the Dutchie timbit as an example)

	// this timbit should use the views from the chocolate timbit
	timbit.viewBase = 'chocolate';

### Downstream Caching

There is a maxAge property that can set the number of seconds client can/should cache the response for.  If not set, the default value will come from the Timbits configuration, which if not set, is currently 60 seconds by default.  You can also override this value on a request by request basis by setting the context.maxAge value to whatever is appropriate.

	// timbit should be cached for 5 minutes
	timbit.maxAge = 300;
	
The maxAge value will be included in two response headers, the standard Cache-Control header as well as a special Edge-Control header (used by Akamai)

### Built in JSON view

If you're interested in rendering the data elsewhere (for example client side), or you simply want to see what's available to you in the current context for development, and debugging purposes, Timbits includes a built in view named "json" that will render the context object as 'application/json'.   e.g.  /dutchie/json

### Dynamic View Helpers

As of v0.7.0, support for dynamic view helpers has been dropped.

If you need/want to run your previous timbit project on 0.7 or above, please see the [change notes](https://github.com/postmedia/timbits#changes) from above. Details are provided on how to manually require helpers.

### Advanced caching via pantry

As of [Pantry](https://github.com/Postmedia/pantry) v0.3.0, you are now able to configure alternate storage caches. As of Timbits v0.5.0 one can now control the pantry configuration properties as well as substitute the default MemoryStorage caching via the exported timbits.pantry property.

	var timbits = require('../src/timbits')
		,RedisStorage = require('pantry/lib/pantry-redis');

	timbits.pantry.storage = new RedisStorage(null, null, null, 'DEBUG');
	timbits.pantry.configure({
	  verbosity: 'DEBUG'
	});

	var server = timbits.serve({
	  home: __dirname
	});

### Client Side Rendering

Not everyone will be able to utilize an ESI processor in front of their site, or more likely on their development workstation, so we've added a quick and easy way to pull in timbits client side.  Timbits supports an optional callback parameter which will package the rendered view as a simple JSONP package. 

Example:

	/chocolate?q=winning&callback=done

Included with Timbits is a simple client-side JS library (/javascript/timbits.csi.js) which utilizes jQuery to post-process an HTML page for tags containing the data-csi attribute, automatically tacking on the callback parameter when needed, and pulling in the results client side.  We've compiled a minimized version as well (/javascript/timbits.csi.min.js)

Example:

	<div data-csi="http://mytimbitserver.fake/plain/?who=world"></div>
	<div data-csi="navigation.html"></div>

By default, the CSI library runs in "replace" mode, i.e. the returned html replaces any content within the parent element, but you can control that by setting the data-mode attribute to either "prepend", or "append"

	<div data-csi="http://mytimbitserver.fake/plain/?who=world">
		<p>This will be replaced by the results of the include<p>
	</div>
	<div data-csi="http://mytimbitserver.fake/plain/?who=world" data-mode="prepend">
		<p>This will appear below the results of the include<p>
	</div>
	<div data-csi="http://mytimbitserver.fake/plain/?who=world" data-mode="append">
		<p>This HTML will appear above the results of the include<p>
	</div>
	
We've also added support for the dynamic insertion of query string values into your client side includes via the {#name} syntax.  For example, the following will grab the query string parameter 'term' from the host page and insert it into the source url prior to making the request.

	<section id="results" class="tweets" data-csi="http://mytimbitserver.fake/chocolate/?q={#term}"></section>
	
### Responsive Rendering

In an effort to assist with minimizing page sizes (for mobile clients specifically) we've introduced a 'load' event as well as media queries within our timbits.csi.js library.

To run some javascript once a timbit has been loaded, simply bind to the element's load event like this:

	<script>
		$('#mycsi').bind('load', function() {
			alert('Run After Load Works!');
		});
	</script>
	
To implement media queries, add a data-media attribute to the element like this:

	<footer data-csi="http://mytimbitserver.fake/plain/?who=world" data-media="screen and (min-width: 500px)"></footer>

If you want to get even fancier, you can load (not show, see below) two different views of the same timbit depending on a specific breakpoint as in this example:

	<div data-csi="http://mytimbitserver.fake/plain/small?who=world" data-media="screen and (max-width: 420px)"></div>
	<div:data-csi="http://mytimbitserver.fake/plain/large?who=world" media="screen and (min-width: 421px)"></div>

Here's another example which shows some of the power behind this.  Say you want to show four blog posts to all users, but an additional six for larger devices.  The following will keep default payload small for smartphones while expanding the available content for tablets and desktops.

	<div data-csi="http://mytimbitserver.fake/posts/list?topic=sports&start=5&max=6" data-media="screen and (min-width: 421px)" data-mode="append">
		<div data-csi="http://mytimbitserver.fake/posts/list?topic=sports&max=4"></div>
	</div>

Any valid media query will do.  In fact, we also will respond to media query changes (including orientation!) so that as you resize the browser, any csi elements that were skipped due to unmet media queries will load once the media query is valid.

A couple caveats you should be aware of.  First, we will load csi includes based on the media query, but we won't unload them.  Secondly, since we depend on the window.matchMedia() method, this doesn't work across all browsers.  Specifically Opera, and IE9 or below.  On these browsers, timbits csi will ignore the media queries and load each and every include.  So you should still use CSS media queries to show/hide elements as if all the content was loaded.

### Wordpress Plugin

For those of you who would like to utilize Timbits within your Wordpress environment, we've created a plugin for that called [wp-timbits](https://github.com/Postmedia/wp-timbits) which provides shortcode and widget support, supports Timbits' auto-discovery feature, includes the csi rendering library (with media query support) and has the ability to turn your Wordpress instance into a Timbits server.

## Road Map

We have a number of items in the pipeline which we believe will provide a lot of power to this platform, such as:

* Integrated benchmarks
* Real-time data updates via Socket.IO


## Created by

* Edward de Groot
* Keith Benedict
* Donnie Marges
* Stephen Veerman
* Kevin Gamble
