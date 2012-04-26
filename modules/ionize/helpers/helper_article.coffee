# Article helpers, used to display articles in view
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Copyright 2012, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#

@include = ->
  # Defining helpers (tags like, available in CoffeKup for views)
  
  #*****
  #* Displaying articles, @articles array has to be sent with @render
  #* use @articles.content... in nested views (fields from article_lang table)
  #* 
  #**
  @helpers['ion_articles'] = (args...) -> 
    tagName = 'ion_articles'
    from = ''
    type = ''
    live = false
    
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
    # When connected which right >= editors, offline articles are also displayed
    #

    if @req.session.usergroup_level > 1000
       isOnline = ""
    else
       isOnline = "page_article.online = 1 AND "


    if from isnt ''
      page_search = "SELECT * FROM article, article_lang, page_article, page "+
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
      page_search = "SELECT * FROM article, article_lang, page_article "+
                    fromType +
                    "WHERE article_lang.id_article = article.id_article AND "+
                    "article_lang.lang = '"+@lang+"' AND "+
                    "page_article.id_article = article.id_article AND "+
                    isOnline+
                    "page_article.id_page = #{@page.id_page} "+
                    whereType +
                    "ORDER BY page_article.ordering"
    

    DB.query(  page_search
              , Article)
      .on 'success', (articles) =>
        #
        # Content that will be built and sent
        #
        htmlResponse = ""
        
        articleCount = 0

        for article in articles          
          articleCount++

          @article = article

          @article.index = articleCount
          @article.isFirst = if articleCount is 1 then true else false          
          @article.isLast = if articleCount is articles.length then true else false

          if live
            @article.content = "<div class='ion_live_content'>" + @article.content + "</div>"

          # Render nested tags
          if args.length>=1
            htmlResponse += "<span id='ion_liveArticle_#{@article.id_article}'>" if live
            htmlResponse += yield args[args.length-1] # Compile the nested content to html            
            htmlResponse += "</span>" if live

        finished( htmlResponse )
      
      
      .on 'failure', (err) ->
        console.log "article request failed : ", err
        finished()
  
    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId}**}"     
        
  
  #*****
  #* Displaying article, using defined "block" (or "view")
  #* Basically calling the partial defined as "block"
  #* 
  #**
  @helpers['ion_article'] = (args...) -> 
    partial @article.view if @article.view

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
          #console.log @article.title
      
          # Render nested tags
          if args.length>=1 and imageCount>=first and (imageCount<=last or last is 0)
            htmlResponse += yield args[args.length-1] # Compile the nested content to html
            args[args.length-1]() 

        finished( htmlResponse )
      
      
      .on 'failure', (err) ->
        console.log "media request failed : ", err
        finished()
  
    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId}**}"
    
    
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
      
    

      