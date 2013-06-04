//process.env.TIMBITS_VERBOSITY = 'debug';
//process.env.PANTRY_VERBOSITY = 'debug';

var timbits = require('../lib/timbits');
var server = timbits.serve({
  home: __dirname
});