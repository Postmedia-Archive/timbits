0.0.1 / 2011-07-05
==================

  * Initial release

0.0.2 / 2011-07-13
==================

  * Created sample timbits of varying complexity
  * Major refactoring as we develop our examples
  * Reworked areas towards convention over configuration
  * Uses the CoffeeKup view engine by default
  * Created Story timbit to be used as a real world prototype

0.0.3 / 2011-07-14
==================

  * Fix some typos
  * Started documentation
  * Implement default help.coffee file

0.0.4 / 2011-07-14
==================

  * Updated package.json and published the package

0.0.5 / 2011-08-04
==================

  * Now uses Pantry for JSON/XML data retrieval
  * Upgraded to Express 2.4.3 and CoffeeKup 0.3.0beta
  * Examples updated to account for the above changes

0.0.6 / 2011-08-12
==================

  * Utilizes kitkat for testing
	* Added test cases
  * Utilizes env for port number if available
  * Application options object replaces parameters
  * Feature rich HTML5 story template in examples
  * Added List and Syndication widgets to examples
  * Incorporated connect-esi packaged

0.0.6 / 2011-08-15
==================

  * Extracted Story, List, and Syndication examples to separate project (timbits-example)

0.0.6 / 2011-08-16
==================

  * Updated test cases, added the fixtures folder to run tests against timbits within spec and not the examples folder of the project.  
  * removed the automatic use of process.env.Port  if it exists and set it to whatever is configured, this was the wrong spot.
	correct spot is in the call to timbits.serve the user can pass the port (be it process.env.Port or some other number/var).
