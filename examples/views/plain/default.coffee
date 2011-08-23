if @year is '1999'
	h1 id: 'msg', ->
		"Wazzzzuuuup #{@who}!"
else
	h1 ->
		"Hello #{@who}"

script '''
	function blinkText() {
		msg = document.getElementById('msg')
		if (msg)
			msg.style.visibility=(msg.style.visibility=='visible') ?'hidden':'visible';
	}
	setInterval('blinkText()',400)
'''