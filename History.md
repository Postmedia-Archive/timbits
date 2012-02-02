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































