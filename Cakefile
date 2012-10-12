{spawn} = require 'child_process'

option '-a', '--all', 'run all dynamic tests'
option '-w', '--watch', 'watch for changes'

task 'build', '', (options) ->
	args = ['-c', '-o', 'lib', 'src']
	args.splice 2, 0, '-w' if options.watch
	
	coffee = spawn 'coffee', args, {stdio: 'inherit', env: process.env}

task "test", "run all dynamic tests", (options) ->
	process.env.TIMBITS_TEST_WHICH = 'all' if options.all
	
	args = 	[
		'--reporter'
		'spec'
		'--compilers'
		'coffee:coffee-script'
		'--growl'
		'--colors'
		]
		
	args.push '--watch' if options.watch 
	
	mocha = spawn 'mocha', args, {
			stdio: 'inherit'
			env: process.env
		}
