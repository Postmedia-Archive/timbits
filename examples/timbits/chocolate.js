// Chocolate Timbit

// load the timbits module
var timbits = require('../../lib/timbits');

// create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// additional timbit implementation code follows...
timbit.about = '\
	Example of a timbit which transforms remote data.\
	This timbit will query twitter and display the results\
	There are two views available, the default and the alternate\
	';

timbit.examples = [
  {
    href: '/chocolate/?q=winning',
    caption: 'Winning - Default View'
  }, {
    href: '/chocolate/alternate-view?q=winning&rpp=20',
    caption: 'Winning - Alternate View'
  }
];

timbit.params = {
  q: {
    description: 'Keyword to search for',
    required: true,
    strict: false,
    values: ['Coffee', 'Timbits']
  },
  rpp: {
    description: 'Maximum number of tweets to display',
    alias: 'max',
    type: 'Number',
    "default": 10,
    values: [1, 8, 16]
  }
};

timbit.eat = function(req, res, context) {
  
  // specify the data source
  var src = {
    name: 'tweets',
    uri: "http://search.twitter.com/search.json?q=" + context.q + "&rpp=" + context.rpp
  };
  
  // use the helper method to fetch the data
  // timbit.fetch will call timbit.render once we have the data
  timbit.fetch(req, res, context, src);
};