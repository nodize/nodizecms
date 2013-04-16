@include = ->


  # ---------------------------
  # NODE.JS SERVER SIDE EVENTS
  #
  __nodizeEvents
    #
    # Page has been updated
    #
    .on 'articleUpdate', (params) =>
      @io.sockets.emit 'live_articleUpdateAvailable', {id_article:params.article.id_article}

  # ---------------------------
  # SOCKET.IO SERVER SIDE EVENTS
  #
  @io.sockets.on 'connection', (socket) ->

    socket.on 'live_getArticle', (data) ->
      session = socket.handshake.session

      data.lang = session.lang

      if data.id_article
        Article.get data, (err, article) ->
          unless err
            socket.emit 'live_articleUpdate', {article : article}

          else
            console.log "ctrl_events | article not found"

  # ---------------------------
  # CLIENT SIDE EVENTS
  #

  #
  # Management of live updates
  # Will be moved to a specific controller
  #
  @client '/nodize.js': ->
    @connect()

    #
    # An update is available for an article
    # We let clients (browser) request for the content
    #
    @on 'live_articleUpdateAvailable':  ->
      $ = jQuery

      #
      # Live update of article content
      #
      article = $('#ion_liveArticle_'+@data.id_article)

      if article
        @emit 'live_getArticle', {id_article:@data.id_article}

      #
      # Refresh page when an article is updated
      #
      if $('#ion_refreshArticle_'+@data.id_article).length>0
        location.reload()


    #
    # Article's updated content has been received,
    # lets display it
    #
    @on live_articleUpdate:  ->
      $ = jQuery

      #
      # Live update of article values
      #
      for key, value of @data.article
        $("#ion_liveArticle_#{@data.article.id_article} [data-bind='article.#{key}']").html( value )


