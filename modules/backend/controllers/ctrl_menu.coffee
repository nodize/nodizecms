# Menu controller 
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
  # MENU SETTINGS 
  #
  @get "/:lang/admin/menu" : ->    
    #
    # Retrieve menus
    #
    Menu.findAll({order:'ordering'})
      .on 'success', (menus) =>
        #
        # Display menu edition page
        #    
        @render "backend_menu", 
          layout    : no
          hardcode  : @helpers 
          settings  : Settings
          lang      : @params.lang      
          ion_lang  : ion_lang[ @params.lang ]

          menus     : menus
        
      .on 'failure', (err) ->
        console.log 'database error ', err
    
  #
  # MENU SETTINGS TOOLBOX
  #
  @get "/:lang/admin/desktop/get/toolboxes/menu_toolbox" : ->
    @render "backend_menuToolbox", 
      layout    : no
      hardcode  : @helpers 
      lang      : @params.lang      
      ion_lang  : ion_lang[ @params.lang ]


  #
  # MENU ORDERING
  #
  @post "/:lang/admin/menu/save_ordering" : (req) ->
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
          message       : "Menus ordered"              
          update        : [
            element : "structurePanel"
            url     : '\/tree\/'            
          ]                   
          callback      : null
              
        @send message  

    ordering = 0

    #
    # Doing UPDATE queries
    #
    for id_menu in values.order.split ','
      requestCount++

      DB.query( "UPDATE menu SET ordering=#{ordering} WHERE id_menu=#{id_menu}")
        .on 'success', ->
          checkFinished()
          
        .on 'failure', (err) ->
          console.log 'database error ', err
              
      ordering++



  #
  # MENU UPDATE
  #
  @post "/:lang/admin/menu/update" : (req) ->
    values = req.body

    #
    # Used to know when async requests are finished
    #
    requestCount = 0

    #
    # Call back on request finished
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
          message       : "Menus saved"              
          update        : [
            element : "structurePanel"
            url     : '\/tree\/'            
          ]                   
          callback      : null
              
        @send message  

    updateMenu = (id_menu, title, name) ->
      Menu.find({where:{id_menu:id_menu}})
        .on 'success', (menu) ->
          console.log "record found"
          menu.title = title
          menu.name = name

          requestCount++

          menu.save()
            .on 'success', (menu) ->
              checkFinished()
            .on 'failure', (err) ->
              console.log 'database error on save menu', err    

        .on 'failure', (err) ->
          console.log 'database error ', err
      
    #
    # Get all existing menus
    #
    Menu.findAll()
      .on 'success', (menus) =>
        for menu in menus
          if values["name_"+menu.id_menu]
            updateMenu( menu.id_menu, values["title_"+menu.id_menu], values["name_"+menu.id_menu])
        
      .on 'failure', (err) ->
        console.log 'database error ', err
    

  #
  # MENU DELETE
  #
  @post "/:lang/admin/menu/delete/:id_menu" : (req, res) ->
    Menu.find({where:{id_menu:@params.id_menu}})
      .on 'success', (menu) =>
        menu.destroy()
          .on 'success', =>    

            #
            # Building JSON response
            # - Notification
            # - Redirect main panel to menu edit            
            # - Refresh tree
            #  
            message =  
              message_type  : "success"
              message       : "Menu deleted"              
              update        : [
                element : "mainPanel"
                url     : '\/menu\/'            
              ,
                element : "structurePanel"
                url     : '\/tree\/'            
              ]              
              callback      : 
                null
              id  : @params.id_menu
            # / Message
            
            res.send message

          .on 'failure', (err) ->
            console.log 'database error ', err

      .on 'failure', (err) ->
        console.log 'database error ', err
    
  

  #
  # MENU ADD NEW
  #
  #
  @post "/:lang/admin/menu/save" : (req, res) ->
    values = req.body

    menu = Menu.build()

    menu.name = values.name_new
    menu.title = values.title_new

    #
    # Add Menu record
    #
    doMenuSave = (ordering)->
      menu.ordering = ordering

      menu.save()
        .on 'success', (new_menu) ->
          console.log "menu saved ", new_menu.id_menu
          
          # Sequelize needs "id" field & current primary key is "id_menu" in Ionize database
          DB.query( "UPDATE menu SET id_menu = id")

          #
          # Building JSON response
          # - Notification
          # - Redirect main panel to menu edit            
          # - Insert menu in tree
          #  
          message =
            message_type  : "success"
            message       : "Menu saved"
            
            update        : [
              element : "mainPanel"
              url     : '\/menu\/'            
            ,
              element : "structurePanel"
              url     : '\/tree\/'            
            ]
            
            callback      : 
              null

          res.send message
        .on 'failure', (err) ->
          console.log "menu save error ", err

    #
    # Find menu's max ordering value
    #      
    Menu.max('ordering')
      .on 'success', (max) ->
        doMenuSave( max+1 )
