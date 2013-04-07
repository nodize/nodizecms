# Page edition, controller
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
  Settings = @Settings

  #
  # PAGE LINKS
  #
  @post '/:lang/admin/page/get_link' : (req, res) =>
    values = req.body

    # Retrieve page_id from parameter in URL
    findPage = ->      
      Page.find( {where: {id_page:values.id_page} } )
        .on 'success', (page) ->
          if page
            renderView( page )
          else
            res.send "page #{page_id} not found"
    
    renderView = (page) ->
      #
      # Display the link edition view
      #
      res.render "backend_getLink",
        layout        : no        
        page          : page
        link          : page.link
        hardcode      : @helpers 
        lang          : req.params.lang
        ion_lang      : ion_lang[ req.params.lang ] 
        settings      : Settings
        parent        : 'page'        
    #
    # Start process
    #
    findPage()

  #
  # Adding a link
  #
  # @param post.link_rel = destination
  # @param post.receiver_rel  
  # @param post.link_type = "page" | ... 
  @post '/:lang/admin/page/add_link' : (req, res) =>
    values = req.body

    callback = (err, page) =>
      message = 
      message_type:""
      message:""
      update:[]
      callback:[
        fn:"ION.HTML"
        args:[
          "page\/\/get_link"
        ,
          id_page:page.id_page
        ,
          update:"linkContainer"
        ]
      ,
        fn:"ION.notification"
        args:[
          "success"
          "Link added"
        ]
      ]

      res.send message

    #
    # Start link addition
    #
    Page.addLink( values, callback )
    
  #
  # Removing a link
  #
  # @param post.rel = id_page
  @post '/:lang/admin/page/remove_link' : (req, res) =>
    values = req.body

    callback = (err, page) =>
      if err
        console.log "Error on link removal", err
      else
        message =
        message_type:""
        message:""
        update:[]
        callback:[
          fn:"ION.HTML"
          args:[
            "page\/\/get_link"
          ,
            id_page:page.id_page
          ,
            update:"linkContainer"
          ]
        ]

        res.send message

    #
    # Start link deletion
    #
    Page.removeLink( values, callback )

  #
  # EDITING a page
  #
  @get "/:lang/admin/page/edit/:ids" : (req, res) ->
    # File containing views definition (page/blocks)
    viewsParamFile = __applicationPath+'/themes/'+__nodizeTheme+"/settings/views.json"

    params = req.params.ids.split "."
    page_id = params[0]
    views = ''

    #
    # Loading theme views
    #
    loadViews = ->
      fs = require 'fs'
      fs.readFile viewsParamFile, (err, data) ->
        if err
          res.send "Views definition not found"
        else
          views = JSON.parse( data )
          findPage()

    # Retrieve page_id from parameter in URL
    findPage = ->      
      Page.find( {where: {id_page:page_id} } )
        .on 'success', (page) ->
          if page
            findPageLang( page )
          else
            res.send "page #{page_id} not found"
                      
    findPageLang = (page)->      
      # Search page_lang & render
      Page_lang.findAll( {where: {id_page:page.id_page} } )      
        .on 'success', (page_langs)->        
          if page_langs

            #
            # Put page_langs in an array for easier use in the view
            #
            page_by_lang = []

            # Creating an empty entry for each lang
            for lang in Static_langs
              page_by_lang[ lang ] = ""
            
            # Filling with values from database for existing translations
            for page_lang in page_langs                    
              page_by_lang[ page_lang.lang ] = page_lang
                        
            renderView( views, page, page_by_lang )

          else
            res.send "page_lang #{page_id} not found"

    renderView = (views, page, page_by_lang) ->
      #
      # Find menus
      #
      Menu.findAll()
        .on 'success', (menus) ->
          #
          # Display the page edition view 
          #
          res.render "view_backend_page",
              layout        : no 
              page_id       : page_id
              page          : page
              page_by_lang  : page_by_lang
              settings      : Settings
              lang          : req.params.lang
              ion_lang      : ion_lang[ req.params.lang ]                            
              views         : views
              menus         : menus          
          
        .on 'failure', (err) ->
          console.log 'database error ', err

    loadViews()
    

  #
  # CREATING a page
  #
  @get "/:lang/admin/page/create/:id" : (req, res) =>
    # Menu in which we want to create a page
    menu_id = req.params.id

    #
    # Create an empty page object
    #
    page = Page.build() 
    page.createBlank()

    #
    # Put page_langs in an array for easier use in the view
    #
    page_by_lang = []

    # Creating an empty entry for each lang
    for lang in Static_langs
      page_by_lang[ lang ] = Page_lang.build()
      page_by_lang[ lang ].createBlank()
        
    #
    # Loading theme views
    #
    loadViews = ->
      # File containing views definition (page/blocks)
      viewsParamFile = __applicationPath+'/themes/'+__nodizeTheme+"/settings/views.json"

      fs = require 'fs'
      fs.readFile viewsParamFile, (err, data) ->
        if err
          res.send "Views definition not found"
        else
          views = JSON.parse( data )
          renderView( views )

    renderView = (views) ->
      #
      # Find menus
      #
      Menu.findAll()
        .on 'success', (menus) ->
          #
          # Display the page edition view 
          #
          res.render "view_backend_page",
            layout        : no
            menu_id       : menu_id
            page          : page
            page_by_lang  : page_by_lang          
            hardcode      : @helpers 
            lang          : req.params.lang
            ion_lang      : ion_lang[ req.params.lang ] 
            menus         : menus
            settings      : Settings
            views         : views
          
        .on 'failure', (err) ->
          console.log 'database error ', err
    
    #
    # Start process
    #  
    loadViews()
  
  #
  # SAVING a page
  #  
  @post '/:lang/admin/page/save' : (req, res) =>
    values = req.body
    requestCount = 0
    
    saveNewPage = (page) ->
      page.publish_on = null if page.publish_on is ''
      page.publish_off = null if page.publish_off is ''
      page.logical_date = null if page.logical_date is ''

      #
      # Saving PAGE
      #
      page.save()
        .on 'success', (page) ->
          #
          # Copying id_page to id  
          #          
          DB.query( "UPDATE page SET id = id_page WHERE id_page = #{page.id_page}")
          
          #
          # We launch as many requests as existing langs
          #
          requestCount += Static_langs.length 
          
          for lang in Static_langs
              #
              # Creating PAGE_LANG record
              #
              createPageLang( page, page.id_page, lang )            

        .on 'failure', (err) ->
          console.log 'PAGE save failed : ', err
          res.send "Save failed"

    #
    # Creating page_lang record
    #   
    createPageLang = ( page, id_page, lang ) =>
      # Create "article_lang" object & define values
      page_lang = Page_lang.build()
      page_lang.lang = lang
      page_lang.url = values['url_'+lang]
      page_lang.id_page = id_page
      page_lang.title = values['title_'+lang]
      page_lang.subtitle = values['subtitle_'+lang]
      page_lang.online = if Static_langs.length is 1 then page.online else values['online_'+lang]
      page_lang.link = ""
      page_lang.meta_title = values['meta_title_'+lang]
      page_lang.nav_title = values['nav_title_'+lang]
      page_lang.subnav_title = "" 
      page_lang.home = page.home      

      #
      # Save record to database
      #
      page_lang.save()
        .on 'success', (page_lang) =>
          requestCount--

          if requestCount is 0
            #
            # Building JSON response
            # - Notification
            # - Redirect main panel to page edit
            # - Insert page in the tree
            #  

            #
            # Get menu name & build message
            #
            Menu.find({where:{id_menu:page.id_menu}})
              .on 'success', (menu) ->                
              
                message =  
                  message_type  : "success"
                  message       : "Page saved"
                  
                  update        : [
                    element : "mainPanel"
                    url     : 'page\/\/edit\/'+page_lang.id_page
                    title   : "Page edit"
                  ]
                  
                  callback      : 
                    fn    : menu.name + "Tree.insertElement"
                    args  : [
                      title     : page.name
                      id_page   : page_lang.id_page
                      name      : page_lang.name
                      online    : page_lang.online                  
                      id_parent : page.id_parent
                      id_menu   : page.id_menu
                      level     : "0"
                      home      : "0"
                      menu      :
                        id_menu   : page.id_menu
                        name      : page_lang.name
                        title     : page_lang.title
                        ordering  : "1"
                      'page'
                    ]
                            
                
                #
                # Send response to client
                #
                res.send message
                
                #
                # Inform modules that a new page has been created
                __nodizeEvents.emit  'pageSave', 'page created'

              .on 'failure', (err) ->
                console.log 'database error ', err
            
          
        .on 'failure', (err) ->
          console.log 'save failed : ', err

    #
    # Start process
    #
    if values.id_page and values.id_page isnt ''
      pageLangUpdate = (page, lang) =>
        #
        # UPDATING PAGE_LANG
        #
        Page_lang.find({where: {id_page:values.id_page, lang:lang}})
          .on 'success', (page_lang)=>
            if page_lang
              page_lang.title = values['title_'+lang]
              page_lang.subtitle = values['subtitle_'+lang]
              page_lang.url = values['url_'+lang]
              page_lang.online = values['online_'+lang]
              page_lang.meta_title = values['meta_title_'+lang]
              page_lang.nav_title = values['nav_title_'+lang]
              page_lang.home = values['home'] 
              
              page_lang.save()
                .on 'success', (page_lang) =>

                  requestCount--

                  if requestCount is 0
                    message = 
                      message_type:""
                      message:""
                      update:[]
                      callback:[
                        fn:"ION.notification"
                        args:["success","Page saved"]
                      ,                
                        fn:"ION.updateElement"
                        args:
                          element:"mainPanel"
                          url:"page\/\/edit\/"+page_lang.id_page
                      ]
                      id: page_lang.id_page
                  
                    
                    res.send message
                  
                    # 
                    # Inform modules that a page has been modified
                    #
                    __nodizeEvents
                      .emit  'pageSave', 'begin save'
            else
              console.log "PageLang not found, creating it"
              createPageLang( page, values.id_page, lang )

                                     
          .on 'failure', (err) ->
            console.log 'fail to save page: ', err
      
      #
      # UPDATING an existing PAGE
      #
      
      #
      # Reset "Is home page" status for other pages
      #
      DB.query( 'UPDATE page SET home=0 WHERE home=1') if values.home

      saveExistingPage = (page) ->
        page.publish_on = null if page.publish_on is ''
        page.publish_off = null if page.publish_off is ''
        page.logical_date = null if page.logical_date is ''

        page.save()
          .on 'success', (page) =>

            requestCount += Static_langs.length 
            for lang in Static_langs                
              pageLangUpdate(page,lang)
                                 
          .on 'failure', (err) ->
            console.log 'fail to save page: ', err

      Page.find({
        where: {id_page:values.id_page}
      }).on 'success', (page)=>
          __nodizeEvents.emit  'pageSave', 'save'          
          
          page.home = if values.home then values.home else 0
          page.view = values.view
          page.id_parent = values.id_parent
          page.appears = values.appears
          page.has_url = values.has_url
          page.name = values.page_name
          page.updated = new Date            
          page.publish_on = values.publish_on
          page.publish_off = values.publish_off
          page.logical_date = values.logical_date             
          

          if values.id_parent == "0"
            page.level = 0        
            saveExistingPage( page )        
          else
            Page.find( {where:{id_page:values.id_parent}})
              .on "success", (parent_page) ->
                page.level = parent_page.level+ 1
                saveExistingPage( page )
              .on "failure", (err) ->
                console.log "Error when retrieving parent page's level"
                page.level = 1
                saveExistingPage( page )
          
          

    else
      #
      # CREATING a new PAGE record
      #
      page = Page.build()
      page.name = values.url_en
      page.id_menu = values.id_menu
      page.id_parent = values.id_parent
      page.id_subnav = 0
      page.online = values.online 
      page.home = if values.home then values.home else 0
      page.order = 0 # TODO: we probably should use max order + 1
      page.article_order = 0
      page.article_order_direction = 0
      page.link_id = 0
      page.pagination = values.pagination | -1
      page.pagination_nb = 0
      page.id_group = values.id_group | -1
      page.priority = values.priority | -1
      page.view = values.view
      page.appears = values.appears
      page.has_url = values.has_url
      page.created = new Date
      page.updated = new Date
      page.publish_on = values.publish_on or ""
      page.publish_off = values.publish_off
      page.logical_date = values.logical_date

      #console.log "ctrl_page | new page", page


      if values.id_parent == "0"
        page.level = 0        
        saveNewPage( page )        
      else
        Page.find( {where:{id_page:values.id_parent}})
          .on "success", (parent_page) ->
            page.level = parent_page.level+ 1
            saveNewPage( page )
          .on "failure", (err) ->
            console.log "Error when retrieving parent page's level"
            page.level = 1
            saveNewPage( page )
      

     

  #
  # Getting a list of pages, with child pages
  #
  # We're doing recursive calls to build the tree.
  # Recursion is a bit painful in async programming, so we use some tricks :
  # - request_counter is used to know when all request are finished, so we can build and sent the response
  # - we gather all responses and build a "path" value to be able to use it to sort results, in an order that matches the tree structure
  # 
  # Good luck reading this code ;) I'll be happy to receive any simplification / optimization tips
  #
  #
  # PAGES LIST, PARENT SELECTION for page/article  
  #
  @post '/:lang/admin/page/get_parents_select/:id_menu/:id_current/:id_parent' : (req, res) ->
    #
    # Retrieve pages in menu 
    #    
    @responses = []
    
    #
    # Request counter is used to define when all async requests are finished
    # (+1 when launching a request, -1 once finishing, 0 everything is done)         
    #
    @request_counter = 1
    
    #
    # Building the response path 
    #
    path = ""

    #
    # Send response once async requests are done
    #
    displayResponse = (responses) =>
      @request_counter--
      
      #
      # Requests are finished, building & sending the response
      #
      if @request_counter==0        
        #
        # Building the <select> tag
        #
        response = buildMenuSelect( responses, @params.id_current, @params.id_parent )
        #
        # Send response
        #
        res.send response
    
    #
    # Launch the first request
    # Callback is "displayResponse"
    #    
    getParentPages( @, path, req.params.id_menu, 0, req.params.lang, @params.id_current, displayResponse )

  #
  # PAGE ORDERING
  #
  @post '/:lang/admin/page/save_ordering' : (req, res) =>
    values = req.body
    
    id_pages = values.order.split( "," )
    
    index = 0
    requestCount = 0
    
    for id_page in id_pages
      requestCount++
      
      DB.query( "UPDATE page SET ordering=#{index} WHERE id_page=#{id_page}")
        .on 'success', ->
          requestCount--
          
          if requestCount is 0
            message =  
              message_type  : "success"
              message       : "Pages ordered !"              
              update        : [                
              ]              
              callback      : null

            res.send message

        .on 'failure', (err) ->
          message =  
              message_type  : "error"
              message       : "Error during ordering process"              
              update        : [                
              ]              
              callback      : null
                        
          res.send message
    
      index++

  #
  # GET ARTICLES LINKED TO THE PAGE
  #
  @post '/:lang/admin/article/get_list' : (req, res) ->
    # File containing views definition (page/blocks)
    viewsParamFile = __applicationPath+'/themes/'+__nodizeTheme+"/settings/views.json"

    id_page = req.body.id_page    
    views = ''
    types = ''
    blocks = []

    #
    # Loading theme views
    #
    loadViews = ->
      fs = require 'fs'
      fs.readFile viewsParamFile, (err, data) ->
        if err
          res.send "Views definition not found"
        else
          views = JSON.parse( data )
          
          # Sorting blocks
          for key, value of views.blocks
            item = []
            item.file = key
            item.name = value

            blocks.push( item )
            
          blocks = blocks.sort (a, b) ->
            return a.name.localeCompare(b.name)

          loadTypes()

    # Retrieve id_page from parameter in URL
    loadTypes = ->      
      Article_type.findAll( {order:'type'} )
        .on 'success', (article_types) ->
          if article_types
            types = article_types
            findPage()
          else
            res.send "types not found"
        .on 'failure', (err) ->
          console.log "database error ", err


    # Retrieve id_page from parameter in URL
    findPage = ->      
      Page.find( {where: {id_page:id_page} } )
        .on 'success', (page) ->
          if page
            findPageArticles( page )
          else
            res.send "page #{id_page} not found"
        .on 'failure', (err) ->
          console.log "database error ", err
                      
    findPageArticles = (page)->      
      # Search page_lang & render
      DB.query( """
        SELECT * FROM page_article, article
        LEFT JOIN article_lang
        ON article_lang.id_article = article.id_article AND article_lang.lang = '#{req.params.lang}'

        WHERE 
          article.id_article = page_article.id_article  AND          
          page_article.id_page = #{page.id_page}
        ORDER BY 
          page_article.ordering
      """, Article )      
        .on 'success', (articles)->        
          if articles
            res.render "backend_pageArticleList",
              layout    : no 
              page      : page
              articles  : articles
              settings  : Settings
              lang      : req.params.lang
              ion_lang  : ion_lang[ req.params.lang ]              
              views     : views
              blocks    : blocks
              types     : types
          else
            res.send "articles on page #{page_id} not found"
        .on 'failure', (err) ->
          console.log "database error ", err

    loadViews()

  
  #
  # PAGE SWiTCHING ONLINE STATUS
  #
  @post '/:lang/admin/page/switch_online/:id_page' : (req, res) ->
    data = {id_page:@params.id_page}
    Page.switch_online data, (err,page) ->
      unless err
        message = 
          message_type:"success"
          message:"Operation OK"
          update:[]
          callback:[
            fn:"ION.switchOnlineStatus"
            args:
              status:page.online
              selector:".page"+page.id_page
          ]

        res.send( message )


  #
  # PAGE DELETION
  #
  # TODO: Also remove page medias (see in model)
  #
  @post '/:lang/admin/page/delete/:id_page' : (req, res) ->
    Page.delete {id_page:@params.id_page}, (err) ->
      unless err  
        message = 
          message_type:"success"
          message:"Page deleted"
          update:[]
          callback:[
            fn:"ION.deleteDomElements"
            args:
              ".page"+req.params.id_page
            
          ,
            fn:"ION.updateElement"
            args:
              element:"mainPanel"
              url:"dashboard"
          ]

        res.send message


  #
  # Recursive function to retrieve pages
  #
  getParentPages = (context, path, id_menu, id_parent, lang, currentPageId, callback) =>    
    #
    # Launch query
    # Not using Sequelize yet there, but should be used for compatibility with all supported DB engines  
    #
    DB.query( """
      SELECT 
        page_lang.title,
        page.level,
        page.id_menu,
        page.id_page
      FROM
        page_lang, page, menu
      WHERE
        page_lang.lang = '#{lang}' AND 
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
            currentResponse["path"] = newPath;
            currentResponse["value"] = page.id_page;
            currentResponse["title"] = page.title;
            currentResponse["level"] = page.level;
                          
            context.responses.push( currentResponse ) if page.id_page.toString() isnt currentPageId

            #
            # Use to watch async queries termination
            #
            context.request_counter++
            
            #
            # Search for child pages of the current page
            #
            getParentPages( context, newPath, id_menu, page.id_page, lang, currentPageId, callback )
            
        callback( context.responses )

      .on 'failure', (err) ->
          console.log "GetParents error ", err

  buildMenuSelect = (responses, id_current, id_parent ) =>
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
    response = "<option value='0'"+(if id_current is '0' then " selected='selected'" else "")+">/</option>"
  
    for line in responses                    
        response += "<option value='#{line.value}'"+(if id_parent is line.value.toString() then " selected='selected'" else "")+">"          
        response += "&#160;&#187;&#160;" for level in [1..line.level] unless line.level<1
        response += "#{line.title}</option>"

    return response
