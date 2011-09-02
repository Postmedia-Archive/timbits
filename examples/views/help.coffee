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
			for k, v of @
				li -> a href: "/#{k}/help", -> k + ' &raquo;'