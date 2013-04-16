#
# Not used anymore, replaced by Twitter Bootstrap dropdowns
#
@include = ->
	
	#
	# This view is displaying the application header bar, with login & menus
	#
	@view 'backend_desktopHeader': ->
		div '#desktopBar', ->
			#
			# Application logo + login + langs
			#
			div '.desktopTitlebarWrapper', ->
				div '.desktopTitlebar', ->
					h1 '.applicationTitle', 'ionize'
					a id: 'logoAnchor'
					div '.topNav', ->
						ul '.menu-right', ->
							li -> 
								text @ion_lang.ionize_logged_as
								text ' : '
								text @user							
							li 'fr'
							li ->
								a href:"admin/logout", -> "logout"
			
			#
			# Menus
			#
			div '#desktopNav.desktopNav', ->
				div '.toolMenu.left', ->
					ul ->
						li ->
							a class: 'navlink', href: 'dashboard', title: text "", -> @ion_lang.ionize_menu_dashboard
						li ->
							a class: 'returnFalse', -> @ion_lang.ionize_menu_content
							ul ->
								li ->
									a class: 'navlink', href: 'menu', title: @ion_lang.ionize_title_menu, -> @ion_lang.ionize_menu_menu
								li ->
									a class: 'navlink', href: 'page\/\/create/0', title:@ion_lang.ionize_title_new_page, -> @ion_lang.ionize_menu_page
								li ->
									a class: 'navlink', href: 'article\/\/list_articles', title: @ion_lang.ionize_title_articles, -> @ion_lang.ionize_menu_articles
								
								# li ->
								# 	a class: 'navlink', href: 'translation', title: @ion_lang.ionize_title_translation, -> @ion_lang.ionize_menu_translation
								li '.divider', ->
									a id: 'mediamanagerlink', href: 'media\/\/get_media_manager', title:  @ion_lang.ionize_menu_media_manager, -> @ion_lang.ionize_menu_media_manager
								# li '.divider', ->
								# 	a class: 'navlink', href: 'element_definition\/\/index', title:  @ion_lang.ionize_menu_content_elements, -> @ion_lang.ionize_menu_content_elements
								# li ->
								# 	a class: 'navlink', href: 'extend_field\/\/index', title:  @ion_lang.ionize_menu_extend_fields, -> @ion_lang.ionize_menu_extend_fields
						# li ->
						# 	a class: 'returnFalse', -> @ion_lang.ionize_menu_tools
						# 	ul ->
						# 		li ->
						# 			a href: 'https://www.google.com/analytics/reporting/login', target: '_blank', 'Google Analytics'
						# 		li ->
						# 			a class: 'navlink', href: 'system_check', -> @ion_lang.ionize_menu_system_check
						li ->
							a class: 'returnFalse', -> @ion_lang.ionize_menu_settings
							ul ->
								# li ->
								# 	a class: 'navlink', href: 'setting\/\/ionize', title: @ion_lang.ionize_menu_ionize_settings, -> @ion_lang.ionize_menu_ionize_settings
								li ->
									a id:"menuItem_lang", class: 'navlink', href: 'lang', title: @ion_lang.ionize_menu_languages, -> @ion_lang.ionize_menu_languages
								li ->
									a class: 'navlink', href: 'users', title:  @ion_lang.ionize_menu_users, -> @ion_lang.ionize_menu_users
								li ->
									a class: 'navlink', href: 'setting\/\/themes', title:  @ion_lang.ionize_title_theme, -> @ion_lang.ionize_menu_theme
								# li '.divider', ->
								# 	a class: 'navlink', href: 'setting', title:  @ion_lang.ionize_menu_site_settings, -> @ion_lang.ionize_menu_site_settings
								# li ->
								# 	a class: 'navlink', href: 'setting\/\/technical', title:  @ion_lang.ionize_menu_site_settings_technical, -> @ion_lang.ionize_menu_site_settings_technical
				div id:'desktopNavToolbar_spinner', class:'spinner'
				
				div class:'toolbox', ->
					div id:'spinnerWrapper', ->
						div id:'spinner'

			#
			# /desktopNavbar
			#


		coffeescript ->
			$$(".navlink").each (item) ->
			  item.addEvent "click", (event) ->
			    event.preventDefault()
			    MUI.Content.update
			      url: admin_url + ION.cleanUrl(@getProperty("href"))
			      element: "mainPanel"
			      title: @getProperty("title")

			$("mediamanagerlink").addEvent "click", (event) ->
			  event.preventDefault()
			  MUI.Content.update
			    url: admin_url + ION.cleanUrl(@getProperty("href"))
			    element: "mainPanel"
			    title: @getProperty("title")
			    padding:
			      top: 0
			      right: 0
			      bottom: 0
			      left: 0

			$("aboutLink").addEvent "click", (event) ->
			  event.preventDefault()
			  new MUI.Modal(
			    id: "about"
			    title: "MUI"
			    content:
			      url: admin_url + "desktop/get/about"

			    type: "modal2"
			    width: 360
			    height: 210
			    padding:
			      top: 70
			      right: 12
			      bottom: 10
			      left: 22

			    scrollbars: false
			  )

		