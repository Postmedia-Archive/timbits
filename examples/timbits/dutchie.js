// Dutchie Timbit

// load the timbits module
var timbits = require('../../lib/timbits');

// create and export the timbit
var timbit = module.exports = new timbits.Timbit();

// let's just re-use the chocolate timbit views and use additional cache time
timbit.viewBase = 'chocolate';
timbit.maxAge = 300;

timbit.eat = function(req, res, context) {
  
  // specify the data source
  var src = {
    uri: "http://search.twitter.com/search.json?q=" + context.q
  };
  
  // instead of using the fetch helper method, let's show how to use pantry directly
  timbits.pantry.fetch(src, function(error, results) {
    context.tweets = results;
    timbit.render(req, res, context);
  });
};