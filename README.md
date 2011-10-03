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

## Additional Features

### Command Line

Create a new project, generate a timbit (and default view), or run the project with runjs

	timbits n[ew] [project]
	timbits g[enerate] [timbit]
	timbits s[erver]
	
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

Additional functional testing can and should be implemented via a testing library, such as our very own [kitkat](https://github.com/Postmedia/kitkat)

### Client Side Rendering

Although Timbits was originally developed with the intent of serving out widgets via ESI (or other mechanisms of server to server requests) we now have built in support for client side rendering.  Simply pass a remote=true parameter and the timbit will render JavaScript which provides the data context, requests the view, and renders on the client.

Ensure that the following javascript libraries have been loaded in the browser first:
- jQuery (http://ajax.googleapis.com/ajax/libs/jquery/1.6/jquery.min.js)
- CoffeeScript (http://jashkenas.github.com/coffee-script/extras/coffee-script.js)
- CoffeeKup (https://github.com/mauricemach/coffeekup)

Below is an example of rendering the plain timbit on the client. If you are rendering multiple timbits on a single page, the id (in this case esi_0) must be unique for each timbit request.

	<div id="esi_0"></div>
	<script>
		$.getScript("/plain/?who=World&esi_id=esi_0&remote=true");
	</script>

In this case, the result of the '/plain/?who=World&esi_id=esi_0&remote=true' getScript call will be similar to the following:

	context_esi_0 = {"who":"World","esi_id":"esi_0","remote":"true","name":"plain","view":"plain/default","maxAge":60};
	var views = views || {};
	if (views['plain/default'] || false) {
		render = CoffeeKup.render(views['plain/default'], context_esi_0);
		$('#esi_0').html(render);
	}
	else {
		$.ajax({
			url: "http://localhost:5678/plain/default.coffee?json=true&callback=?",
			dataType: "jsonp",
			cache: true,
			jsonpCallback: "plain_default",
			success: function(data, textStatus, jqXHR){
				views['plain/default'] = data; //save view for reuse
				render = CoffeeKup.render(views['plain/default'], context_esi_0);
				$('#esi_0').html(render);
			}
		});
	}
	
When run, this script will check if the current view requested has been stored. If the view has been stored, coffeekup will render the view along with the context. If the view has not been stored, it will send an ajax request for the view. On ajax callback, the view will be stored and then rendered along with the context.

Alternatively to the above method, the parse-esi.js script (from the connect-esi project) will search for esi/csi tags on a page and then automatically append the required &esi_id=esi_id&remote=true parameters. For a more detailed example of this method of remote rendering, please see public/tests in the 'timbits-example' project. The 'timbits-example' project makes use of PMScriptManager which simplifies the process of rendering remotely by using javascript packages which contain all required libraries to display a particular timbit.

### Sharing of views

If you have two or more timbits for which you would like to share views, simply set the viewBase property on the timbit to the name of the timbit who's views you'd like to utilize (see the Dutchie timbit as an example)

	# this timbit should use the views from the chocolate timbit
	timbit.viewBase = 'chocolate'

### Downstream Caching

There is a maxAge property that can set the number of seconds client can/should cache the response for.  If not set, the default value will come from the Timbits configuration, which if not set, is currently 60 seconds by default.  You can also override this value on a request by request basis by setting the context.maxAge value to whatever is appropriate.

	# timbit should be cached for 5 minutes
	timbit.maxAge = 300
	
The maxAge value will be included in two response headers, the standard Cache-Control header as well as a special Edge-Control header (used by Akamai)

## Road Map

We have a number of items in the pipeline which we believe will provide a lot of power to this platform, such as:

* Integrated benchmarks
* Support for alternate view engines
* Real-time data updates via Socket.IO


## Created by

* Edward de Groot
* Keith Benedict
* Stephen Veerman
* Kevin Gamble
