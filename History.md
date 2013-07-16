0.7.1 / 2013-07-16
==================
  * Dependency update to allow pantry v0.5.x
  * Now uses Wordpress API instead of Twitter for examples

0.7.0 / 2013-06-05
==================
  * 0.7.x series should be considered unstable.  stable version will be released as 0.8.x
  * major rewrite of Timbits in JavaScript (formally CoffeeScript)
  * generates JavaScript files by default (CoffeeScript is optional)
  * default view engine is now Hogan (formally CoffeeKup)
  * dynamic helpers are no longer supported
  * sessions are not longer enabled by default
  * now uses Winston for logging (formally coloured-log)
  * updated documentation to reflect changes

0.6.7 / 2012-11-28
==================
  * added trim function when processing environment key/value pairs, fixes issue on Windows when multiple environment variables are concatenated in same string.

0.6.6 / 2012-11-08
==================
  * renamed csi libraries to match best practices (dot instead of dash)

0.6.5 / 2012-10-23
==================
  * client rendering library revised.  no longer uses namespaced includes

0.6.4 / 2012-10-23
==================

  * Add support for responsive client side includes via media attribute
  * Modified production flags to return 404 when feature has been disabled

0.6.3 / 2012-10-22
==================

  * Supports new configuration options which allow you to disable automated discovery, help, tests, and json views.
  * no longer uses our own custom jsonp-filter package

0.6.2 / 2012-10-22
==================

  * Rewrite of timbits command line in js
  * No longer requires coffee-script, mocha or runjs packages to be installed globally
  * for projects created via "timbits new", generated package.json will lock down the timbits dependency to the version used to create the project.  To upgrade to a newer version of timbits, you'll need to adjust the dependency first
  * Added support for numerous mocha options to "timbits test" command

0.6.1 / 2012-10-16
==================

  * Updated read me to reflect global dependencies for command line use of timbits
  * Modified spawn of child process to use the node-which lib for proper PATHEXTS of executables on Windows and Linux

0.6.0 / 2012-10-05
==================

  * Updated dependencies to latest libraries
  * Now requires node v0.8.x
  * timbits are now loaded before server is started (instead of async)
  * Switch to mocha for testing (was using vows)
  * Completely revised automated testing with option for more extensive tests
  * Added test option to timbits command line
  * timbits s[erver] and t[est] will now load environment variables from a .env file if present

0.5.14 / 2012-10-05
===================
  * Removed connect -esi, -assets, -less as requirements (but you can still add them to your project manually if needed)

0.5.13 / 2012-10-05
===================

  * Lock down dependency versions prior to v0.6.x

0.5.12 / 2012-06-28
===================

  * Added alias name support to timbit parameters

0.5.10 / 2012-06-07
===================

  * Added error handling to fetch helper method

0.5.9 / 2012-05-28
==================

  * Better handling of errors when eating or rendering
  * Removed auto-capitalization css from help views

0.5.8 / 2012-05-24
==================

  * Corrected method of returning remove render JSON

0.5.7 / 2012-05-23
==================

  * Added support for onload event to client side esi/csi processing
  * Allow for $(QUERY\_STRING{'name'}) syntax in client side esi/csi processing

0.5.6 / 2012-05-22
==================

  * Added ability to access to pantry directly from within a Timbit

0.5.5 / 2012-05-18
==================

  * Added the ability render timbits client side via JSONP and callback parameter
  * Removed the automatic insert of pantry URIs into context due to security concerns

0.5.4 / 2012-04-25
==================

  * Added the ability to specify the name of the default view via .defaultView property

0.5.3 / 2012-04-16
==================

  * Fixed bug with minimum node version for previous changes that require node 0.6.1 or higher
  * Added limitation to express version installed < 3.0 as this is in alpha and breaks timbits 

0.5.2 / 2012-04-12
==================

  * Fixed bug with making directories in bin/timbits

0.5.1 / 2012-04-12
==================

  * Changes to bin/timbits for CoffeScript v.1.3.x support

0.5.0 / 2012-03-21
==================

  * Unstable experimental release (uses unstable pantry v0.3.x)
  * Exposes pantry for additional configuration and use of optional storage engines

