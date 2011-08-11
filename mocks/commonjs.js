var exports = exports || {},
	process = process || {cwd: jasmine.createSpy()},
	require;

require = jasmine.createSpy().andCallFake(function (module) {
	switch (module) {
		case "path":
			return {
				join: jasmine.createSpy().andReturn("fakeFile"),
				exists: jasmine.createSpy().andCallFake(function (file, callback) {
					callback(true);
				})
			};
			break;		
		}
		default:
			return;
	}
});

/* Additional examples below, you need to define and mock up your own libraries in the cases above.  Will look to generate a more detailed commonjs in the future to be included by default, tests should assume to use faked results and unit test individual components of your specific file, not the required libraries that already have their own unit tests.
	
	case "fs":
		return {
			readFile: jasmine.createSpy().andCallFake(function (file, callback) {
				callback(true, '["fakedata"]');
			})
		};
		break;
	case "password-hash":
		return {
			generate: jasmine.createSpy().andCallFake(function (pass) {return pass + "PASSED";}),
			verify: jasmine.createSpy().andCallFake(function (pass1, pass2) {return pass1 == pass2;})
		};
		break;
	case "express":
		return {
			basicAuth: jasmine.createSpy().andCallFake(function (callback) { callback(params.express.basicAuth.user, params.express.basicAuth.pass, params.express.basicAuth.fn); })
		};
		break;
		*/
