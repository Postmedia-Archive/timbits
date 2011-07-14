# Timbits
Widget framework based on Express and CoffeeScript

## Introduction

Timbits is an attempt to build an easy and reusable widget framework on top of Express.  These widgets are meant to render independent HTML snippets based on REST based JSON/XML data sources and brought together on a page via ESI (Edge Side Includes)

It's primarily meant to serve internal purposes as Postmedia Network Inc, however it is being open sourced under the MIT License.  Others may find some use for what we are doing, and still others may be able to help turn this into a more generic and useful solution by contributing and/or correcting our ignorant ways.

Be kind.  We're coming from years of .NET experience and some Ruby on Rails.  This is our first foray into Node.js development and we're still figuring things out.  Constructive criticism is encouraged.  If you see something odd and think to yourself "WTF?" then by all means, let us know.  We are eager and willing to learn.

## Installing

Just grab [node.js](http://nodejs.org/#download) and [npm](http://github.com/isaacs/npm) and you're set:

	npm install timbits
	
Timbits is simplistic and finds most of it's power by running on top of some very cool node libraries such as [express](http://expressjs.com/), [CoffeeScript](http://coffeescript.org) and [CoffeeKup](http://coffeekup.org/).  As such don't forget to install dependencies.

	npm install -d

## Using

Yea, we're not even close to having useful documentation yet.  Stay tuned.  In the mean time, review the example.

The structure of a timbits application is fairly simple.  To start, you need a two lines in your main app.coffee file.  (If you really hate typing, this could easily be converted to one, but far less flexible)

	timbits = require 'timbits'
	timbits.serve()

Also ensure (at least for now, due to lack of error handling) that you create the following subfolders:

* /public - images, javascript, stylesheets etc.
* /timbits - this is where we place the individual timbit (widget) files
* /views - views for a particular timbit are placed in a subfolder of the same name

When you start the server, it will automatically load all the timbits loaded in the /timbits folder.  The name of the timbit is determined by the name of the file, and that name in term determines the default route (/name/:view?) and the default view (/views/name/default.coffee).  Aside from the location and name of the timbits, the rest is customizable as shown in the examples.

The simplest of timbits takes the following form:

	timbits = require 'timbits'
	timbit = module.exports = new timbits.Timbit()

That's it.  If you created this as /timbits/test.coffee and placed a default view at /views/test/default.coffee, you could "eat" this timbit by going to /test in a browser.  See the "plain" timbit for an example of this.

## Outstanding Issues

Way too much at this time.  On the short list (and mostly in progress):

* Integrated testing framework
* Integrated benchmarks
* Command line server with ability to automatically restart
* Command line code generator to scaffold a new project or timbit
* Security considerations
* Error handling of any sort
* Refactor and expand data retrieval, including caching, conditional GETs, XML support
* Support for alternate server configurations
* More/Better examples
* Documentation, Documentation, Documentation

## Created by

* Edward de Groot
* Keith Benedict
* Stephen Veerman