// Plain Timbit

// Load the timbits module
var timbits = require('../../lib/timbits');

// create and export the timbit
var timbit = module.exports = new timbits.Timbit();


// additional timbit implementation code follows...
timbit.about = '\
	Example of the simplest timbit that could possibly be created.\
	This timbit will simply render a view using data from the query string.\
	';

timbit.examples = [
  {
    href: '/plain/',
    caption: 'Anonymous'
  }, {
    href: '/plain/?who=world',
    caption: 'Hello World'
  }, {
    href: '/plain/?who=Kevin&retro=true',
    caption: 'Flashback'
  }
];

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