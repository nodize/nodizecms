# Controller for article types
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
  # TYPE SETTINGS 
  #
  @post "/:lang/admin/article_type/get_list" : ->    
    #
    # Retrieve menus
    #
    Article_type.findAll({order:'ordering'})
      .on 'success', (article_types) =>
        #
        # Display menu edition page
        #    
        @render "backend_type", 
          layout    : no
          hardcode  : @helpers 
          settings  : Settings
          lang      : @params.lang      
          ion_lang  : ion_lang[ @params.lang ]

          article_types : article_types
        
      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # TYPE EDIT
  #
  @post "/:lang/admin/article_type/edit/:id_type" : ->    
    Article_type.find({where:{id_type:@params.id_type}})
      .on 'success', (article_type) =>
        #
        # Display type edition page
        #    
        @render "backend_typeEdit", 
          layout    : no
          hardcode  : @helpers 
          settings  : Settings
          lang      : @params.lang      
          ion_lang  : ion_lang[ @params.lang ]

          article_type : article_type
      .on 'failure', (err) ->
        console.log 'database error ', err
    

  #
  # TYPE GET SELECT ONLY
  #
  @post "/:lang/admin/article_type/get_select" : ->    
    #
    # Retrieve menus
    #
    Article_type.findAll({order:'ordering'})
      .on 'success', (article_types) =>
        #
        # Display menu edition page
        #    
        @render "backend_typeSelect", 
          layout    : no
          hardcode  : @helpers 
          settings  : Settings
          lang      : @params.lang      
          ion_lang  : ion_lang[ @params.lang ]

          article_types : article_types
        
      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # UPDATE A TYPE
  #
  @post "/:lang/admin/article_type/update" : (req, res) ->
    values = req.body

    Article_type.find({where:{id_type:values.id_type}})
      .on 'success', (article_type) ->
        article_type.type = values.type
        article_type.type_flag = values.type_flag or 0
        article_type.description = values.description

        doArticleTypeUpdate( article_type )
      .on 'failure', (err) ->
        console.log 'database error ', err
     
    
    #
    # Update type record
    #
    doArticleTypeUpdate = (article_type)->      
      article_type.save()
        .on 'success', (article_type) ->
          #
          # Building JSON response
          # - Notification
          # - Redirect main panel to menu edit            
          # - Insert menu in tree
          #  
          message =  
            message_type  : "success"
            message       : "Article type saved"
            
            update        : []
            
            callback      : [ 
              fn:"ION.HTML"
              args: ["article_type\/\/get_list","",{"update":"articleTypesContainer"}]
            ,
              fn:"ION.clearFormInput"
              args:{"form":"newTypeForm"} 
            ]

            id: article_type.id_type

          res.send message
        .on 'failure', (err) ->
          console.log "articleType save error ", err
    

  #
  # ADD A TYPE
  #
  @post "/:lang/admin/article_type/save" : (req, res) ->
    values = req.body    

    articleType = Article_type.build()

    articleType.type = values.type
    articleType.type_flag = values.type_flag or 0
    articleType.description = values.description

    #
    # Add TYPE record
    #
    doArticleTypeSave = (ordering)->
      articleType.ordering = ordering

      articleType.save()
        .on 'success', (new_articleType) ->
          # Sequelize needs "id" field & current primary key is "id_type" in Ionize database
          DB.query( "UPDATE article_type SET id = id_type")
          
          #
          # Building JSON response
          # - Notification
          # - Redirect main panel to menu edit            
          # - Insert menu in tree
          #  
          message =  
            message_type  : "success"
            message       : "Article type saved"
            
            update        : []
            
            callback      : [ 
              fn:"ION.HTML"
              args: ["article_type\/\/get_list","",{"update":"articleTypesContainer"}]
            ,
              fn:"ION.clearFormInput"
              args:{"form":"newTypeForm"} 
            ]

            id: new_articleType.id_type

          res.send message
        .on 'failure', (err) ->
          console.log "articleType save error ", err

    #
    # Find Article_type's max ordering value
    #      
    Article_type.max('ordering')
      .on 'success', (max) ->
        doArticleTypeSave( max+1 )


  #
  # TYPE DELETE
  #
  @post "/:lang/admin/article_type/delete/:id_type" : ->
    Article_type.find({where:{id_type:@params.id_type}})
      .on 'success', (article_type) =>
        article_type.destroy()
          .on 'success', =>               
            #
            # Building JSON response
            #  
            message =  
              message_type  : "success"
              message       : "Type deleted"              
              update        : [
                element : "article_types"
                url     : "\/#{@params.lang}\/admin\/article_type\/\/get_select"
              ]              
              callback      : [
                "fn":"ION.deleteDomElements"
                "args":[".article_type"+@params.id_type]
              ]
              id  : @params.id_type
            # / Message
            
            @send message  

          .on 'failure', (err) ->
            console.log 'database error ', err

      .on 'failure', (err) ->
        console.log 'database error ', err
    
  #
  # TYPES ORDERING
  #
  @post "/:lang/admin/article_type/save_ordering" : (req) ->
    values = req.body

    requestCount = 0

    #
    # Call back on request finish
    # We send success response when all requests are done
    #
    checkFinished = =>
      requestCount--
      
      if requestCount is 0
        #
        # Building JSON response
        # - Notification
        #  
        message =  
          message_type  : "success"
          message       : "Types ordered"              
          update        : []                   
          callback      : null
              
        @send message  

    ordering = 1

    #
    # Doing UPDATE queries
    #
    for id_type in values.order.split ','
      requestCount++

      DB.query( "UPDATE article_type SET ordering=#{ordering} WHERE id_type=#{id_type}")
        .on 'success', ->
          checkFinished()
          
        .on 'failure', (err) ->
          console.log 'database error ', err
              
      ordering++
  
