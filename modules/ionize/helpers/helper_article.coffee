# Article helpers, used to display articles in view
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Copyright 2012-2013, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#


@include = ->  
  # Defining helpers, available in templates
  # These helpers should work with Eco, CoffeeCup and Jade


  #
  # Specific code for Jade, using filters
  #
  jade = require "jade"

  # jade.filters.ion_articles = (block, options) ->        
  #   try      
  #     # Calling the regular helper
  #     @template_engine = "jade" 
  #     @ion_articles( "", block )
  #   catch error
  #     console.log "Template error : ", error
    

  #*****
  #* Displaying articles, @articles array has to be sent with @render
  #* use @articles.content... in nested views (fields from article_lang table)
  #* 
  #**
  @helpers['ion_articles'] = (args...) -> 
    tagName = 'ion_articles'    

    #
    # Parameters
    #
    from = '' 
    type = ''
    id = '' 
    live = false
    refresh = false
    params = {}    

    #
    # Parsing attributes if they do exist
    #
    if args.length>1
      
      attrs = args[0]
      
      #
      # "From" parameter, to select articles from another page 
      #
      from = if attrs?.from then attrs.from else ""
      
      #
      # "Type" parameter, to filter result by article type
      #      
      type = if attrs?.type then attrs.type else ""

      #
      # "Live" parameter, will allow to refresh article without reloading the page
      #      
      live = if attrs?.live then attrs.live else ""

      #
      # "Refresh" parameter, will allow to reload page when article is updated
      #      
      refresh = if attrs?.refresh then attrs.refresh else ""

      #
      # "Params" parameter, allows to send parameters for article rendering
      #      
      params = if attrs?.params then attrs.params else {}

      #
      # "Id" parameter, to select article by id 
      #
      id = if attrs?.id then attrs.id else ""

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
    
    if type isnt ''
      fromType = ", article_type "
      whereType = "AND page_article.id_type = article_type.id_type "+
                  "AND article_type.type = '#{type}' "
    else
      fromType = ""
      whereType = "AND (page_article.id_type is null OR page_article.id_type = 0) "

    #
    # Search on exact id
    #
    if id isnt ''
      whereType += "AND page_article.id_article = #{id} "

    #
    # When connected with right >= editors, offline articles are also displayed
    #

    if @req.session.usergroup_level > 1000
       isOnline = ""
    else
       isOnline = "page_article.online = 1 AND "    

    if from isnt ''
      page_search = "SELECT *, page_article.link as link, page_article.view as view FROM article, article_lang, page_article, page "+
                    fromType +
                    "WHERE article_lang.id_article = article.id_article AND "+
                    "article_lang.lang = '"+@lang+"' AND "+
                    "page_article.id_article = article.id_article AND "+
                    isOnline+
                    "page_article.id_page = page.id_page AND " +
                    "page.name = '#{from}' "+
                    whereType +
                    "ORDER BY page_article.ordering"
                    

    else
      page_search = "SELECT *, page_article.link as link, page_article.view as view FROM article, article_lang, page_article "+
                    fromType +
                    "WHERE article_lang.id_article = article.id_article AND "+
                    "article_lang.lang = '"+@lang+"' AND "+
                    "page_article.id_article = article.id_article AND "+
                    isOnline+
                    "page_article.id_page = #{@page.id_page} "+
                    whereType +
                    "ORDER BY page_article.ordering"
    
    #
    # Template compilation, depending on engine
    #
    compile = (engine, template) =>
      # For Jade engine
      if engine is "jade"
        fn = jade.compile( template, @ )
        return fn( @ ) # Compile the nested content to html
      # For Eco and CoffeeCup
      else
        return cede template # Compile the nested content to html

    DB.query(  page_search
              , Article)
      .on 'success', (articles) =>        
        #
        # Content that will be built and sent
        #
        htmlResponse = ""
        
        articleCount = 0

        @params = params

        template = args[args.length-1]

        #
        # Inserting template, used by real time updates
        #
