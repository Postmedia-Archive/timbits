// Dutchie Timbit

// load the timbits module
var timbits = require('../../lib/timbits');

// create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// additional timbit implementation code follows...
timbit.about = '\
    Example of a timbit which re-uses another timbits views\
    This timbit will query Wordpress API and display the results\
    This timbit re-uses the views from the chocolate timbit\
    ';

timbit.examples = [
  {
    href: '/dutchie/?site=news.nationalpost.com',
    caption: 'Latest news from The National Post'
  }, {
    href: '/dutchie/alternate-view?site=news.nationalpost.com&tag=Apple&number=5',
    caption: 'Latest five news posts on Apple from The National Post'
  }
];

timbit.params = {
  site: {
    description: 'The Wordpress site to query',
    required: true,
    strict: false,
    values: ['news.nationalpost.com', 'o.canada.com']
  },
  tag: {
    description: 'Tag to filter by',
    required: false,
    strict: false,
    values: ['Apple', 'Canada']
  },
  "number": {
    description: 'The number of posts to display',
    alias: 'rpp',
    "default": 10,
    strict: false,
    values: [3, 5, 10]
  }
};

// let's just re-use the chocolate timbit views and use additional cache time
timbit.viewBase = 'chocolate';
timbit.maxAge = 300;

timbit.eat = function(req, res, context) {
  
  // specify the data source
  var src = {
    uri: "http://public-api.wordpress.com/rest/v1/sites/" + context.site + "/posts?number=" + context.number
  };

  if (context.tag) {
    src.uri += "&tag=" + context.tag;
  }
  
  // instead of using the fetch helper method, let's show how to use pantry directly
  timbits.pantry.fetch(src, function(error, results) {
    context.wordpress = results;
    timbit.render(req, res, context);
  });
};