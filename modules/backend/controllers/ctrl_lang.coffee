# Langs controller
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->  
  #
  # LANGS SETTINGS 
  #
  @get "/:lang/admin/lang" : ->    
    Lang.findAll({order:'ordering'})
      .on 'success', (langs) =>
        @render "view_backend_langSettings",
          layout    : no
          hardcode  : @helpers 
          lang      : @params.lang # Current lang
          ion_lang  : ion_lang[ @params.lang ] # Translations
          langs     : langs # Database result
    
      .on 'failure', (err) ->
        console.log 'database error ', err
    
    
  #
  # LANGS SETTINGS TOOLBOX
  #
  @get "/:lang/admin/desktop/get/toolboxes/lang_toolbox" : ->
    @render "backend_langToolbox", 
      layout    : no
      hardcode  : @helpers 
      lang      : @params.lang      
      ion_lang  : ion_lang[ @params.lang ]

  #
  # ADDING A NEW LANG
  #
  @post "/:lang/admin/lang/save" : (req) ->
    
    lang = Lang.build()

    values = req.body
  
    data =  
      lang : values.lang_new
      name : values.name_new
      online : values.online_new or 0
    
    lang.add data, (err, lang) =>
      unless err
        #
        # Building JSON response
        # - Notification
        # - Redirect main panel to lang edit page
        #  
        message =  
          message_type  : "success"
          message       : "Language saved"          
          update        : [
            element : "mainPanel"
            url: "\/#{@params.lang}\/admin\/lang"
          ]          
          callback      : []
          
        @send message

      #
      # Inform other modules that langs have been updated
      #
      __nodizeEvents.emit  'langsUpdate', 'add'

    

  #
  # LANG DELETE
  #
  @post "/:lang/admin/lang/delete/:id_lang" : ->
    data =
      lang:@params.id_lang      

    Lang.delete data, (err, lang) =>
      unless err
        #
        # Building JSON response
        #  
        message =  
          message_type  : "success"
          message       : "Lang deleted"              
          update        : [                
          ]              
          callback      : [
            "fn":"ION.deleteDomElements"
            "args":["#langElement_"+@params.id_lang]
          ]          
        # / Message
        
        @send message  

        #
        # Inform other modules that langs have been updated
        #
        __nodizeEvents.emit  'langsUpdate', 'delete'

    return
    

  #
  # UPDATE LANGS
  #
  @post "/:lang/admin/lang/update" : (req) ->
    values = req.body    
    requestCount = 0

    #console.log values

    #
    # Checking if requests are finished
    # & sending reponse when done
    #
    checkFinished = (err, record) =>
      requestCount--
      if err
        console.log err
      else 
        if requestCount is 0
          #
          # Building JSON response
          #  
          message =  
            message_type  : "success"
            message       : "Languages updated"
            
            update        : [
              element : 'mainPanel'
              #url : req.params.lang+'\/admin\/\/xlang'
              url : '\/admin\/\/lang'
            ]
            
            callback      : []
          
          @send message

          #
          # Inform other modules that langs have been updated
          #
          __nodizeEvents.emit  'langsUpdate', 'update'



    # Get existing langs
    #   
    getExistingLangs = ->
        Lang.findAll()
          .on 'success', (langs) ->            
            requestCount += langs.length            
            updateLang( lang ) for lang in langs   
          .on 'failure', (err) ->
            console.log 'database error ', err
        
    updateLang = (lang) ->
      currentLang = lang.lang
      
      #
      # Retrieve fields from POST
      #      
      data = 
        lang : values["lang_"+currentLang] or '??'
        name : values["name_"+currentLang] or '??'
        online : values["online_"+currentLang] or 0
        def : if values["default_lang"] is values["lang_"+currentLang] then 1 else 0 
      
      #
      # Update the record
      #      
      Lang.update data, checkFinished       
      
    #
    # Start update process
    #
    getExistingLangs()

  #
  # LANGS ORDERING
  #
  @post "/:lang/admin/lang/save_ordering" : (req) ->
    values = req.body

    requestCount = 0

    #
    # Call back on request finished
    # We send success response when all requests are done
    #
    checkFinished = (err, record) =>
      requestCount--
      
      if requestCount is 0
        #
        # Building JSON response
        # - Notification
        #  
        message =  
          message_type  : "success"
          message       : "Languages ordered"              
          update        : []                   
          callback      : null
              
        @send message

        #
        # Inform other modules that langs have been updated
        #
        __nodizeEvents.emit  'langsUpdate', 'ordering'  

    ordering = 1

    #
    # Doing UPDATE queries
    #
    orders = values.order.split ','
    requestCount = orders.length
    
    for lang in orders      
      #
      # Retrieve fields from POST
      #      
      data = 
        lang      : lang
        ordering  : ordering
      
      #
      # Update the record
      #      
      Lang.update data, checkFinished
            
      ordering++
  
