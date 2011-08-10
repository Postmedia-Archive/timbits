doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		meta (name:'viewport', content: 'width=device-width')
		title 'Canada.com | Egypt puts Mubarak, bedridden and caged, on trial'
		comment '[if lt IE 9]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]'
		
		link href:'http://fonts.googleapis.com/css?family=Open+Sans:700', rel:'stylesheet', type:'text/css'
		
		comment 'jQuery Mobile'
		link href:'http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.css', rel:'stylesheet'
		script src:'http://code.jquery.com/jquery-1.6.2.min.js'
		script src:'http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.js'
		
		comment 'jQuery Slides'
		script src:'jquery/slides.min.jquery.js'
		script src:'jquery/slides.js'
		
		comment 'CSS Sheets'
		comment 'Reset Sheet'
		link href:'reset.css', rel:'stylesheet', type:'text/css', media:'screen'
		comment 'Web Browser'
		link href:'styles.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:1280px)'
		comment 'Small Resolution Web Browser'
		link href:'1024.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:1025px) and (max-width:1279px)'
		comment 'iPad/Playbook/Tab'
		link href:'tablets.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:1024px) and (max-width:1024px)'
		comment 'iPhone4'
		link href:'iphone4.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:640px) and (max-width:1023px)'
		comment 'Galaxy'
		link href:'galaxy.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:480px) and (max-width:639px)'
		comment 'iPhone3'
		link href:'iphone3.css', rel:'stylesheet', type:'text/css', media:'only screen and (min-width:0px) and (max-width:479px)'
		
	body ->
		div id:'wrapper', ->
			div id:'content', ->
				header ->
					nav ->
			
				section title:'mainarticle', id:'mainarticle', ->
					article title:'Egypt puts Mubarak, bedridden and caged, on trial', ->
						div class:'title', ->
							'Egypt puts Mubarak, bedridden and caged, on trial'
						div class:'author', ->
							'BY JEFFREY FLEISHMAN, LOS ANGELES TIMES AUGUST 3, 2011 11:31 AM'
					
						div id:'example', ->
							div id:'slides', ->
								div class:'slides_container', ->
									div class:'slide', ->
										figure title:'5172720.jpg', ->
											img src:'images/5172720.jpg', alt:'5172720.jpg', title:'5172720.jpg'
											figcaption class:'caption', title:'5172720.jpg', ->
												p 'Months after an uprising ended his 30-year-rule, Egypt&lsquo;s ex-president Hosni Mubarak goes on trial Wednesday on murder charges, in a historic moment for the Arab region whose leaders are rarely held to account.'

									div class:'slide', ->
										figure title:'5198628.jpg', ->
											img src:'images/5198628.jpg', alt:'5198628.jpg', title:'5172720.jpg'
											figcaption class:'caption', title:'5198628.jpg', ->
												p 'A supporter of former President Hosni Mubarak kisses a poster of him outside the police academy where his trial will take place, in Cairo August 3, 2011. Mubarak flew to Cairo on Wednesday where he will be tried for conspiring to kill protesters, the first Arab ruler to appear in court since uprisings swept the region.'

									div class:'slide', ->
										figure title:'5198629.jpg', ->
											img src:'images/5198629.jpg', alt:'5198629.jpg', title:'5198629.jpg'
											figcaption class:'caption', title:'5198629.jpg', ->
												p 'Egyptians riot police look at a supporter of Egypt&lsquo;s former President Hosni Mubarak clashing with an anti-Mubarak protester outside the police academy where his trial will take place, in Cairo August 3, 2011.'

									div class:'slide', ->
										figure title:'5199107.jpg', ->
											img src:'images/5199107.jpg', alt:'5199107.jpg', title:'5199107.jpg'
											figcaption class:'caption', title:'5199107.jpg', ->
												p 'Mubarak was wheeled into a courtroom cage in a hospital bed on Wednesday to face trial for killing protesters — an image that thrilled those who overthrew him and must have chilled other Arab autocrats facing popular uprisings. If convicted, Mubarak could face the death penalty.'
								a href='#', class:'prev', -> img src:'images/arrow-prev.png', alt:'Prev'
								a href='#', class:'next', -> img src:'images/arrow-next.png', alt:'Next'
						aside id:'sidebar', ->
							div id:'more', ->
								span class:'asidetitle', -> 'more on this story'
								ul class:'sidebarlist', ->
									li ->
										a href:'http://www.canada.com/news/burn+heart+says+victim+father+Mubarak/5199049/story.html', alt:'&lsquo;May God burn his heart,&lsquo; says victim&lsquo;s father to Mubarak', -> '&lsquo;May God burn his heart,&lsquo; says victim&lsquo;s father to Mubarak'
									li ->
										a href:'http://www.canada.com/news/Overthrown+Mubarak+goes+trial/5196244/story.html', alt:'Overthrown Mubarak goes on trial', -> 'Overthrown Mubarak goes on trial'
									li ->
										a href: 'http://www.canada.com/news/Mubarak+trial+message+Arab+rulers/5196617/story.html', alt: 'Mubarak trial &lsquo;message to Arab rulers&lsquo;', -> 'Mubarak trial &lsquo;message to Arab rulers&lsquo;'
									li ->
										a href: 'http://www.canada.com/news/arab-world-unrest/index.html', alt: 'Mideast and Arab World Unrest', -> 'Mideast and Arab World Unrest'					
					
							div id:'aroundweb', ->
								span class:'asidetitle', -> 'RELATED STORIES FROM AROUND THE WEB'
								ul class:'sidebarlist', ->
									li ->
										a href:'http://infor.md/pL8vK0', alt:'Egypt&lsquo;s Mubarak &lsquo;refusing food,&lsquo; doctors say', -> 'Egypt&lsquo;s Mubarak "refusing food," doctors say'
										span 'CBS News - Tuesday, July 26, 2011'
									li ->
										a href:'http://infor.md/pL8s17', alt:'Mubarak &lsquo;weak and refusing to eat&lsquo;', -> 'Mubarak &lsquo;weak and refusing to eat&lsquo;'
										span 'Scotsman - Tuesday, July 26, 2011'
									li ->
										a href: 'http://infor.md/pL8qj2', alt: 'Egypt&lsquo;s Mubarak &lsquo;refusing food&lsquo;', -> 'Egypt&lsquo;s Mubarak &lsquo;refusing food&lsquo;'
										span 'BBC News - Tuesday, July 26, 2011'
					
						section id:'articletext', ->
							p 'CAIRO — A nation watched rapt as toppled President Hosni Mubarak, once the epitome of the Arab autocrat, was wheeled into a makeshift courtroom in a hospital bed Wednesday to stand trial, accused of killing hundreds of Egyptian protesters in the uprising that led to his downfall in February.'
						
							p 'Flat on his back and flanked by sons Gamal and Alaa, who were dressed in prison whites and also charged with corruption, Mubarak peered through a metal cage as the charges against him were read. It was a moment imbued with startling symbolism: a once untouchable family brought to justice by an emerging democracy they sought for years to crush.'
						
							p 'How do you plead? asked Judge Ahmed Refaat.'
						
							p '"I totally deny all those charges," said Mubarak, holding a microphone, his face stern, his voice strong.'
						
							p 'It was a day to celebrate for most Egyptians, but one that likely rattled the rulers of Libya, Syria, Yemen and other nations swept up in rebellions inspired by the 18-day revolt that brought down Mubarak&lsquo;s 3-decade-old regime. The once invincible Arab strongmen are under duress and, if Egypt is any example, there is little succor for them if their governments tumble.'
						
							p 'Mubarak faces the death penalty if convicted of ordering his security forces to kill demonstrators in an attempt to hold on to his unraveling state last winter. He and his sons face 15-year prison sentences on charges of financial corruption and abuse of power, stemming from allegations that they pocketed millions of dollars in a deal to sell Egypt&lsquo;s natural gas to Israel.'
						
							p 'The trial was held at the police academy formerly named for Mubarak on the outskirts of Cairo. Heavy security, including at least 3,000 police and soldiers and more than 30 tanks, surrounded the compound as lawyers and families of victims killed in the revolution clamored for a glimpse of the 83-year-old former ruler.'
						
							p 'Many doubted if Mubarak, who was flown in by helicopter, would attend the hearing. He has been in custody in a hospital at a Red Sea resort since suffering a heart attack in April. Days before the trial, he was reportedly refusing to eat and in a state of depression. But Egyptian authorities, facing tremendous pressure from political parties and youth activists, ordered him to appear.'
						
							p 'The trial was nationally televised. Egyptians gathered around TVs and marveled at Mubarak lying in a bed, whispering to his sons, scratching his face and concentrating on the proceedings, almost detached, as if he were watching a play unfold.'
						
							p '"It still feels like a dream," said Mohammed Farouk, a pharmacist watching a TV in a downtown cafe. "This is the same state television channel that used to make it seem that the whole world revolved around Mubarak, and now this same station is showing him lying there in a cage."'
						
							p 'He added: "Today, we Egyptians are sending a message to the U.S. and Europe. We are saying even though this man served his country in a war and became its president, he must still face justice and be punished like anyone else."'
						
							p 'A policeman sitting nearby shouted: "Hang &lsquo;em."'
						
							p 'Mubarak&lsquo;s former interior minister, Habib Adli, is also charged conspiring with the former president to murder protesters and sat in the cage next to him. Mubarak&lsquo;s trial was adjourned until Aug. 15. Adli&lsquo;s will resume Thursday.'
						
							p '&copy; Copyright (c) Los Angeles Times'
			
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
						img src:'images/email.gif', alt:'email', title:'email'
						a href:'mailto:kgamble@postmedia.com', -> 'Email this Article'
				
					div id:'printshare', ->
						img src: 'images/print.gif', alt:'print', title:'print'
						a href:'#', -> 'Print this Article'

			section id:'rightside', title:'RightSide', ->
			
			footer ->



