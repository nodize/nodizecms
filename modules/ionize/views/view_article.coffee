@include = ->
	@view ionizePage: ->
		text "In ionize/page view"
		h1 ->
			text "Page view : #{@page.view}"
	
		ion_articles '', =>
			text "article here <br/>"
			text @article.content
			
		ion_navigation()
		