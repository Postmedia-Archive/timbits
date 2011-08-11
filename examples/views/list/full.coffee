for item in @feed
	more = item.Uri or "/story/#{item.ID}"
	h2 ->
		a href: more, -> item.Title
	div -> b -> "By #{item.Credit}" if item.Credit
	p ->
		text "#{item.Abstract} "
		a href: more, -> "[more]"
