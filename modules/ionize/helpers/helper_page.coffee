# Pages helpers, used to display info on pages
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
  # Defining helpers (like ionize tags, available in CoffeKup for views)

  #
  # Specific code for Jade, using filters
  #
  jade = require "jade"

  #*****
  #* Displaying pages, @pages array has to be sent with @render
  #* use @pages.title... in nested views (fields from page + page_lang tables)
  #* 
  #**
  @helpers['ion_pages'] = (args...) ->
    tagName = 'ion_pages'
    live = false
    scope = ''


    #
    # What page are we retrieving other pages from ?
    #    
    page_id = @page.id_page 

    #
    # Parsing attributes if they do exist
    #
    if args.length>1
      
      attrs = args[0]

      #
      # "Live" parameter, will allow to refresh article without reloading the page
      #      
      live = if attrs?.live then attrs.live else ""

      #
      # "Scope" parameter, allow to retrieve parent pages
      #      
      scope = if attrs?.scope then attrs.scope else ""
      if scope is 'parent' then page_id = @page.id_parent

      #
      # "from" parameter, allow to retrieve pages from any given page id
      #      
      if attrs?.from then page_id = attrs.from


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

    #
    # When connected with rights >= editors, offline pages are also displayed
    #
    if @req.session.usergroup_level > 1000
       isOnline = ""
    else
       isOnline = "page_lang.online = 1 AND "

    scopeClause = "page.id_parent = #{page_id} "

    page_search = "SELECT * FROM page, page_lang  "+
                  "WHERE page_lang.id_page = page.id_page AND "+
                  "page_lang.lang = '"+@lang+"' AND "+
                  isOnline+
                  scopeClause+
                  "ORDER BY page.ordering"    
    
    DB.query(  page_search
              , Page)
      .on 'success', (pages) =>
        #
        # Content that will be built and sent
        #
        htmlResponse = ""
        
        pageCount = 0        

        for page in pages
          pageCount++

          @page = page

          @page.index = pageCount
          @page.isFirst = if pageCount is 1 then true else false
          @page.isLast = if pageCount is page.length then true else false
          
          @page.url = @page.link if @page.link

          @page.date = if @page.logical_date isnt '' then @page.logical_date else @page.updated

          template = args[args.length-1]

          # Render nested tags
          if args.length>=1
            htmlResponse += "<span id='ion_livePage_#{@page.id_page}'>" if live
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

    

      