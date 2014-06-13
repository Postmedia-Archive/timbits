// Chocolate Timbit

// load the timbits module
var timbits = require('../../lib/timbits');

// create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// additional timbit implementation code follows...
timbit.about = '\
	Example of a timbit which transforms remote data.\
	This timbit will query Wordpress API and display the results\
	There are two views available, the default and the alternate\
	';

timbit.examples = [
  {
    href: '/chocolate/?site=sports.nationalpost.com',
    caption: 'Latest Sports news from The National Post'
  }, {
    href: '/chocolate/alternate-view?site=sports.nationalpost.com&tag=Hockey&number=5',
    caption: 'Latest five posts on Hockey from The National Post'
  }
];

timbit.params = {
  site: {
    description: 'The Wordpress site to query',
    required: true,
    strict: false,
    values: ['sports.nationalpost.com', 'o.canada.com']
  },
  tag: {
    description: 'Tag to filter by',
    required: false,
    strict: false,
    values: ['Hockey', 'Detroit']
  },
  "number": {
    description: 'The number of posts to display',
    alias: 'rpp',
    "default": 10,
    strict: false,
    values: [3, 5, 10]
  }
};

timbit.eat = function(req, res, context) {
  
  // specify the data source
  var src = {
    name: 'wordpress',
    uri: "http://public-api.wordpress.com/rest/v1/sites/" + context.site + "/posts?number=" + context.number
  };
  
  if (context.tag) {
    src.uri += "&tag=" + context.tag;
  }
  
  // use the helper method to fetch the data
  // timbit.fetch will call timbit.render once we have the data
  timbit.fetch(req, res, context, src);
};