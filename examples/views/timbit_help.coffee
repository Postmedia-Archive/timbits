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