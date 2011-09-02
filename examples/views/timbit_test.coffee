div id:"test_#{@timbit}", ->
	h1 class:'test_title', ->
		"Test Timbit '#{@timbit}'"

	h3 class:'test_summary', 'Testing Summary'

	div class:'test_views', ->
		h4 'Views'
		ul ->
			for view in @views
				li -> view

	if @required?.length > 0
		div class:'test_required_params', ->
			h4 'Required Parameters'
			ul ->
				for required in @required
					li -> required

	if @optional?.length > 0
		div class:'test_optional_params', ->
			h4 'Optional Parameters'
			ul ->
				for optional in @optional
					li -> optional

	passed = 0
	failed = 0
	for test in @tests
		if test.status == 200 then passed++ else failed++

	if passed > 0
		div class:'test_passed', ->
			h3 "Passed #{passed} of #{passed+failed}"
			table ->
				thead ->
					tr ->
						td 'Type'
						td 'URL'
				tbody ->
					for test in @tests
						if test.status is 200
							tr ->
								td test.type
								td test.uri

	if failed > 0
		div class:'test_failed', ->
			h3 "Failed #{failed} of #{passed+failed}"
			table ->
				thead ->
					tr ->
						td 'Type'
						td 'URL'
						td 'HTTP Status'
						td 'Error Message'
				tbody ->
					for test in @tests
						if test.status isnt 200
							tr ->
								td test.type
								td test.uri
								td test.status
								td test.error