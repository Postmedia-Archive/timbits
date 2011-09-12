exports.help = ->
	style '''body {
		background: #d2d5dc; /* Old browsers */
		background: -moz-linear-gradient(top, #d2d5dc 0%, #ffffff 75%); /* FF3.6+ */
		background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#d2d5dc), color-stop(75%,#ffffff)); /* Chrome,Safari4+ */
		background: -webkit-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Chrome10+,Safari5.1+ */
		background: -o-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Opera11.10+ */
		background: -ms-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* IE10+ */
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d2d5dc', endColorstr='#ffffff',GradientType=0 ); /* IE6-9 */
		background: linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* W3C */
		background-repeat: no-repeat;
		margin: 0;
		padding: 0;
		font: 14px Tahoma, Geneva, sans-serif;
	}
	#content {
	    background: #fff none;
	    width: 750px;
	    padding: 5px 20px 20px 20px;
		box-shadow: 0 0px 20px #666;
		min-height: 500px;
	}

	a {color: #4E5989; text-decoration: underline;}
	a:hover {text-decoration: none;}

	#wrapper {width: 750px; margin: 0 auto;}

	h1 {border-bottom: 1px solid #999; width: 100%; font: 30px Tahoma, Geneva, sans-serif}

	p, h3 {margin: 0 0 5px 0;}
	h2 {margin: 40px 0 5px 0;}

	ul {
	    margin: 0 0 10px 0;
	    list-style: none;
		padding: 0;
	}

	li {padding: 0 0 10px 0; text-transform: uppercase;}
	'''

	div id:'wrapper', ->
		div id:'content', ->
			h1 'Timbits - Help'

			ul ->
				for k, v of @box
					li -> a href: "/#{k}/help", -> k + ' &raquo;'

exports.test = ->
	style '''body {
		background: #d2d5dc; /* Old browsers */
		background: -moz-linear-gradient(top, #d2d5dc 0%, #ffffff 75%); /* FF3.6+ */
		background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#d2d5dc), color-stop(75%,#ffffff)); /* Chrome,Safari4+ */
		background: -webkit-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Chrome10+,Safari5.1+ */
		background: -o-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Opera11.10+ */
		background: -ms-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* IE10+ */
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d2d5dc', endColorstr='#ffffff',GradientType=0 ); /* IE6-9 */
		background: linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* W3C */
		background-repeat: no-repeat;
		margin: 0;
		padding: 0;
		font: 14px Tahoma, Geneva, sans-serif;
	}
	#content {
	    background: #fff none;
	    width: 750px;
	    padding: 5px 20px 20px 20px;
		box-shadow: 0 0px 20px #666;
		min-height: 500px;
	}
	
	.test_passed h3 {color: #009904; margin-bottom: 5px;}
	.icon {
		float: left;
		margin: 3px 5px 0 0;
	}
	
	a {color: #4E5989; text-decoration: underline;}
	a:hover {text-decoration: none;}

	#wrapper {width: 750px; margin: 0 auto;}

	h1 {border-bottom: 1px solid #999; width: 100%; font: 30px Tahoma, Geneva, sans-serif}

	p, h3 {margin: 0 0 5px 0;}
	h2 {margin: 40px 0 5px 0;}

	ul {
	    margin: 0 0 10px 0;
	    list-style: none;
		padding: 0;
	}

	li {padding: 0 0 10px 0; text-transform: uppercase;}
	'''

	div id:'wrapper', ->
		div id:'content', ->
			h1 'Timbits - Testing'

			if not @tests?
				div class:'test_passed', ->
					img src:'/images/accept.png', class:'icon'
					h3 "No timbits exist yet, base testing of timbits server passes however."

exports.timbit_help = ->
	style '''body {
		background: #d2d5dc; /* Old browsers */
		background: -moz-linear-gradient(top, #d2d5dc 0%, #ffffff 75%); /* FF3.6+ */
		background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#d2d5dc), color-stop(75%,#ffffff)); /* Chrome,Safari4+ */
		background: -webkit-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Chrome10+,Safari5.1+ */
		background: -o-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* Opera11.10+ */
		background: -ms-linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* IE10+ */
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d2d5dc', endColorstr='#ffffff',GradientType=0 ); /* IE6-9 */
		background: linear-gradient(top, #d2d5dc 0%,#ffffff 75%); /* W3C */
		background-repeat: no-repeat;
		margin: 0;
		padding: 0;
		font: 14px Tahoma, Geneva, sans-serif;
	}
	#content {
	    background: #fff none;
	    width: 750px;
	    padding: 5px 20px 20px 20px;
		box-shadow: 0 0px 20px #666;
		min-height: 500px;
	}

	a {color: #4E5989; text-decoration: underline;}
	a:hover {text-decoration: none;}

	#wrapper {width: 750px; margin: 0 auto;}

	h1 {border-bottom: 1px solid #999; width: 100%; font: 30px Tahoma, Geneva, sans-serif}
	h2 {font: 20px Tahoma, Geneva, sans-serif}

	p, h3 {margin: 0 0 5px 0;}
	h2 {margin: 40px 0 5px 0;}

	ul {
	    margin: 0 0 10px 0;
	    list-style: none;
		padding: 0;
	}

	li {padding: 0 0 10px 0; text-transform: uppercase;}
	#return {margin-top: 20px;}
	table {border: 1px solid #4E5989; width: 100%; border-collapse: collapse; border-spacing: 0;}
	th, tr {text-align: left; border-bottom: 1px solid #4E5989;}
	td, th {border-right: 1px solid #4E5989;}
	td, th {padding: 5px;}
	'''
	div id:'wrapper', ->
		div id:'content', ->
			h1 @name

			p @about or 'Developer was too lazy to describe this widget'

			h2 'Examples:'

			if @examples
				ul ->
					for example in @examples
						li -> a href: example.href, -> example.caption
			else
				p 'Developer was too lazy to define any examples.'

			h2 'Views'

			if @views
				ul ->
					for view in @views
						li -> view

			h2 'Parameters'

			if @params
				table ->
					tbody ->
						tr ->
							th 'Name'
							th 'Description'
							th 'Type'
							th 'Required'
							th 'Multiple'
							th 'Default'
							th 'Values'
						for key, attr of @params
							tr ->
								td key
								td attr.description
								td attr.type or 'String'
								td (attr.required or false).toString()
								td (attr.multiple or false).toString()
								td attr.default
								if attr.values then td ->
									if attr.strict then text('One of:') else text('Examples:')
									ul -> li value for value in attr.values

			else
				p 'None defined'

			div id:'return', -> a href: '/timbits/help', -> '&laquo; Help Index'

exports.timbit_test = ->
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
									td -> a href: test.uri, target: '_blank', -> test.uri

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
									td -> a href: test.uri, target: '_blank', -> test.uri
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