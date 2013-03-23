# Articles controller
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  Settings = @Settings

  #
  # GENERIC FUNCTIONS
  #
  # Return file extension
  # @param {string} file name
  # @return {string} file extension, without the .
  getExt = (filename) ->
    ext = filename.split('.').pop();
    if ext == filename
      ''
    else
      ext

  @on 'test': ->
    console.log "test event received"
  
  @client '/socket.js': ->
    @connect()

    #
    # Test event, received on new image url from Pixlr
    # We try to remove the Pixlr overlay
    #
    # TODO: download & replace the new file, securize w/ token, limit event to current & correct user
    # TODO: save/move/replace file & reload medias, replace emit by broadcast... 
    @on testEvent: ->
      #
      # Refresh images list
      #
      mediaManager.loadMediaList('picture') 
      
      #
      # Hide PIXLR overlay
      #
      pixlr.overlay.hide()


      
  
  #
  # ARTICLES LIST + TYPES SETTINGS + CATEGORIES SETTINGS
  #
  @get "/:lang/admin/article/list_articles" : (req,res) =>
    res.render 'backend_articleList',
      hardcode    : @helpers
      layout      : no 
      lang        : req.params.lang
      ion_lang    : ion_lang[ req.params.lang ]
      assetsPath  : @Settings['assetsPath']

  #
  # ARTICLES LIST TOOLBOX
  #
  @get "/:lang/admin/desktop/get/toolboxes/articles_toolbox" : (req, res) =>
    res.render 'backend_articleListToolbox',
      hardcode    : @helpers
      layout      : no 
      lang        : req.params.lang
      ion_lang    : ion_lang[ req.params.lang ]
      assetsPath  : @Settings['assetsPath']


  #
  # ARTICLE create new
  #
  @get '/:lang/admin/article/create/:id_page' : (req,res) ->
    #
    # Creating a blank article
    #
    article = Article.build() #.createBlank()
    article.createBlank()
    
    #
    # Creating an empty article_lang for each available language
    #
    article_by_lang = []
    for lang in Static_langs
      article_by_lang[ lang ] = Article_lang.build()
      article_by_lang[ lang ].createBlank()


    views = {}
    blocks = []

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

           # Sorting blocks
          for key, value of views.blocks
            item = []
            item.file = key
            item.name = value

            blocks.push( item )
            
          blocks = blocks.sort (a, b) ->
            return a.name.localeCompare(b.name)

          loadPage()

    #
    # Load article's PARENT PAGE
    #
    loadPage = ->
      Page.find({where:{id_page:req.params.id_page}})
        .on 'success', (page) ->          
          loadCategories( page )
          
        .on 'failure', (err) ->
          console.log 'database error ', err
      

    #
    # Load categories
    #
    loadCategories = (page) ->
      Category.findAll( {order:'name'})
        .on 'success', (categories) ->
          res.render "view_backend_article",
            layout              : no             
            article             : article            
            article_by_lang     : article_by_lang
            categories          : categories
            lang                : req.params.lang      
            ion_lang            : ion_lang[ req.params.lang ]
            page                : page
            views               : views
            blocks              : blocks
            pixlr_target        : __nodizeSettings.get("pixlr_callback_server") + __nodizeSettings.get("pixlr_callback_url")

          
        .on 'failure', (err) ->
          console.log 'database error ', err
    
    loadViews()

  #
  # ARTICLE EDIT
  #
  @get "/:lang/admin/article/edit/:ids" : (req, res) ->
    #
    # Retrieve page_id & article_id from parameters in URL
    #
    params = req.params.ids.split "."
    id_page = params[0]
    id_article = params[1]
    parent_page = null
    page_article = null
    views = {}
    blocks = []

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

          # Sorting blocks
          for key, value of views.blocks
            item = []
            item.file = key
            item.name = value

            blocks.push( item )
            
          blocks = blocks.sort (a, b) ->
            return a.name.localeCompare(b.name)

          loadPage()

    #
    # Load article's PARENT PAGE
    #
    loadPage = ->
      Page.find({where:{id_page:id_page}})
        .on 'success', (page) ->          
          parent_page = page                         
          loadPageArticle()
          
        .on 'failure', (err) ->
          console.log 'database error ', err

    #
    # Load article's PARENT PAGE_ARTICLE
    #
    loadPageArticle = ->
      Page_article.find({where:{id_page:id_page, id_article:id_article}})
        .on 'success', (record) ->          
          page_article = record                         
          loadArticle()
          
        .on 'failure', (err) ->
          console.log 'database error ', err
    
    #
    # Retrieve article 
    #
    loadArticle = ->    
      Article.find({where:{id_article:id_article}})
        .on 'success', (article) ->        
          findArticleLang( article )
        .on 'failure', (err) ->
          console.log 'database error ', err
      
      
    #
    # Retrieve langs
    #
    findArticleLang = (article) ->
      sanitize = require('validator').sanitize
      # Search article & render page
      Article_lang.findAll( {where: {id_article:id_article} } )
        .on 'success', (article_langs)=>
          #
          # Put article_langs in an array for easier use in the view
          #
          article_by_lang = []

          # Creating an empty entry for each lang
          for lang in Static_langs
            article_by_lang[ lang ] = ""
          
          # Filling with values from database for existing translations
          for article_lang in article_langs              
            article_by_lang[ article_lang.lang ] = article_lang
            article_by_lang[ article_lang.lang ].content = sanitize( article_by_lang[ article_lang.lang ].content ).entityEncode()
            article_by_lang[ article_lang.lang ].title = sanitize( article_by_lang[ article_lang.lang ].title ).entityEncode()

          if article_langs
            loadArticleCategories( article, article_by_lang )
          else
            res.send "article #{id_article} not found"

    #
    # Load categories linked to article
    #
    loadArticleCategories = (article, article_by_lang) ->
      Article_category.findAll({where:{id_article:id_article}})
        .on 'success', (article_categories) ->
          article_categories_array = []
          for article_category in article_categories
            article_categories_array.push article_category.id_category

          loadCategories( article, article_by_lang, article_categories_array )
                    
        .on 'failure', (err) ->
          console.log 'database error ', err
      

    #
    # Load categories
    #
    loadCategories = (article, article_by_lang, article_categories) ->
      Category.findAll( {order:'name'})
        .on 'success', (categories) ->
          
          res.render "view_backend_article",
            layout              : no 
            page                : parent_page
            page_article        : page_article
            article             : article            
            article_by_lang     : article_by_lang
            article_categories  : article_categories
            categories          : categories
            lang                : req.params.lang      
            ion_lang            : ion_lang[ req.params.lang ]
            views               : views
            blocks              : blocks
            pixlr_target        : __nodizeSettings.get("pixlr_callback_server") + __nodizeSettings.get("pixlr_callback_url")
          
        .on 'failure', (err) ->
          console.log 'database error ', err
    
    #
    # Start process
    #
    loadViews()
    
  #
  # ARTICLE SAVE
  #
  @post '/:lang/admin/article_save' : (req, res) ->
    values = req.body    

    requestCount = 0
    

        
    if values.id_article and values.id_article isnt ''
      # --------------------------------------
      # Updating article
      # --------------------------------------

      #
      # Load article's PARENT PAGE_ARTICLE
      #  
      Page_article.find({where:{id_page:values.main_parent, id_article:values.id_article}})
        .on 'success', (page_article) ->          
          page_article.view = values.view

          #
          # Save updated page_article 
          #
          page_article.save()
            .on 'success', (page_article) ->
              articleUpdate()
            .on 'failure', (err) ->
              console.log 'database error ', err
                    
        .on 'failure', (err) ->
          console.log 'database error ', err

      #
      # Article update
      #
      articleUpdate = ->


        Article.find({where:{id_article:values.id_article}})
          .on 'success', (article) ->
            article.updated = new Date            
            
            article.publish_on = if values.publish_on is '' then null else values.publish_on
            article.publish_off = if values.publish_off is '' then null else values.publish_off
            article.logical_date = if values.logical_date is '' then null else values.logical_date
            
            article.has_url = values.has_url

            article.name = values['url_'+Static_lang_default]
            
            
            article.save()
              .on 'success', (article) ->
                # We will send as many async requests than existing langs
                requestCount += Static_langs.length 
                for lang in Static_langs
                  articleLangUpdate( lang )
              .on 'failure', (err) ->
                console.log 'database error ', err
          .on 'failure', (err) ->
            console.log 'database error ', err
        
      #
      # Creating article_lang record
      # Creation will happen when a new lang is added after article creation
      #   
      createArticleLang = ( lang) ->
        # Create "article_lang" object & define values
        article_lang = Article_lang.build()
        article_lang.lang = lang
        article_lang.url = values['url_'+lang ] or ""
        article_lang.id_article = values.id_article
        article_lang.content = values['content_'+lang]
        article_lang.online = values['online_'+lang] or 0
        article_lang.title = values['title_'+lang]        
        article_lang.subtitle = values['subtitle_'+lang] or ""
        article_lang.summary = values['summary_'+lang] or ""
         
        # Save to database
        article_lang.save()
          .on 'success', (article_lang) ->
                
            requestCount--

            if requestCount is 0
              message = 
                message_type:""
                message:""
                update:[]
                callback:[
                  fn:"ION.notification"
                  args:["success","Article saved"]
                ,                
                  fn:"ION.updateElement"
                  args:
                    element:"mainPanel",
                    url:"article\/\/edit\/"+values.main_parent+"."+article_lang.id_article
                ]
                id: article_lang.id
            
              res.send message
              #
              # Inform modules that a new page has been created
              __nodizeEvents.emit  'articleCreate', 
                article : article_lang
                parent : values.main_parent
              
            # res.send '{"message_type":"","message":"","update":[],"callback":[{"fn":"ION.updateElement","args":{"element":"mainPanel","url":"article\\\/'+'edit\/'+values.rel+'"}},{"fn":"ION.notification","args":["success","Article saved"]},{"fn":"ION.updateArticleContext","args":[[{"logical_date":"0000-00-00 00:00:00","lang":"en","url":"welcome-article-url","title":"Welcome to Ionize","subtitle":"","meta_title":"","summary":"","content":"For more information about building a website with Ionize, you can:\\n\\nDownload &amp; read the Documentation\\nVisit the Community Forum\\n\\nHave fun !","meta_keywords":"","meta_description":"","online":"1","id_page":"2","view":"","ordering":"2","id_type":"","link_type":"","link_id":"","link":"","main_parent":"1","type_flag":""}]]}],"id":"'+article_lang.id+'"}'
          .on 'failure', (err) ->
            console.log 'fail : ', err

      #
      # Updating article_lang
      #
      articleLangUpdate = (lang) ->
        #
        # Updating an existing article
        #
        Article_lang.find({
          where: {id_article:values.id_article, lang:lang}
        }).on 'success', (article_lang)->   
            if article_lang                  

              article_lang.content = values['content_'+lang]
              article_lang.title = values['title_'+lang]
              article_lang.subtitle = values['subtitle_'+lang] or ""
              article_lang.online = values['online_'+lang]
              article_lang.summary = values['summary_'+lang] or ""       

              article_lang.save()
                .on 'success', (article_lang) =>
                  
                  requestCount--

                  if requestCount is 0
                    message = '{"message_type":"", "message":"","update":[],  '+
                    '"callback":['+
                      '{"fn":"ION.notification","args":["success","Article saved"]},'+                
                      '{"fn":"ION.updateElement","args":{"element":"mainPanel","url":"article\/\/edit\/'+values.main_parent+"."+article_lang.id_article+'"}}'+
                    '],'+
                    '"id":"'+article_lang.id+'"'+'}'
                  
                    res.send message
                    #
                    # Inform modules that a new page has been created
                    __nodizeEvents.emit 'articleUpdate',
                      article:article_lang
                      parent:values.main_parent
                  
              # res.send '{"message_type":"","message":"","update":[],"callback":[{"fn":"ION.updateElement","args":{"element":"mainPanel","url":"article\\\/'+'edit\/'+values.rel+'"}},{"fn":"ION.notification","args":["success","Article saved"]},{"fn":"ION.updateArticleContext","args":[[{"logical_date":"0000-00-00 00:00:00","lang":"en","url":"welcome-article-url","title":"Welcome to Ionize","subtitle":"","meta_title":"","summary":"","content":"For more information about building a website with Ionize, you can:\\n\\nDownload &amp; read the Documentation\\nVisit the Community Forum\\n\\nHave fun !","meta_keywords":"","meta_description":"","online":"1","id_page":"2","view":"","ordering":"2","id_type":"","link_type":"","link_id":"","link":"","main_parent":"1","type_flag":""}]]}],"id":"'+article_lang.id+'"}'
                .on 'failure', (err) ->
                  console.log 'fail : ', err
            else
              createArticleLang( lang )
    else      
      # -------------------------------------
      # Creating a new article
      # -------------------------------------
      article = Article.build()
      article.name = values['url_' + Static_lang_default ]
      article.created = values.created
      article.updated = new Date()

      article.publish_on = if values.publish_on is '' then null else values.publish_on
      article.publish_off = if values.publish_off is '' then null else values.publish_off
      article.logical_date = if values.logical_date is '' then null else values.logical_date
            
      article.save()
        .on 'success', (article) ->
          createPageArticle( article, values )            
        .on 'failure', (err) ->
          console.log 'article save failed : ', err
          res.send "Save failed"
           
      #
      # Creating linked page_article record
      #
      createPageArticle = (article, values) ->
        # Create page_article object & define values
        page_article = Page_article.build()
        page_article.createBlank()
        page_article.id_article = article.id_article
        page_article.id_page = values.main_parent
        page_article.main_parent = values.main_parent 
        page_article.view = values.view       
         
        # Save to database
        page_article.save()
          .on 'success', (page_article) ->
            requestCount += Static_langs.length 
            for lang in Static_langs
              createArticleLang( lang, page_article, article, values )
          .on 'failure', (err) ->
            console.log "page_article adding failed : ", err
            res.send "Page_article save failed"
         
      #
      # Creating article_lang record
      #   
      createArticleLang = ( lang, page_article, article, values) ->
        # Create "article_lang" object & define values
        article_lang = Article_lang.build()
        article_lang.lang = lang
        article_lang.url = values['url_'+lang]
        article_lang.id_article = article.id_article
        article_lang.title = values['title_'+lang]
        article_lang.content = values['content_'+lang]
        article_lang.online = values['online_'+lang] or 0
        article_lang.subtitle = values['subtitle_'+lang] or ""
         
        # Save to database
        article_lang.save()
          .on 'success', (article_lang) ->
            requestCount--

            if requestCount is 0
              #
              # Building the callback message
              #
              message =  
                message_type  : ""
                message       : ""              
                update        : []              
                callback      : [
                  fn    : "ION.notification"
                  args  : [
                    "success"
                    ion_lang[req.params.lang].ionize_message_article_saved
                  ]
                ,
                  fn:"mainTree.insertElement"
                  args:[
                    id_page     : values.main_parent
                    id_article  : article_lang.id_article
                    #id          : 1691
                    title       : article_lang.title
                    type_flag   : ''
                    flag        : 0
                    online      : 0
                    indexed     : 1
                    name        : article.name
                    main_parent : 1
                    inserted    : true
                    has_url     : 1
                    ordering    : 1
                    lang        : "en"
                    # menu        : 
                    #   id:"1"
                    #   id_menu:"1"
                    #   name:"main"
                    #   title:"Main menu"
                    #   ordering:"0"                                                  
                  ,
                    "article"
                  ]
                ,
                  fn  : "ION.updateElement"
                  args: [
                    element:"mainPanel"
                    url:"article\/\/edit\/"+values.main_parent+"."+article_lang.id_article
                  ]
                ]
                id : article_lang.id                              
              
              res.send message

              #
              # Inform modules that a new page has been created
              __nodizeEvents.emit  'articleCreate', 
                article : article_lang
                parent : values.main_parent
              
          .on 'failure', (err) ->
            console.log 'save failed : ', err

  #
  # ARTICLE CHANGE ONLINE STATUS 
  #
  @backend_articleSwitchOnline = (req, res) ->
    #res.send "Yooo "+req.params.page_id+" --> "+req.params.article_id
    
    #
    # retrieving the page_article online value
    #
    Page_article.find( {where: {id_article:req.params.id_article, id_page:req.params.id_page } })
      .on 'success', (page_article) ->
        articleUpdate( res, page_article )
      .on 'failure', (err) ->
        console.log 'failure ', err
        res.send "failure ", err
      
    #
    # Switching online status
    #  
    articleUpdate = ( res, page_article ) ->
      if page_article.online==0
        page_article.online = 1
      else
        page_article.online = 0
        
      page_article.save()
        .on 'success', (page_article) ->
          res.send '{"message_type":"success","message":"Operation OK","update":[],'+
            '"callback":[{"fn":"ION.switchOnlineStatus","args":{"status":'+page_article.online+
            ',"selector":".article'+page_article.id_page+'x'+page_article.id_article+'"}}]}'

          #
          # Inform modules that a new page has been modified
          __nodizeEvents.emit  'articleUpdate', 
            article : page_article.id_article
            parent : page_article.id_page

        .on 'failure', (err) ->
          console.log 'error ', err
          

  #
  # ARTICLE MOVE / LINK
  #
  @post "/:lang/admin/article/link_to_page" : (req, res) ->
    values = req.body 

    callback = (err, article, page_article) =>
      
      if err
        console.log "Error while moving article",err
      else
        if values.copy

          #
          # Response
          #
          message = 
            message_type:""
            message:""
            update:[]
            callback:[          
              
                       
              fn:"mainTree.insertElement"
              args: [            
                id_article:values.id_article
                name:article.name
                flag:"0"
                title:article.name
                online:page_article.online
                id_page:values.id_page
                ordering:"1"            
                inserted:true
                link_type:""
                link_id:""
                link:""
              ,
                "article"
              ]
            ,
              fn:"ION.notification"
              args : [
                "success","Article linked to page"
              ]
            ]

        else

          #
          # Response
          #
          message = 
            message_type:""
            message:""
            update:[]
            callback:[          
              
              fn:"ION.unlinkArticleFromPageDOM"
              args:
                id_page:values.id_page_origin
                id_article:values.id_article
            ,          
              fn:"mainTree.insertElement"
              args: [            
                id_article:values.id_article
                name:article.name
                flag:"0"
                title:article.name
                online:page_article.online
                id_page:values.id_page
                ordering:"1"            
                inserted:true
                link_type:""
                link_id:""
                link:""
              ,
                "article"
              ]
            ,
              fn:"ION.notification"
              args : [
                "success","Article linked to page"
              ]
            ]


        res.send( message )


    if values.copy      
      Article.link( values, callback )
    else
      Article.move( values, callback )



  #
  # ARTICLE UNLINK FROM PAGE
  #
  @post "/:lang/admin/article/unlink/:id_page/:id_article" : (req, res) ->
    
    callback = (err, article, page_article) =>
      if err
        console.log "Error while unlinking article",err
      else      
        #
        # Response
        #
        message = 
          message_type:""
          message:""
          update:[]
          callback:[          
            
            fn:"ION.unlinkArticleFromPageDOM"
            args: [
              id_page:@params.id_page
              id_article:@params.id_article
            ,
              "article"
            ]
          ,
            fn:"ION.notification"
            args : [
              "success","Article unlinked from page"
            ]
          ]


        res.send( message )
    
    Article.unlink( @params, callback )
      
  #
  # ARTICLE DELETE
  #
  @backend_articleDelete = (req, res) ->
    request = 0
    
    checkDone = ->
      request--
      
      #
      # When all requests are done, we send the response
      #
      if request is 0
        #
        # Building response
        #
        message =  
          message_type  : "success"
          message       : ion_lang[req.params.lang].ionize_message_operation_ok             
          update        : []              
          callback      : [
            fn    : "ION.deleteDomElements"
            args  : [
              ".article"+req.params.id_article                
            ]            
          ]

        res.send message

    #
    # Remove article from Page_article
    #
    deletePageArticle = ->
      request++  
      Page_article.findAll( {where:{id_article : req.params.id_article}} )
        .on 'success', (results)->
            #
            # Launch next step (async)
            #
            deleteArticleLang()

            #
            # do removal
            #            
            for record in results            
              request++
              record.destroy()
                .on 'success', ->                  
                  checkDone()
                .on 'error', (err) ->
                  console.log 'Database error : ', err

        .on 'failure', (err) ->
          console.log 'error ', err

    #
    # Remove article from Article_lang
    #
    deleteArticleLang = ->      
      Article_lang.findAll( {where:{id_article : req.params.id_article}} )
        .on 'success', (results)->
            #
            # Launch next step (async)
            #
            deleteArticle()

            #
            # Do removal
            #
            for record in results            
              request++
              record.destroy()
                .on 'success', ->
                  checkDone()
                .on 'error', (err) ->
                  console.log 'Database error : ', err

        .on 'failure', (err) ->
          console.log 'error ', err
    
    # 
    # Remove article from Article
    #
    deleteArticle = ->
      Article.findAll( {where:{id_article : req.params.id_article}} )
        .on 'success', (results)->
            request--
            for record in results            
              request++
              record.destroy()
                .on 'success', ->
                  checkDone()
                .on 'error', (err) ->
                  console.log 'Database error : ', err          
        .on 'failure', (err) ->
          console.log 'error ', err

    #
    # Start deletion process
    #
    deletePageArticle()
  #
  # ARTICLE ORDERING
  #
  @post '/:lang/admin/article/save_ordering/page/:id_page' : (req, res) ->
    values = req.body
    
    #
    # New articles ordering values are stored in "order" (POST) 
    #
    id_articles = values.order.split( "," )
    
    index = 1 
    requestCount = 0
    
    for id_article in id_articles
      requestCount++
      
      DB.query( "UPDATE page_article SET ordering=#{index} WHERE id_article=#{id_article} AND id_page=#{@params.id_page}")
        .on 'success', ->
          requestCount--
          
          if requestCount is 0
            message =  
              message_type  : "success"
              message       : "Articles ordered !"              
              update        : [                
              ]              
              callback      : null

            res.send message

        .on 'failure', (err) ->
          message =  
              message_type  : "error"
              message       : "Error during article ordering process"              
              update        : [                
              ]              
              callback      : null
                        
          res.send message
    
      index++

  #
  # SAVE ARTICLE CONTEXT 
  # Saving type
  #
  @post '/:lang/admin/article/save_context' : (req, res) ->
    values = req.body
    
    Page_article.find({where:{id_page:values.id_page, id_article:values.id_article}})
      .on 'success', (page_article) ->
        page_article.id_type = values.id_type if values.id_type
        
        page_article.view = values.view if values.view
        page_article.view = null if values.view is '--'
        
        page_article.save()
          .on "success", (page_article) ->
            
            message =  
              message_type  : "success"
              message       :  ion_lang[req.params.lang].ionize_message_article_context_saved              
              update        : [                
              ]              
              callback      : null

            res.send message
          .on "failure", (err) ->
            console.log "Error while updating context ", err
            res.send "nok"
                
      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # SAVE ARTICLE CATEGORIES
  #
  @post '/:lang/admin/article/update_categories' : (req, res) ->
    values = req.body
    
    requestCount = 0

    #
    # Deleting existing categories linked to the article
    #
    Article_category.findAll({where:{id_article:values.id_article}})
      .on 'success', (article_categories) ->        
        #
        # Remove linked categories if existing 
        #
        if article_categories.length>0
          
          requestCount += article_categories.length
          
          for article_category in article_categories
            article_category.destroy()
              .on "success", ->
                requestCount--
                if requestCount is 0
                  addCategories()
              .on "failure", (err) ->
                console.log "Database on removing categories", err
        #
        # Directly add categories if we have nothing to delete
        #
        else
          addCategories()

        
      .on 'failure', (err) ->
        console.log 'database error ', err
    

    #
    # Add categories to article
    #
    addCategories = ->
      requestCount += values.categories.length

      for id_category in values.categories
        article_category = Article_category.build()
        article_category.id_article = values.id_article
        article_category.id_category = id_category

        article_category.save()
          .on 'success', ->
            requestCount--
            if requestCount is 0              
              message = 
                message_type:""
                message:""
                update:[]
                callback:[
                  fn:"ION.notification"
                  args:["success","Article saved"]
                ]

              res.send message
          .on 'failure', (err) ->
              console.log "Error on adding category to article", err

  #
  # ARTICLE LINK TO
  #
  @post '/:lang/admin/article/get_link' : (req, res) =>
    values = req.body
    
    # Retrieve page_id from parameter in POST
    findPage = ->      
      Page_article.find( {where: {id_page:values.id_page, id_article:values.id_article} } )
        .on 'success', (page_article) ->
          if page_article
            renderView( page_article )
          else
            res.send "pageArticle #{values.id_page}/#{values.id_article} not found"
    
    renderView = (page_article) ->
      #
      # Display the page edition view 
      #
      res.render "backend_getLink",
        layout        : no        
        page          : page_article
        link          : page_article.link
        hardcode      : @helpers 
        lang          : req.params.lang
        ion_lang      : ion_lang[ req.params.lang ] 
        settings      : Settings
        parent        : 'article'        
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
  @post '/:lang/admin/article/add_link' : (req, res) =>
    values = req.body

    callback = (err, page_article) =>
      message = 
      message_type:""
      message:""
      update:[]
      callback:[
        fn:"ION.HTML"
        args:[
          "article\/\/get_link"
        ,
          id_page:page_article.id_page
          id_article:page_article.id_article
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
    Article.addLink( values, callback )

  #
  # Removing a link 
  #
  # @param post.rel = id_page
  @post '/:lang/admin/article/remove_link' : (req, res) =>
    values = req.body
    
    callback = (err, page_article) =>
      if not err 
        message = 
        message_type:""
        message:""
        update:[]
        callback:[
          fn:"ION.HTML"
          args:[
            "article\/\/get_link"
          ,
            id_page:page_article.id_page
            id_article:page_article.id_article
          ,
            update:"linkContainer"
          ]      
        ]

        res.send message

    #
    # Start link deletion
    #
    Article.removeLink( values, callback )