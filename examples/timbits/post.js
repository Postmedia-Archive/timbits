// Timbit

// load the timbits module
var timbits = require('../../lib/timbits');

//create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// additional timbit implementation code follows...

timbit.about = 'An example timbit that handles just the post event';

// Set allowed methods, by default only GET is ever allowed
timbit.methods = { 'GET': false, 'POST': true };

timbit.examples = [
  {
    href: '/post',
    caption: 'Default View'
  }
];


timbit.eat = function(req, res, context) {
	var body = '';
	req.on( 'data', function( data ) {
		body += data;
	} );
	
	req.on( 'end', function () {
		context.body = body;
		timbit.render( req, res, context )
	});
};