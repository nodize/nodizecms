#
# Nodize - navigation helpers
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Copyright 2012, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  
  jade = require "jade"


  #*****
  #* Displaying navigation
  #* use @navigation.fieldName in nested content,
  #* ie: @navigation.url, @navigation.title... (@navigation contains fields of the page_lang record)
  #*
  #* TODO: We should be able to cache the response in memory
  #* TODO: Attributes lastClass, firstClass
  #* TODO: filter by menu / page / subpage / type
  #*  
  #**  
  @helpers['ion_navigation'] = (args...) ->
    tagName = 'ion_navigation'     
    
    # default class when displaying current/active page
    activeClass = 'active'

    # default menu
    menu_id = 1 

    # default level
    page_level = 0

    #
    # Parsing attributes if they do exist
    #
    if args.length>1
      
      attrs = args[0]          
      #
      # Class to be used for current/active page
      #
      activeClass = attrs.activeClass if attrs.activeClass
    
      #
      # Menu to use
      #
      menu_id = attrs.menu_id if attrs.menu_id

      #
      # Page level
      #
      page_level = attrs.level if attrs.level

    
    #
    # We are launching an asynchronous request,
    # we need to register it, to be able to wait for it to be finished
    # and insert the content in the response sent to browser 
    #
    requestId = @registerRequest( tagName )

    #
    # Finished callback
    #
    finished = (response) =>
      @requestCompleted requestId, response

    displayedInNav = "page.appears = 1 AND "

    #
    #
    # Retrieve pages
    #
    DB.query( "SELECT page_lang.title, page_lang.subtitle, page_lang.url, page.home, page_lang.nav_title, page.link "+
              "FROM page_lang, page "+
              "WHERE page_lang.id_page = page.id_page AND "+
              "page_lang.lang = '#{@lang}' AND "+
              "page.id_menu = #{menu_id} AND "+
               displayedInNav +
              "page.level = #{page_level} "+
              "ORDER BY page.ordering", Page)
      .on 'success', (pages) =>

        #
        # Content that will be built
        #
        htmlResponse = ""

        #
        # Looping though all pages
        #
        for page in pages
          #console.log page.title, page.url
                 
          #
          # For home page, url becomes / (we hide the real url)
          #
          page.url = "/" if page.home          

          #
          # Set variables that will be used in the rendered view
          #
          @navigation = page
                             
          @navigation.title = @navigation.nav_title if @navigation.nav_title isnt ''
          @navigation.class = if @navigation.id_page is @page.id_page then activeClass else ''

          #
          # If a link is declared, we replace url by the link
          #
          if page.link then @navigation.url = page.link  
          
          #
          # Render nested tags, 
          # last args is the nested content to render
          #
          if args.length>=1    
            template = args[args.length-1] 

            # For Jade engine
            if @template_engine is "jade"              
              fn = jade.compile( template, @ )
              htmlResponse +=  fn( @ ) # Compile the nested content to html
            # For Eco and CoffeeCup
            else              
              htmlResponse += cede template # Compile the nested content to html                       
            #args[args.length-1]() 

        finished( htmlResponse )

      .on 'failure', (err) ->
        console.log "database error : ", err
        finished()

    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId.name}**}"


  #*****
  #* Displaying navigation tree
  #* use @navigation.fieldName in nested content,
  #* ie: @navigation.url, @navigation.title... (@navigation contains fields of the page_lang record)
  #*
  #* TODO: Menu selection by name, default to id = 1
  #* TODO: We should be able to cache the response in memory
  #* TODO: Attributes lastClass, firstClass
  #* TODO: Active class
  #*  
  #**  
  @helpers['ion_navigationTree'] = (args...) ->
    tagName = 'ion_navigationTree'     

    
    # default class when displaying current/active page
    activeClass = 'active'

    # default menu
    menu_id = 1 

    # default level
    page_level = 100
    
    level_open    = "<ul>"  # HTML inserted before each level change
    level_close   = "</ul>" # HTML inserted after each level change
    item_open     = "<li>"  # HTML inserted before each menu item
    item_close    = "</li>" # HTML inserted after each menu item

    #
    # Parsing attributes if they do exist
    #
    if args.length>1
      
      attrs = args[0]          
      #
      # Class to be used for current/active page
      #
      activeClass = attrs.activeClass if attrs.activeClass
    
      #
      # Menu to use
      #
      menu_id = attrs.menu_id if attrs.menu_id

      #
      # Page level
      #
      page_level = attrs.level if attrs.level?      

      #
      # Items & level HTML tags
      #
      level_open = attrs.level_open if attrs.level_open
      level_close = attrs.level_close if attrs.level_close
      item_open = attrs.item_open if attrs.item_open
      item_close = attrs.item_close if attrs.item_close
    
    #
    # We are launching an asynchronous request,
    # we need to register it, to be able to wait for it to be finished
    # and insert the content in the response sent to browser 
    #
    requestId = @registerRequest( tagName )

    #
    # Finished callback
    #
    finished = (response) =>
      @requestCompleted requestId, response


    #
    # Getting a list of pages, with child pages
    #
    # We're doing recursive calls to build the tree.
    # Recursion is a bit painful in async programming, so we use some tricks :
    # - request_counter is used to know when all request are finished, so we can build and sent the response
    # - we gather all responses and build a "path" value to be able to use it to sort results, in an order that matches the tree structure
    #     
    #
    
    #
    # Retrieve pages in menu 
    #
    
    responses = []
    #
    # Request counter is used to define when all async requests are finished
    # (+1 when launching a request, -1 once finishing, 0 everything is done)         
    #
    request_counter = 1
    
    #
    # Building the response path 
    #
    path = ""

    #
    # Send response once async requests are done
    #
    displayResponse = =>      
      request_counter--
      
      #
      # Requests are finished, building & sending the response
      #
      if request_counter==0        
        
        #
        # Sorting responses, using the path value
        #
        responses.sort( (a,b) ->          
          return 1 if a.path > b.path
          return -1 if a.path < b.path
          return 0
        )
        

        #
        # Building the response message
        #
        htmlResponse  = ""
        currentLevel  = 0
        firstResult   = true

        for line in responses
            #
            # For home page, url becomes / (we hide the real url)
            #
            line.url = "/" if line.home

            #
            # Set variables that will be used in the rendered view
            #
            @navigation = line
            
            @navigation.title = @navigation.nav_title if @navigation.nav_title isnt ''
            @navigation.class = if @navigation.id_page is @page.id_page then activeClass else ''                          

            levelChanged = false

            if @navigation.level > currentLevel
              htmlResponse += level_open
              currentLevel = @navigation.level
              levelChanged = true

            else if @navigation.level < currentLevel
              for index in [1..currentLevel-@navigation.level]
                htmlResponse += level_close
              currentLevel = @navigation.level
              levelChanged = true

            else 
              htmlResponse += item_close unless firstResult

            firstResult = false

            #
            # Render nested tags, 
            # last args is the nested content to render
            #
            if args.length>=1
              template = args[args.length-1] 

              htmlResponse += item_open
                                
              # For Jade engine
              if @template_engine is "jade"              
                fn = jade.compile( template, @ )
                htmlResponse +=  fn( @ ) # Compile the nested content to html
              # For Eco and CoffeeCup
              else              
                htmlResponse += cede template # Compile the nested content to html

              

            # response += "<option value='#{line.value}'>"          
            # response += "&#160;&#187;&#160;" for level in [1..line.level] unless line.level<1
            # response += "#{line.title}</option>"

        #
        # Send response
        #
        finished( htmlResponse )

    
    #
    # Recursive function to retrieve pages
    #
    getParents = (path, id_menu, id_parent, callback) =>
      #
      # Launch query
      # Sorry, not using Sequelize yet there, but should be used for compatibility with all supported DB engines  
      #
      DB.query( """
        SELECT 
          page_lang.title,
          page_lang.subtitle,
          page_lang.nav_title,
          page_lang.url,
          page.level,
          page.id_menu,
          page.id_page,
          page.home,
          page.online,
          page.appears,
          page.has_url,
          page.link

        FROM
          page_lang, page, menu
        WHERE
          page_lang.lang = '#{@lang}' AND 
          menu.id_menu = #{id_menu} AND 
          page.id_parent = #{id_parent} AND
          page_lang.id_page = page.id_page AND
          page.id_menu = menu.id_menu 
        ORDER BY 
          page.ordering
      """, 
      Page )
        #
        # On success, store results + launch additional recursive queries
        #
        .on 'success', (results) =>          
          index = 0
          for page in results
              index++
              newPath = path + index + "/"
                              
              #
              # Storing results in the responses array
              #
              currentResponse = {}
              currentResponse["path"]       = newPath
              currentResponse["value"]      = page.id_page
              currentResponse["title"]      = page.title
              currentResponse["subtitle"]   = page.subtitle
              currentResponse["nav_title"]  = page.nav_title
              currentResponse["level"]      = page.level
              currentResponse["url"]        = page.url
              currentResponse["has_url"]    = page.has_url
              currentResponse["home"]       = page.home
              currentResponse["id_page"]    = page.id_page
              currentResponse["online"]     = page.online
              currentResponse["link"]       = page.link
              
              #
              # If a link is declared, we replace url by the link
              #
              if page.link then currentResponse["url"] = page.link

              if (page.appears is 1) and (page.online or @req.session.usergroup_level >= 1000 )
                responses.push( currentResponse )

              #
              # Use to watch async queries termination
              #
              request_counter++
              
              #
              # Search for child pages of the current page
              #
              getParents( newPath, id_menu, page.id_page, callback )
              
          callback()

        .on 'failure', (err) ->
            console.log "GetParents error ", err
    
    #
    # Launch the first request
    #    
    getParents( path, 1, 0, displayResponse )      

    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId.name}**}"


