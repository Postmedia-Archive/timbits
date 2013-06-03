// Timbit

// load the timbits module
var timbits = require('timbits');

//create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// additional timbit implementation code follows...

timbit.about = 'a description about this timbit';

timbit.examples = [
  {
    href: '/timbit/?q=winning',
    caption: 'Default View'
  }, {
    href: '/timbit/alternate?q=winning',
    caption: 'Alternate View'
  }
];

timbit.params = {
  q: {
    description: 'Keyword to search for',
    required: true,
    strict: false,
    values: ['Coffee', 'Timbits']
  }
};

timbit.eat = function(req, res, context) {
  var = {
    uri: 'http://search.twitter.com/search.json?q=' + context.q
  };
  timbit.fetch(req, res, context, src);
};