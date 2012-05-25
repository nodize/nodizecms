@include = ->
	 

	# ---------------------------
	# SERVER SIDE EVENTS
	#
	__nodizeEvents
	  #
	  # Page has been updated, we could store pages in a static JSON array
	  # TODO: should probably be in backend module
	  #
	  .on 'articleUpdate', (params) =>
	    #console.log "articleUpdate event in ctrl-> ", params.id_article
	    #console.log params
	    @io.sockets.emit 'live_articleUpdate', {id_article:params.id_article, content:params.article.content}

	# ---------------------------
	# CLIENT SIDE EVENTS
	#
	
	#
  # Management of live updates
  # Will be moved to a specific controller
  #
  @client '/nodize.js': ->       
   	@connect()
   
    @on live_articleUpdate: (params) ->
      console.log "Live update"
      $ = jQuery
      #
      # Live update of article content
      #      
      $('#ion_liveArticle_'+params.data.id_article+' .ion_live_content').html( params.data.content )      
      # http://www.bitstorm.org/jquery/color-animation/
      $('#ion_liveArticle_'+params.data.id_article+' .ion_live_content').animate({color:'#00AA00'}).animate({color:'#000000'})   		
	    