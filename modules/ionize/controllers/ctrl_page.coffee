@include = ->

  #
  # Needed for CoffeKup's helpers compatibility with Eco template engine
  #
  global.text = (value) -> value
  global.yield = (content) -> content()

  #*****
  #* DEFAULT HANDLER, DISPLAYING PAGE FROM DATABASE
  #*
  #**
  @ionize_displayPage = (req, helpers, name) ->  
    #console.log req.request.headers["accept-language"]
    
    #console.log req.params
    
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
        req.redirect( name )
        return
        
      name = segments[0]
      req.params[0] = name
    else
      lang = Static_lang_default
    

    startTime = Date.now()
    #
    # Requesting home page if url = "/"    
    #
    if req.request.url is '/'      
      condition = {home : 1, lang:lang }
    else
      condition = {url : name, lang:lang }

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
      # Rebuild the response
      #
      for chunk in chunks
        layout = layout.replace( '{**'+chunk.requestId+'**}', chunk.content )

      req.send layout

    #
    # Registering a request (main layout and Nodize helpers)
    #
    registerRequest =  (requestName) ->
      #console.log "registering ",requestName
      requestCounter++
      requestId++
      requestName+'_'+requestId # Building & returning an id name

    #
    # Callback for when a Nodize helpers has finished rendering
    #
    requestCompleted = (requestId, response) ->
      #console.log "request completed ",requestId
      requestCounter--
      #console.log "req completed ", requestCounter
      #console.log "res response ", response
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
      #console.log "render completed ", requestCounter
      #console.log "rendering response ----------------- \r\t"

      #
      # Storing the main layout
      #
      if err        
        console.log err
        layout = err.toString()
      else
        layout = list
      
      if requestCounter is 0
        sendResponse()

    #*****
    #* Step 1 retrieve page_lang using the page name
    #*
    #**
    Page_lang.find( {where: condition } )
    #Page.findAll( )
      .on 'success', (page)->
        if page?
          findPage( page )
        else
          req.send "page #{name} not found", 404

    findPage = (page_lang) ->
      Page.find({where:{id_page:page_lang.id_page}})
        .on 'success', (page) ->
          #
          # Rendering /views/page.coffee          
          #
          registerRequest "main"
          
          page.view = "page_default" if page.view is null

          page.title = page_lang.title          
          
          data =
            hardcode  : helpers              
            page      : page
            page_lang : page_lang
            lang      : lang             
            layout    : no
            req       : req
            registerRequest : registerRequest
            requestCompleted : requestCompleted
          

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
            do (helper) ->
              data[helper] = (args...) -> @hardcode[helper].apply(this, args)

          #
          # Render the page
          #
          req.render page.view,
            data
          ,
            (err,list) ->
              renderCompleted err, list 
                  
        .on 'failure', ->            
          #
          # No article found, rendering the empty page  
          #
          registerRequest "main"

          req.render 'page_default',
            hardcode  : helpers              
            page      : page
            page_lang : page_lang              
            layout    : no
            registerRequest : registerRequest
            requestCompleted : requestCompleted
          ,
            (err,list) ->
              renderCompleted err, list 
