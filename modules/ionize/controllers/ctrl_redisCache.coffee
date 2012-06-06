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
      console.log "article update event in memoryStore"
      #console.log "articleUpdate event in ctrl-> ", params.id_article
      #console.log params
      #@io.sockets.emit 'live_articleUpdate', {id_article:params.id_article, content:params.article.content}

    #
    # Application initialization, loading cache
    #
    .on 'initialization', (params) =>
      console.log "Application initializated event"
      
      if __nodizeSettings.get 'redis_enabled'
        redis = require 'redis'
        client = redis.createClient()

      if __nodizeSettings.get 'page_cache_enabled'        
        client.keys 'page_cache:*', (err, results) ->
          if err
            console.log err
          else
            for result in results
              client.del result

      if __nodizeSettings.get 'database_cache_enabled'      
        #
        # Loading Page table in memory
        #
        Page.findAll()
          .on 'success', (results) ->
            for result in results 
              #console.log result        
              content = {}
              for attribute in result.attributes
                content[attribute] = result[attribute]
              
              client.set "page:#{result.id_page}", JSON.stringify( content )

          .on 'failure', (err) ->
            console.log 'database error ', err

        #
        # Loading Page_lang table in memory
        #
        Page_lang.findAll()
          .on 'success', (results) ->
            for result in results 
              content = {}
              for attribute in result.attributes
                content[attribute] = result[attribute]

              #console.log content
              
              client.set "page_lang:#{result.url}:#{result.lang}", JSON.stringify( content )

              #
              # Adding a key for home page
              #
              if content.home is 1
                client.set "page_lang:__home__:#{result.lang}", JSON.stringify( content )                

              # Page_cached.create record, (err, record) ->
              #   if err
              #     console.log "memoryStore error", err

          .on 'failure', (err) ->
            console.log 'database error ', err
        