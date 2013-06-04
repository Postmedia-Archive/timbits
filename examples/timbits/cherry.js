// Cherry Timbit

// load the timbits module
var timbits = require('../../lib/timbits');

// create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// additional timbit implementation code follows...
timbit.about = '\
	Example of a timbit which actually does something.\
	This timbit will display the current server time.\
	';

timbit.examples = [
  {
    href: '/cherry/',
    caption: 'Current Time'
  }
];

timbit.eat = function(req, res, context) {
  context.now = new Date();
  return this.render(req, res, context);
};