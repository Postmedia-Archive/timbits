hasRelatedType = (related, mimetype) ->
	found = false
	for content in related
		if isContentType(content, mimetype)
			found = true
	return found
	
isContentType = (content, mimetype) ->
	found = false
	if content.Format.MimeType.indexOf(mimetype) != -1
		found = true
	return found
			
doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		meta(name: 'description', content: @desc) if @desc?
		meta(name: 'apple-touch-fullscreen', content: 'yes')
		meta (name:'viewport', content: 'width=device-width')
		title "#{@title or 'Untitled'}"
		comment '[if lt IE 9]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]'
		
		link href:'http://fonts.googleapis.com/css?family=Open+Sans:700', rel:'stylesheet', type:'text/css'
		
		comment 'jQuery Mobile'
		link href:'http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.css', rel:'stylesheet'
		script src:'http://code.jquery.com/jquery-1.6.2.min.js'
		script src:'http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.js'
		
		comment 'jQuery WipeTouch'
		script src: '/jquery/jquery.wipetouch.min.js'
		
		comment 'jQuery Slides'
		script src:'/jquery/slides.min.jquery.js'
		script src:'/jquery/slides.js'
		
		comment 'CSS Sheets'
		comment 'Reset Sheet'
		link href:'/css/reset.css', rel:'stylesheet', type:'text/css', media:'screen'
		comment 'Web Browser'
		link href:'/css/styles.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:1280px)'
		comment 'Small Resolution Web Browser'
		link href:'/css/1024.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:1025px) and (max-width:1279px)'
		comment 'iPad/Playbook/Tab'
		link href:'/css/tablets.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:1024px) and (max-width:1024px)'
		comment 'iPhone4'
		link href:'/css/iphone4.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:640px) and (max-width:1023px)'
		comment 'Galaxy'
		link href:'/css/galaxy.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:480px) and (max-width:639px)'
		comment 'iPhone3'
		link href:'/css/iphone3.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:0px) and (max-width:479px)'
				
	body ->
		div id:'wrapper', ->
			div id:'content', ->
				header ->
					nav ->

				section title:'mainarticle', id:'mainarticle', ->
					article ->
						div class:'title', ->
							@story.Title
						div class:'author', ->
							dt = Date parseInt(@story.PubDate.substr(6))
							time (datetime: dt, pubdate: 'pubdate'), -> dt																															
				
					if hasRelatedType(@related, 'image/')
						div id:'example', ->
							div id:'slides', ->
								div class:'slides_container', ->
									for related in @related
										if isContentType(related, 'image/')
											div class:'slide', ->
												figure ->
													img (src: 'http://www.canada.com/technology/space-shuttle/' + related.ID + '.bin?size=620x400')
													figcaption class:'caption', ->
														p related.Abstract
											#div class:'slide', ->
											#	figure ->
											#		img (src: '/images/next.png')
											#		figcaption class:'caption', ->
											#			p 'CAPTION'

								a href='#', class:'prev', -> img src:'/images/arrow-prev.png', alt:'Prev'
								a href='#', class:'next', -> img src:'/images/arrow-next.png', alt:'Next'
								
								#swipe integration
								coffeescript ->
									$(".slide").wipetouch 
									  wipeLeft: (result) ->
									    jQuery(".next").click()

									  wipeRight: (result) ->
									    jQuery(".prev").click()
					
					if hasRelatedType(@related, 'text/html')
						aside id:'sidebar', ->
							div id:'more', ->
								span class:'asidetitle', -> 'more on this story'
								ul class:'sidebarlist', ->
									for related in @related
										if isContentType(related, 'text/html')
											li ->
												a (href: '/story/' + related.ID), -> related.Title
												
							# RESERVED FOR 'AROUND THE WEB' STORIES; height of 'MORE' div is artificially inflated to compensate
							# div id:'aroundweb', ->
							#	span class:'asidetitle', -> 'more on this story'
							#	ul class:'sidebarlist', ->
							#		for related in @related
							#			if isContentType(related, 'text/html')
							#				li ->
							#					a (href: '/story/' + related.ID), -> related.Title					

					article id:'articletext', ->					
						div ->
							@story.Body.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&')
						@story.License.Copyright

					# RESERVED FOR COMMENTS
					# article (id: 'story_comments', 'data-role':'collapsible', 'data-collapsed': 'true'), ->
					#	h3 -> 'Comments'
					#	p -> 'Comments would be loaded here.'

				section id:'share', ->
					div id:'fbshare', ->
						div id:'fb-root', ->
							script src:'http://connect.facebook.net/en_US/all.js#appId=260249260654256&amp;xfbml=1'
							text '<fb:like href="http://canada.com" send="false" layout="button_count" width="150" show_faces="false" font=""></fb:like>'

					div id:'twittershare', ->
						text '<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal">Tweet</a>'
						script src:'http://platform.twitter.com/widgets.js'

					comment 'AddThis Button BEGIN'
					div class:'addthis_toolbox addthis_default_style', ->
						a class:'addthis_counter addthis_pill_style', ->
					script src:'http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e3af18651abdd0e'
					comment 'AddThis Button END'

					div id:'emailshare', ->
						img src:'/images/email.gif', alt:'email', title:'email'
						a href:'mailto:kgamble@postmedia.com', -> 'Email this Article'

					div id:'printshare', ->
						img src: '/images/print.gif', alt:'print', title:'print'
						a href:'#', -> 'Print this Article'

			section id:'rightside', title:'RightSide', ->

			footer ->