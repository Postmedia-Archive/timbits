style '''
body {margin: 0; padding: 0; font-family: Tahoma, Geneva, sans-serif;}
.test_block {
	border: 1px solid #666;
	margin: 20px;
	padding: 20px;
	width: 95%;
	background-color: #fcfcfc;
}
.test_block:hover {background-color: #f6f6f6;}
h1, h2, h3, h4, h5 {margin: 0; padding: 0;}
h1 {margin: 0 0 20px 0;}

.icon {
	float: left;
	margin: 3px 5px 0 0;
}

table {width: 990px; font-size: 12px;}
thead tr td {border-bottom: 1px solid #ddd; font-weight: bold;}
.test_passed, .test_failed {margin: 30px 0;}
.test_passed h3 {color: #009904; margin-bottom: 5px;}
.test_failed h3 {color: #D23D24; margin-bottom: 5px;}
ul {margin:0; list-style: none; font-size: 12px; padding: 0 0 0 20px;}
li:before { content: "» ";}
.test_required_params, .test_optional_params {margin-top: 30px;}
h4 {margin-bottom: 5px; color: #001cc9;}

'''
div class:"test_block", ->
	h1 class:'test_title', ->
		"Testing Summary, Timbit: '#{@timbit}'"

	# h3 class:'test_summary', 'Testing Summary'

	div class:'test_views', ->
		img src:'/images/eye.png', class:'icon'
		h4 'Views'
		ul ->
			for view in @views
				li -> view

	if @required?.length > 0
		div class:'test_required_params', ->
			img src:'/images/brick_add.png', class:'icon'
			h4 'Required Parameters'
			ul ->
				for required in @required
					li -> required

	if @optional?.length > 0
		div class:'test_optional_params', ->
			img src:'/images/brick_add.png', class:'icon'
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
			img src:'/images/accept.png', class:'icon'
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
			img src:'/images/cancel.png', class:'icon'
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

	if @warnings.length > 0
		div class:'warnings', ->
			img src:'/images/error.png', class:'icon'
			h3 "Warnings"
			table ->
				thead ->
					tr ->
						td 'Message'
				tbody ->
					for warning in @warnings
						tr ->
							td warning.message