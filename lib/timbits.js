
// load required modules
var fs = require('fs')
  , path = require('path')
  , querystring = require('querystring')
  , url = require('url')
  , winston = require('winston')
  , express = require('express')
  , hogan = require('hogan.js')
  , request = require('request');

// default configuration
var config = {
  appName: 'Timbits',
  base: '',
  port: 5678,
  home: process.cwd(),
  maxAge: 60,       // default widget output cache time
  engine: 'hjs',    // default view engine
  discovery: true,  // support automatic discovery via /timbits/json
  help: true,       // allow automatic help pages at /timbits/help and /[name]/help
  test: true,       // allow automatic test pages at /timbits/test and /[name]/test
  json: true,       // allow built in json view at /[name]/json
  jsonp: true       // allow jsonp calls via /[name]/json?callback=
};

// retrieve list of matching files in a folder
function filteredFiles(folder, pattern) {
  var files = [];
    
  if (fs.existsSync(folder)){
    fs.readdirSync(folder).forEach(function(file) {
      if (file.match(pattern) != null)
        files.push(file);
    });
  }
  return files;
}

// automagically load timbits found in the ./timbits folder
function loadTimbits(callback) {

  var folder = path.join(config.home, "/timbits");
  var files = filteredFiles(folder, /\.(coffee|js)$/);
  var pending = files.length;
  
  files.forEach(function(file) {
    var name = file.substring(0, file.lastIndexOf("."));
    timbits.add(name, require(path.join(folder, file)), function() {
      pending--;
      if (pending === 0) callback();
    });
  });
}

// automagically load views for a given timbit
function loadViews(timbit) {
  timbit.views = [];
  
  var pattern = new RegExp('\.' + timbits.app.settings['view engine'] + '$')
    , folder = path.join(config.home, 'views', timbit.viewBase);
    
  if (fs.existsSync(folder)) {
   var files = fs.readdirSync(folder);
   files.forEach(function(file) {
     timbit.views.push(file.replace(pattern, ''));
   });
  }
  
  // We will attempt the default view anyway and hope the timbit knows what it is doing.
  if (timbit.views.length === 0) timbit.views.push(timbit.defaultView);
}

// return a list of possible test values
function getTestValues(values, alltests) {
  if (values != null && values.length != null && values.length !== 0) {
    if (alltests)
      return values;
    else
      return values.slice(0, 1);
  } else {
    return [];
  }
}

// compile built in templates
function compileTemplate(name) {
  var filename = path.join(__dirname, "templates", name + '.hjs');
  var contents = fs.readFileSync(filename);
  return hogan.compile(contents.toString());
}

var timbits = this;
this.box = {};
this.pantry = require('pantry');
this.templates = {
  help: compileTemplate('help'),
  timbitHelp: compileTemplate('timbit-help'),
  test: compileTemplate('test'),
};

//added winston object for logging.
this.log = new (winston.Logger)({
  transports: [
    new (winston.transports.Console)()
  ]
});

// creates, configures, and returns a standard express app
this.serve = function(options) {
    
  /* configure options */
  for (var key in options) {
    value = options[key];
    config[key] = value;
  }
  
  /* configure express app */
  var app = timbits.app = express();
   
  app.set('views', "" + config.home + "/views");
  app.set('view engine', config.engine);
  app.set('jsonp callback', config.jsonp);
  
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.static(path.join(config.home, "public")));
  app.use(express.static(path.join(__dirname, "../resources")));
  
  /* TODO: Error Handling
  app.configure('development', function() {
    app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  
  app.configure('production', function() {
    app.use(express.errorHandler());
  });
  
  */
  
  // redirect root to help page
  if (config.help) {
    app.all(config.base + "/", function(req, res) {
      res.redirect(config.base + "/timbits/help");
    });
  }
  
  // route json discovery
  app.get(config.base + "/timbits/json", function(req, res) {
    if (config.discovery) {
      res.json(timbits.box);
    } else {
      res.send(404, "Automatic Discovery has been disabled");
    }
  });
  
  // route help page
  app.get(config.base + "/timbits/help", function(req, res) {
    if (config.help) {
      var context = {title: 'Timbits Help', timbits: []};
      for(var key in timbits.box) {
        context.timbits.push(key);
      }
      res.send(timbits.templates.help.render(context));
    } else {
      res.send(404, "Automatic Help has been disabled");
    }
  });
  
  // route master test page
  app.get(config.base + '/timbits/test/:which?', function(req, res) {
    if (config.test) {
      var alltests = (req.params.which === 'all')
        , all_results = []
        , pending = Object.keys(timbits.box).length;
      
      if (pending) {
        for (name in timbits.box) {
          var timbit = timbits.box[name];
          timbit.test('http://' + req.headers.host, alltests, function(results) {
            results.forEach(function(result) {
              all_results.push(result);
            });
            if (--pending === 0) {
              var passed = 0, failed = 0;
              all_results.forEach(function(result) {
                if (result.passed) passed++; else failed++;
              });
              res.send(timbits.templates.test.render({
                title: 'Testing Summary: all timbits',
                passed: passed,
                failed: failed,
                results: all_results         
              }));              
            }
          });
        }
      } else {
        res.send(ck.render(views.test, {}));
      }
    } else {
      res.send(404, "Automatic Test has been disabled");
    }
  });
  
  // automagically load timbits
  loadTimbits(function() {
    try {
       timbits.server = app.listen(process.env.PORT || process.env.C9_PORT || config.port);
       timbits.log.info("Timbits server listening on port " + timbits.server.address().port + " in " + app.settings.env + " mode");
    } catch (err) {
       timbits.log.error("Server could not start on port " + (process.env.PORT || process.env.C9_PORT || config.port) + ". (" + err + ")");
       console.log("\nPress Ctrl+C to Exit");
       process.exit(1);
    }
  });
  
  return app;  
};

