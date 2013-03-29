@include = ->

  #
  # Redis initialization, used for page cache & MySQL tables cache
  #
  if __nodizeSettings.get 'redis_enabled'
    redis = require 'redis'
    redisClient = redis.createClient()


  #@use "partials"
  #
  # Partials management
  #
  partialModule = require '../libs/partials'
  partialModule.register( 'coffee', 'coffeecup' )
  partialModule.register( '.eco', 'eco' )

  partialModule.setInlineViews( @zappa.run.zappa_fs ) if @zappa.run.zappa_fs

  #
  # Needed for CoffeKup's helpers compatibility with Eco/Jade template engine
  #
  global.text = (value) -> value
  global.cede = (content) -> content()

  #*****
  #* DEFAULT HANDLER, DISPLAYING PAGE FROM DATABASE
  #*
  #**
  @ionize_displayPage = (req, res, helpers, name, args) ->
    #console.log req.request.headers["accept-language"]
    try
      #
      # Extracting lang from URI, or use default
      #
      segments = name.split('/')
      #console.log name, segments, Static_langs
      if segments[0] in Static_langs
        lang = segments[0]

        #
        # Remove first segment
        #
        segments.splice( 0, 1 )

        #
        # Removing lang from URI & redirect if it's the default lang
        #
        if lang is Static_lang_default
          name = "/"+segments.join("/")
          res.redirect( name )
          return

        name = segments[0]
        req.params[0] = name
      else
        lang = Static_lang_default

      req.session.lang = lang

      startTime = Date.now()
      #
      # Requesting home page if url = "/"
      #

      if req.url is '/'
        condition = {home : 1, lang:lang }
      else
        condition = {url : name, lang:lang }

      #
      # Saving id_page, used by cache
      #
      id_page = -1

      startPageRendering = =>
        #
        # Call back used by render & partials
        # To let us now we can send the response
        #
        requestCounter = 0 # Used to know when all requests are done
        requestId = 0 # Giving an id to each request

        chunks = [] # Storing the partial responses
        layout = "" # Main layout

        sendResponse = ->

          #
          # Sorting chunks by creation order, needed for async templates engines (ie Jade)
          #
          sortChunks = (a,b) ->
            return a.requestId.order - b.requestId.order


          chunks.sort( sortChunks )

          #console.log chunks

          #
          # Rebuilding the response, assembling chunks
          #
          for chunk in chunks
            #console.log "ctrl_page | chunck", chunk.requestId.name

            layout = layout.replace( '{**'+chunk.requestId.name+'**}', chunk.content )

          #
          # Adding page to cache
          #
          if __nodizeSettings.get 'page_cache_enabled'
            redisClient.set "page_cache:name:"+name, layout
            redisClient.set "page_cache:id:"+id_page, name

          #
          # Send page
          #
          res.send layout


        #
        # Registering a request (main layout and Nodize helpers)
        #
        registerRequest =  (requestName) ->

          requestCounter++
          requestId++

          # Building & returning an id name
          request =
            name  : requestName+'_'+requestId
            order : requestId

          #console.log "ctrl_page | registering ",request.name

          return request

        #
        # Callback for when a Nodize helpers has finished rendering
        #
        requestCompleted = (requestId, response) ->
          requestCounter--
          chunks.push { requestId : requestId, content : response }

          if requestCounter is 0

            #broadcast testEvent: {message:'Page '+name+' served in '+startTime-Date.now()}
            #broadcast testEvent: {message:'Page ['+(name or '/')+'] served in '+(Date.now()-startTime)+' ms'}
            sendResponse()

        #
        # Callback for when the main layout has finished rendering
        # If no requests are pending, we send back the response
        # else, it's stored for later reconstruction
        #
        renderCompleted = (err, list) ->
          requestCounter--

          #
          # Storing the main layout
          #
          if err
            console.log "ctrl_page | Page rendering error : ", err
            console.log err.stack

            layout = err.toString()
          else
            layout = list

          if requestCounter is 0
            sendResponse()

        #*****
        #* Step 1 retrieve page_lang using the page name
        #*
        #**
        findPageLang = (condition) =>
          #
          # Find page in Redis cache
          #
          if __nodizeSettings.get 'database_cache_enabled'
            if condition.home
              key = "page_lang:__home__:"+condition.lang
            else
              key = "page_lang:"+condition.url+":"+condition.lang

            redisClient.get key, (err, page_lang) =>
              if err
                console.log "Err on redis get"
              else
                page_lang = JSON.parse( page_lang )
                findPage( page_lang )
          #
          # Find page in database
          #
          else
            Page_lang.find( {where: condition } )
              .on 'success', (page_lang)->
                if page_lang
                  findPage( page_lang )
                else
                  res.send "page #{name} not found", 404



        #*****
        #* Step 2 retrieve page
        #*
        #**
        findPage = (page_lang) =>
          #
          # Find page in Redis cache
          #
          if __nodizeSettings.get 'database_cache_enabled'
            redisClient.get 'page:'+page_lang.id_page, (err, page) =>
              if err
                console.log "Err on redis get"
              else
                page = JSON.parse( page )
                processPage page_lang, page
          #
          # Find page in database
          #
          else
            Page.find({where:{id_page:page_lang.id_page}})
              .on 'success', (page) =>
                processPage page_lang, page
              .on 'failure', ->
                #
                # No page found, rendering an empty page
                #
                registerRequest "main"


                res.render 'page_default',
                  hardcode  : helpers
                  page      : page
                  page_lang : page_lang
                  layout    : no
                  registerRequest : registerRequest
                  requestCompleted : requestCompleted
                  params    : args
                ,
                  (err,list) ->
                    renderCompleted err, list

        processPage = (page_lang, page) =>
          #
          # Saving id_page, for caching purpose
          #
          id_page = page.id_page

          #
          # If a link is set we use it
          #
          if page.link?
            condition = {id_page : page.link_id, lang:lang }
            findPageLang( condition )
          #
          # Else we render the page
          #
          else
            #
            # Rendering /views/page.coffee
            #
            registerRequest "main"

            page.view = "page_default" if page.view is null

            #
            # Defining page.title, using the "window title" if defined, else the regular "title" field
            #
            if page_lang.meta_title isnt ''
              page.title = page_lang.meta_title
            else
              page.title = page_lang.title



            data =
              hardcode  : helpers
              page      : page
              page_lang : page_lang
              lang      : lang
              layout    : no
              req       : req
              res       : res
              registerRequest : registerRequest
              requestCompleted : requestCompleted
              settings  : __nodizeSettings.stores.nodize.store
              params    : args

            #
            # Making CoffeeKup helpers available to .eco pages
            #
            # in .coffee views :
            #   @ion_articles => p @article.content
            #
            # in .eco views will become :
            #   <% @ion_articles => %>
            #   <p> <%- @article.content %> </p>
            #
            for helper of helpers
              do (helper) =>
                data[helper] = (args...) -> @hardcode[helper].apply(this, args)

            # Allows `partial 'foo'` instead of `text @partial 'foo'`.
            data.hardcode.partial = -> text @partial.apply @, arguments

            data['partial'] = (args...) -> partialModule.partial.apply(this, args)

            #
            # Render the page
            #
            res.render page.view,
              data
            ,
              (err,list) ->
                renderCompleted err, list



        #
        # Start process
        #
        findPageLang( condition )

      #
      # Is page in cache ?
      #
      if __nodizeSettings.get 'page_cache_enabled'
        redisClient.get "page_cache:name:"+name, (err, page )->
          if err
            console.log err
          else if page isnt null
            #console.log "we got a cached page"
            res.send page
            return
          else
            startPageRendering()
      #
      # comment
      #
      else
        startPageRendering()

    catch err
      console.log "ctrl_page | Error while displaying page", err
      console.log err.stack


