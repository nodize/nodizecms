@include = ->

  #
  # Redis client if enabled
  #
  if __nodizeSettings.get 'redis_enabled'
    redis = require 'redis'
    redisClient = redis.createClient()    
  
  #
  # Removing a key
  #
  removeRedisKey = (key) ->
    redisClient.keys key, (err, results) ->
        if err
          console.log err
        else
          for result in results            
            redisClient.del result 

  #
  # Force page refresh by removing its keys from Redis
  #
  page_refresh = (id_page) ->    
    if __nodizeSettings.get 'page_cache_enabled'
      #
      # Get url from id_page
      #
      redisClient.keys "page_cache:id:#{id_page}", (err, results) ->
        if err
          console.log err
        else
          #
          # Remove 
          #
          for result in results
            redisClient.get result, (err, url) =>
              if err
                console.log "Err on redis get"
              else                              
                removeRedisKey "page_cache:id:#{id_page}"
                removeRedisKey "page_cache:name:#{url}"

  # ---------------------------
  # SERVER SIDE EVENTS
  #
  __nodizeEvents
    
    #
    # An article has been created
    #
    .on 'articleCreate', (params) =>
      #
      # Remove page from cache
      #
      page_refresh params.parent      

    #
    # An article has been updated
    #
    .on 'articleUpdate', (params) =>
      #
      # Remove page from cache
      #
      page_refresh params.parent
    
    #
    # Application initialization, loading cache
    #
    .on 'initialization', (params) =>
      #
      # Remove existing cached page
      #      
      if __nodizeSettings.get 'page_cache_enabled'        
        redisClient.keys 'page_cache:*', (err, results) ->
          if err
            console.log err
          else
            for result in results
              redisClient.del result

      if __nodizeSettings.get('database_cache_enabled') and __nodizeSettings.get('redis_enabled')   
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
              
              redisClient.set "page:#{result.id_page}", JSON.stringify( content )

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
              
              redisClient.set "page_lang:#{result.url}:#{result.lang}", JSON.stringify( content )

              #
              # Adding a key for home page
              #
              if content.home is 1
                redisClient.set "page_lang:__home__:#{result.lang}", JSON.stringify( content )                

              # Page_cached.create record, (err, record) ->
              #   if err
              #     console.log "memoryStore error", err

          .on 'failure', (err) ->
            console.log 'database error ', err
        