#        @article = Article.build()
#        @article.createBlank()
#        @article.index = 0
#        @article.isFirst = false
#        @article.isLast = false
#        htmlResponse += "<script type='text/template' id='article'>"
#        htmlResponse += compile @template_engine, template
#        htmlResponse += "</script>"


        for article in articles          
          articleCount++

          @article = article

          @article.index = articleCount
          @article.isFirst = if articleCount is 1 then true else false          
          @article.isLast = (articleCount is articles.length)

          # Render nested tags
          if args.length>=1
            htmlResponse += "<span id='ion_liveArticle_#{@article.id_article}'>" if live
            htmlResponse += "<span id='ion_refreshArticle_#{@article.id_article}'>" if refresh  
            
            htmlResponse += compile @template_engine, template

            htmlResponse += "</span>" if live


           

        finished( htmlResponse )        
      
      
      .on 'failure', (err) ->
        console.log "article request failed : ", err
        finished()
  
    #
    # Inserting placeholder in the html for replacement once async request are finished
    #    
    text "{**#{requestId.name}**}"     
        
  
  #*****
  #* Displaying article, using defined "block" (or "view")
  #* Basically calling the partial defined as "block"
  #* 
  #**
  @helpers['ion_article'] = (args...) ->    

    # Jade engine
    if @template_engine is "jade"        
      tagName = 'ion_article'

      #
      # We are launching an asynchronous request,
      # we need to register it, to be able to wait for it to be finished
      # and insert the content in the response sent to browser 
      #
      requestId = @registerRequest( tagName )    
      
      #
      # On finished callback
      #
      finished = (response) =>        
        @requestCompleted requestId, response

      render = =>      
        # Render article view        
        template = "include #{@article.view}"
                      
        fn = jade.compile( template, @ )
        htmlResponse =  fn( @ ) # Compile the view to html                
        finished( htmlResponse )

      #
      # Doing asynchronous rendering      
      render()
      
      #
      # Inserting placeholder in the html for replacement once async request are finished
      #
      text "{**#{requestId.name}**}"



    # Using "partial" for .coffee templates
    else if partial?
      partial @article.view if @article.view
    # Using "@partial" for .eco templates
    else if @partial?
      @partial @article.view if @article.view
    

  #*****
  #* Displaying articles, @articles array has to be sent with @render
  #* use @articles.content... in nested views (fields from article_lang table)
  #* 
  #**
  @helpers['ion_medias'] = (args...) -> 
    tagName = 'ion_medias'

    #
    # Parameters
    #
    first = 1 # First image to use 
    last = 0 # Last image to use, 0 = all

    #
    # Parsing attributes if they do exist
    #
    if args.length>1
      
      attrs = args[0]          
      #
      # attributes are not used yet for this helper, "name" is just an example
      #
      first = if attrs?.first then attrs.first else 1
      last = if attrs?.last then attrs.last else 0

    #
    # We are launching an asynchronous request,
    # we need to register it, to be able to wait for it to be finished
    # and insert the content in the response sent to browser 
    #
    requestId = @registerRequest( tagName )    
    # console.log "Media aID", @article.id
    #
    # Finished callback
    #
    finished = (response) =>
      @requestCompleted requestId, response
    
    DB.query( "SELECT * FROM media, article_media "+
              "WHERE article_media.id_media = media.id_media AND "+              
              "article_media.id_article = #{@article.id_article} "+
              "ORDER BY article_media.ordering"
              , Media)
      .on 'success', (medias) =>
        #
        # Content that will be built and sent
        #
        htmlResponse = ""

        imageCount = 0        

        for media in medias
          imageCount++
          @media = media
          @media.index = imageCount
          @media.count = medias.length
      
          # Render nested tags
          if args.length>=1 and imageCount>=first and (imageCount<=last or last is 0)            
            template = args[args.length-1]            
                        
            # For Jade engine
            if @template_engine is "jade"              
              fn = jade.compile( template, @ )
              htmlResponse +=  fn( @ ) # Compile the nested content to html
            # For Eco and CoffeeCup
            else              
              htmlResponse += cede template # Compile the nested content to html 

        finished( htmlResponse )
      
      
      .on 'failure', (err) ->
        console.log "media request failed : ", err
        finished()
  
    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId.name}**}"
    

  #*****
  #* Displaying page title
  #* Returns window title if defined, else page title
  #* 
  #**  
  @helpers['ion_windowTitle'] = ->
    if @page_lang.meta_title isnt ''
      text @page_lang.meta_title
    else
      text @page_lang.title
      


      