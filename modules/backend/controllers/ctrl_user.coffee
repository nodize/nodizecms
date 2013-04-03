# Users management controller
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

  #
  # Displaying USERS EDITION PAGE
  #
  @get '/:lang/admin/users' : ->
    loadGroups = ->
      User_group.findAll({order:"level"})
        .on 'success', (user_groups) ->
          renderPage( user_groups )
        .on 'failure', (err) ->
          console.log 'database error ', err
      
    renderPage = (user_groups) =>
      @render "backend_users", 
        layout    : no
        hardcode  : @helpers           
        lang      : @params.lang      
        ion_lang  : ion_lang[ @params.lang ]
        user_groups : user_groups

    loadGroups()

  #
  # Displaying USER LIST
  #
  @post '/:lang/admin/users/users_list' : ->
    groups = {}

    loadGroups =-> 
      User_group.findAll()
        .on 'success', (user_groups) ->
          groups[group.id_group] = group.group_name for group in user_groups          
          loadUsers()
        .on 'failure', (err) ->
          console.log 'database error ', err

    loadUsers = ->
      User.findAll({order:"username"})
        .on 'success', (users) ->
          renderPage( users )
        .on 'failure', (err) ->
          console.log 'database error ', err
      
    renderPage = (users) =>
      @render "backend_userList", 
        layout    : no
        hardcode  : @helpers           
        lang      : @params.lang      
        ion_lang  : ion_lang[ @params.lang ]
        users     : users
        groups    : groups

    loadGroups() 

  #
  # CREATE a new USER
  #
  @post '/:lang/admin/users/save' : (req, res) ->
    values = req.body

    checkPassword = =>
      #
      # Checking if passwords are matching
      #
      if values.password is values.password2        
        userSave()
      else
        message = 
          message_type:"error"
          message:"Passwords must match"
          update:[]
          callback:null

        @send message

    userSave = ->
      user = User.build()

      user.username     = values.username
      user.screen_name  = values.screen_name
      user.id_group     = values.id_group
      user.email        = values.email
      user.join_date    = new Date()

      #
      # Building a password hash
      #
      crypto = require "crypto"
      hmac = crypto.createHmac("sha1", __sessionSecret)
      hash = hmac.update values.password
      
      user.password = hash.digest(encoding="base64")

      user.save()
        .on 'success', (user) ->
          user.id = user.id_user
          user.save()
            .on 'success', (user) ->
              message = 
                message_type:"success"
                message:"User saved"
                update:[
                  element:"mainPanel"
                  url: "\/admin\/users"
                ]
                callback:null

              res.send message

            .on 'failure', (err) ->
              console.log 'database error on user creation', err


        .on 'failure', (err) ->
          console.log 'database error on user creation', err

    #
    # Start process
    #
    checkPassword()


  #
  # UPDATE USER
  #
  @post '/:lang/admin/users/update' : (req, res) ->
    values = req.body

    checkPassword = =>
      #
      # Checking if passwords are matching
      #
      if (values.password is values.password2) or (values.password is "" and values.password2 is "")
        loadUser()
      else
        message = 
          message_type:"error"
          message:"Passwords must match"
          update:[]
          callback:null

        @send message

    loadUser = ->
      User.find({where:{id_user:values.user_PK}})
        .on 'success', (user) ->
          userSave(user)
        .on 'failure', (err) ->
          console.log 'database error ', err

    userSave = (user) ->
      user.username     = values.username
      user.screen_name  = values.screen_name
      user.id_group     = values.id_group
      user.email        = values.email
      
      if (values.password isnt "")
        #
        # Building a password hash
        #
        crypto = require "crypto"
        hmac = crypto.createHmac("sha1", __sessionSecret)
        hash = hmac.update values.password
        
        user.password = hash.digest(encoding="base64")

      user.save()
        .on 'success', (user) ->
          user.id = user.id_user
          user.save()
            .on 'success', (user) ->
              message = 
                message_type:"success"
                message:"User saved"
                update:[
                  element:"mainPanel"
                  url: "\/admin\/users"
                ]
                callback:null

              res.send message

            .on 'failure', (err) ->
              console.log 'database error on user update', err


        .on 'failure', (err) ->
          console.log 'database error on user update', err

    #
    # Start process
    #
    checkPassword()

  #
  # EDIT USER
  #
  @post '/:lang/admin/users/edit/:id_user' : (req) ->
    groups = null

    loadGroups = ->
      User_group.findAll()
        .on 'success', (user_groups) ->
          #groups[group.id_group] = group.group_name for group in user_groups          
          groups = user_groups
          loadUser( )
        .on 'failure', (err) ->
          console.log 'database error ', err


    loadUser = ->
      User.find({where:{id_user:req.params.id_user}})
        .on 'success', (user) ->
          renderPage(user)
        .on 'failure', (err) ->
          console.log 'database error ', err
      

    renderPage = (user) =>
      @render "backend_user", 
        layout    : no
        hardcode  : @helpers           
        lang      : @params.lang      
        ion_lang  : ion_lang[ @params.lang ]
        user      : user
        groups    : groups

    #
    # Start process
    #
    loadGroups()



  #
  # DELETE an USER
  #
  @post '/:lang/admin/users/delete/:id_user' : (req, resy) ->
    
    findUser = =>
      User.find({where:{id_user:@params.id_user}})
        .on 'success', (user) ->
          removeUser( user )
          
        .on 'failure', (err) ->
          console.log 'database error ', err

    removeUser = (user) ->
      user.destroy()
        .on 'success', (user) ->
          message = 
            message_type:"success"
            message:"User deleted"
            update:[
                  element:"mainPanel"
                  url: "\/admin\/users"
                ]
            callback:null
            id:user.id_user

          res.send message
          
        .on 'failure', (err) ->
          console.log 'database error ', err      

    #
    # Start process
    #  
    findUser()
    