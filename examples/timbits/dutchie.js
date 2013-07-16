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