// use the 'add' method to place a timbit in the box
this.add = function(name, timbit, callback) {  
  timbits.log.info("Placing " + name + " in the box");
  timbits.box[name] = timbit;
  
  timbit.name = name;
  if (timbit.viewBase == null) timbit.viewBase = name;
  if (timbit.defaultView == null) timbit.defaultView = 'default';
  if (timbit.maxAge == null) timbit.maxAge = config.maxAge;
  
  loadViews(timbit);
  
  // route timbit help
  timbits.app.get(config.base + "/" + name + "/help", function(req, res) {
    if (config.help)
      res.send(timbits.templates.timbitHelp.render(timbit));
    else
      res.send(404, "Automatic Help has been disabled");
  });
  
  // route timbit testing
  timbits.app.get(config.base + "/" + name + "/test/:which?", function(req, res) {
    var alltests;
    if (config.test) {
      alltests = req.params.which === 'all';
      timbit.test("http://" + req.headers.host, alltests, function(results) {
        var passed = 0, failed = 0;
        results.forEach(function(result) {
          if (result.passed) passed++; else failed++;
        });
        res.send(timbits.templates.test.render({
          title: 'Testing Summary: ' + timbit.name,
          passed: passed,
          failed: failed,
          results: results         
        }));
      });
    } else {
      res.send(404, "Automatic Test has been disabled");
    }
  });
  
  // main timbit route
  timbits.app.get(config.base + '/' + name + '/:view?', function(req, res) {
    
    // set view name to default view if not specified
    if (req.params.view == null) req.params.view = timbit.defaultView;
    
    // initialize current request context
    var context = {
      name: timbit.name,
      view: timbit.viewBase + '/' + req.params.view,
      maxAge:  timbit.maxAge
    };
    
    // add query string parameters to context
    for (var key in req.query) {
      var has_alias = false;
      
      if (context[key] == null && req.query[key] != null && req.query[key] !== '') {
        
        // handle aliased parameters
        for (var p in timbit.params) {
          if (timbit.params[p] === key) {
            has_alias = true;
            context[p] = req.query[key];
          }
        }
        
        // no alias found
        if (!has_alias)
          context[key] = req.query[key];
      }
    }
    
    // validate request
    for (var key in timbit.params) {
      var param = timbit.params[key];
        
      // if parameter isn't specified, use default value
      if (context[key] == null) context[key] = param.default;
      
      // test provided value based on type
      var value = context[key];
      if (value != null) {
        
        // default parameter type is String
        if (param.type == null) param.type = 'String';
        
        switch (param.type.toLowerCase()) {
          
          case 'number':
            context[key] = Number(value);
            if (isNaN(context[key]))
              throw value + ' is not a valid Number for ' + key;
            break;
            
          case 'boolean':
            switch (value.toLowerCase()) {
              case 'true':
                context[key] = true;
                break;
              case 'false':
                context[key]= false;
                break;
              default:
                throw value + ' is not a valid value for ' + key + '.  Must be true of false';
            }
            break;
            
          case 'date':
            context[key] = Date.parse(value);
            if (isNaN(context[key]))
              throw value + ' is not a valid date for ' + key;
            break;
            
        }
      }
      
      if (param.required && value == null) {
        throw key + " is a required parameter";
      }
      if (value != null && param.strict && param.values.indexOf(value) === -1) {
        throw value + " is not a valid value for " + key + ".  Must be one of [" + (param.values.join()) + "]";
      }
      if (value instanceof Array && !param.multiple) {
        throw key + " must be a single value";
      }
      
     }
     
     // with context created, it's time to consume this timbit
     timbit.eat(req, res, context);
  });
  
  // update example urls if base vpath specified
  if (config.base != null && timbit.examples != null) {
    timbit.examples.forEach(function(example) {
      example.href = config.base + example.href;
    });
  }
  
  // callback after timbit has been loaded
  callback();
  
};