0.4.2 / 2012-03-21
==================

  * Updated package to prevent use of pantry > 0.3.0

0.4.1 / 2012-02-21
==================

  * Added support for new config.base parameter to allow nested timbit servers
  * timbits command line updated to use OS agnostic copy
  * npm init and install removed from command line (doesn't work on windows)

0.4.0 / 2012-02-02
==================

  * Removed client side rendering (for now)
  * Switched out kitkat for vows
  * Supports alternate view engines
  * No error if helpers aren't defined (missing folder)

0.3.3 / 2011-11-23
==================

  * ignore empty parameter values

0.3.2 / 2011-11-18
==================

  * added support for server-side less compilation

0.3.1 / 2011-11-10
==================

  * added support for json directory of available timbits
  * Timbit fetch method will store pantry result in array if context contains existing entry
  * Timbit fetch method will store the requested uri in context\[name_uri\] (or array if context contains existing entry)
  * added initial support for express sessions
  * routing now works for both get and post methods

0.3.0 / 2011-10-17
==================

  * initial support for dynamic helpers

0.2.0 / 2011-10-17
==================

  * official stable release of v0.2

0.2.0beta5 / 2011-10-04
=======================

  * complete rewrite of client side rendering

0.2.0beta4 / 2011-09-15
=======================

  * upgraded pantry to v0.2.0beta2
  * changed view_base to viewBase
  * added parameter data type validation
  * added downstream caching headers via maxAge
  * npm init is now run after new project has been generated
  * parameters are converted to lower case to ensure they are not case sensitive
  * fixed bug with conflicting path variable
  * added append to body if no timbit_id is provided when rendering client side

0.2.0beta3 / 2011-09-14
=======================

  * upgraded pantry to v0.2.0beta
  * fixed issue with test page host name. Closes #8

0.2.0beta2 / 2011-09-13
=======================

  * new projects now depend on installed version of timbits
  * package.json for new projects now include project name
  * support for timbits -v parameter
  * added Timbit.log for logging/debug support
  * new projects now support continuos testing via kitkat

0.2.0beta / 2011-09-09
======================

  * working towards a stable production 0.2.0 release

0.1.3 / 2011-09-09
==================

  * command line for new projects and code generation
  * dynamic test pages
  * upgraded view engine to CoffeeKup 0.3.0
  * easier sharing of views between timbits via Timbit.view_base
  * revised fetch method by removing 'key' parameter
  * support for Timbits created in JavaScript

0.1.2 / 2011-08-25
==================

  * dynamic help has been styled
  * support for client side rendering
  * initial support for automated testing
  * better logging

0.1.1 / 2011-08-23
==================

  * request and response separated from context (to support optional client side rendering in a later release)
  * parameter validation
  * dynamic help pages
  * customized routes are no longer supported
  * examples updated to reflect changes

0.1.0 / 2011-08-22
==================

  * Official 0.1 release

0.0.7 / 2011-08-18
==================

  * Needed to revert to CoffeeKup 0.2.3 in order to support deploying to node < 0.4.7

0.0.6 / 2011-08-15
==================

  * Extracted Story, List, and Syndication examples to separate project (timbits-example)
  * Utilizes kitkat for testing
  * Added test cases
  * Utilizes env for port number if available
  * Application options object replaces parameters
  * Feature rich HTML5 story template in examples
  * Added List and Syndication widgets to examples
  * Incorporated connect-esi packaged

0.0.5 / 2011-08-04
==================

  * Now uses Pantry for JSON/XML data retrieval
  * Upgraded to Express 2.4.3 and CoffeeKup 0.3.0beta
  * Examples updated to account for the above changes

0.0.4 / 2011-07-14
==================

  * Updated package.json and published the package

0.0.3 / 2011-07-14
==================

  * Fix some typos
  * Started documentation
  * Implement default help.coffee file

0.0.2 / 2011-07-13
==================

  * Created sample timbits of varying complexity
  * Major refactoring as we develop our examples
  * Reworked areas towards convention over configuration
  * Uses the CoffeeKup view engine by default
  * Created Story timbit to be used as a real world prototype
	
0.0.1 / 2011-07-05
==================

  * Initial release

