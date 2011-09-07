var timbits = require('timbits');
var server = timbits.serve({
	port: process.env.PORT || process.env.C9_PORT || 5678
});
console.log("Press Ctrl+C to Exit");