// reduce logging levels to provide clean test feedback
process.env.TIMBITS_VERBOSITY = 'critical';
process.env.PANTRY_VERBOSITY = 'critical';

// load modules
var timbits = require('../lib/timbits')
  , should = require('should')
  , path = require('path')
  , request = require('request')
  
// load hhtp extensions for should 
require('should-http');

// set testing environment
var port = 8785
  , alltests = process.env.TIMBITS_TEST_WHICH === 'all';

// create test server
var server = timbits.serve({
  home: process.cwd(),
  port: port,
  verbosity: 'critical'
});


// helper function for testing requests
function validateRequest(method, vpath, expect) {
  expect = expect || 'html';
  
  describe(vpath, function() {
    var test_msg = "should respond with " + expect + " and status 200";
    if (typeof expect !== 'string')
      test_msg = "should respond with status " + expect;
    
    it(test_msg, function(done) {
      if (method=="GET") {
        request("http://localhost:" + port + vpath, function(err, res) {
          should.not.exist(err);
          if (typeof expect === 'string') {
            res.should.have.status(200);
            if (expect === 'json')
              res.should.be.json;
            else
              res.should.be.html;
          } else {
            res.should.have.status(expect);
          }
          done();
        });
      }
      else if (method=="POST") {
        request.post("http://localhost:" + port + vpath, function(err, res) {
          should.not.exist(err);
          if (typeof expect === 'string') {
            res.should.have.status(200);
            if (expect === 'json')
              res.should.be.json;
            else
             res.should.be.html;
          } else {
            res.should.have.status(expect);
          }
          done();
        });
      }
    });
  });
};


describe('timbits', function() {
  describe('automated test cases', function() {
    for (name in timbits.box) {
      
      timbit = timbits.box[name];
      
      // GET requests
      if (timbit.examples != null && timbit.methods['GET']) {
        describe('specified examples for ' + name, function() {
          timbit.examples.forEach(function(example) {
            validateRequest('GET', example.href);
          });
        });
      }
      // Post Requests
      if (timbit.examples != null && timbit.methods['POST']) {
        describe('specified examples for ' + name, function() {
          timbit.examples.forEach(function(example) {
            validateRequest('POST', example.href);
          });
        });
      }
      
      var dynatests = timbit.generateTests(alltests);
      if (dynatests.length) {
        describe("dynamic tests for " + name, function() {
          dynatests.forEach(function(href) {
            if (timbit.methods['GET'])
              validateRequest('GET', href);
            if (timbit.methods['POST'])
              validateRequest('POST', href);
          });
        });
      }
    }
  });
});