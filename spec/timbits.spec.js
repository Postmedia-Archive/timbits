(function() {
  var assert, homeFolder, path, server, timbits;
  timbits = require('timbits');
  assert = require('assert');
  path = require('path');
  homeFolder = path.join("" + (process.cwd()), "examples");
  server = timbits.serve({
    home: homeFolder,
    port: 8785
  });
  module.exports = {
    "test that the express server object returned is functioning": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/",
        method: "GET"
      }, {
        status: 200,
        headers: {
          "Content-Type": "text/html; charset=utf-8"
        }
      }, function(res) {
        ++calls;
        return assert.ok(res, "Expected a response, perhaps something is wrong our status was: " + res.status);
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the plain timbit request, this is the simpliest request we could try": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/plain",
        method: "GET"
      }, {
        body: "<h1>Hello Anonymous</h1>",
        status: 200,
        headers: {
          "Content-Type": "text/html; charset=utf-8"
        }
      }, function(res) {
        ++calls;
        return assert.ok(res, "Expected a response, perhaps something is wrong our status was: " + res.status + " and the response object has: " + res);
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the plain timbit request with the addition of a querystring": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/plain?who=cthulhu"
      }, {
        body: /cthulhu/
      }, function(res) {
        return ++calls;
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the cherry timbit, specifically we are vetting that the eat callback is working allowing us to customize the context rendered": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/cherry"
      }, {
        body: /The current server date\/time is/,
        status: 200
      }, function(res) {
        return ++calls;
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the chocolate timbit which allows us to use alternate views if they exist, this is a test of the 'alternate' view which does exist": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/chocolate/alternate?q=coffeescript"
      }, {
        body: /coffeescript/,
        status: 200
      }, function(res) {
        return ++calls;
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the choclate timbit using an alternate view that does not exist": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/chocolate/badrequest?q=coffeescript"
      }, {
        body: /Error/,
        status: 500
      }, function(res) {
        return ++calls;
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the dutchie timbit which implements the fetch callback to re-route calls here to the chocolate timbit with views": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/dutchie/nodejs/alternate"
      }, {
        body: /Alternate dutchie Timbit View/,
        status: 200
      }, function(res) {
        return ++calls;
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    },
    "test the dutchie timbit with an invalid path in the request": function(beforeExit) {
      var calls;
      calls = 0;
      assert.response(server, {
        url: "/dutchie/another/nodejs/alternate"
      }, {
        status: 404
      }, function(res) {
        return ++calls;
      });
      return beforeExit(function() {
        return assert.equal(1, calls);
      });
    }
  };
}).call(this);
