ul ->
	for item in @feed
		li ->
			a href: item.Uri or "/story/#{item.ID}", -> item.Title
			