// prototype for Timbit
var Timbit = this.Timbit = function() {};

Timbit.prototype.render = function(req, res, context) {

  // add caching headers
  res.setHeader("Cache-Control", "max-age=" + context.maxAge);
  res.setHeader("Edge-Control", "!no-store, max-age=" + context.maxAge);
  
  if (/^\w+\/json$/.test(context.view)) {
    if (config.json)
      res.json(context);
    else
      res.send(404, "JSON view has been disabled");
  } else {
    res.render(context.view, context, function(err, str) {
      if (err) {
        // TODO: Error Handling
        //timbits.log.error("Error rendering view " + context.view + ": " + err.stack);
        //res.send(500);
        throw err;
      } else {
        if (context.callback != null)
          res.json(str);
        else
          res.send(str);
      }
    });
  }
};

Timbit.prototype.fetch = function(req, res, context, options, callback) {

  // use built in render method by default
  if (callback == null) callback = this.render;
  
  var name = options.name || 'data';
  timbits.pantry.fetch(options, function(error, results) {
    if (error) {
      timbits.log.error("Error fetching resource '" + options.uri + "': " + (error.stack || error));
      res.send(500);
    } else {
      if (context[name] != null) {
        if (Object.prototype.toString.call(context[name][0]) === "[object Array]")
          context[name].push(results);
        else
          context[name] = [context[name], results];
      } else {
        context[name] = results;
      }
      callback(req, res, context);
    }
  });
};

Timbit.prototype.eat = function(req, res, context) {
  this.render(req, res, context);
};


Timbit.prototype.generateTests = function(alltests) {
  
  // create combination of required parameters
  var required = [];
  for (var name in this.params) {
    var param = this.params[name];
    if (param.required) {
      var temp = [];
      getTestValues(param.values, alltests).forEach(function(value) {
        if (required.length === 0)
          temp.push(name + "=" + value);
        else
          required.forEach(function(item) {
            temp.push(item + "&" + name + "=" + value);
          });      
      });
      required = temp;
    }
  }
  
  // create list of possible queries using required and optional parameters
  var queries = [];
  required.forEach(function(item) {
    queries.push(item)
  });
  
  // only include optional parameters if all tests are requested
  if (alltests) {
    for (var name in this.params) {
      var param = this.params[name];
      if (!param.required) {
        getTestValues(param.values, alltests).forEach(function(value) {
          if (required.length === 0)
            queries.push(name + "=" + value);
          else
            required.forEach(function(item) {
              queries.push(item + "&" + name + "=" + value);
            });
        });
      }
    }
  }
  
  //create list of testable paths using available views and quiries
  var hrefs = [];
  var name = this.name
  this.views.forEach(function(view) {
    if (queries.length)
      queries.forEach(function(query) {
        hrefs.push("/" + name + "/" + view + "?" + query);
      });
    else
      hrefs.push("/" + name + "/" + view);
  });
  
  return hrefs;
};

Timbit.prototype.test = function(host, alltests, callback) {
  
  // generate dynamic list of test urls
  var tests = this.generateTests(alltests);
  
  // add examples to list of tests
  if (this.examples) {
    this.examples.forEach(function(example) {
      tests.push(example.href);
    });
  }
  
  // run each test
  var results = [];
  var name = this.name;
  tests.forEach(function(href) {
    request(host + href, function(error, response, body) {
      error = error || (response.statusCode === 200 ? '' : body);
      results.push({
        timbit: name,
        href: href,
        error: error,
        status: response.statusCode,
        passed: response.statusCode === 200,
        failed: response.statusCode !== 200
      });
      if (results.length === tests.length)
        return callback(results);
    });
  });
  
};

Timbit.prototype.paramsAsArray = function() {
  var array = [];
  for (var key in this.params) {
    array.push({key: key, value: this.params[key]});
  }
  return array;
}

  