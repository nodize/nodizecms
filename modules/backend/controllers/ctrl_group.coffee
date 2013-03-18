# Groups controller
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
  
  #
  # Creating a new group
  #
  @post '/:lang/admin/groups/save' : (req, res) ->
    values = req.body
    #
    # Building new record
    #
    user_group = User_group.build()

    user_group.group_name = values.group_name
    user_group.level = values.level

    #
    # Saving it
    #
    user_group.save()
      .on "success", (user_group)->
        #
        # Updating id
        #
        user_group.id_group = user_group.id
        user_group.save()
          .on "success", ->
            message = 
              message_type:"success"
              message:"Group saved"
              update:[
                element:"mainPanel"
                url:"\/"+req.params.lang+"\/admin\/users"
              ]
              callback:null

            res.send message

          .on "failure", (err) ->
            console.log "Database error on group save :", err  

      .on "failure", (err) ->
        console.log "Database error on group save :", err  

  #
  # Deleting a group
  #
  @post '/:lang/admin/groups/delete/:id_group' : (req, res) ->
    #
    # Find the group
    #
    User_group.find({where:{id:req.params.id_group}})
      .on 'success', (user_group) ->
        #
        # Then delete it
        #
        user_group.destroy()
          .on "success", (user_group) ->

            message = 
              message_type:"success"
              message:"Group deleted"
              update:[
                element:"mainPanel"
                url:"\/"+req.params.lang+"\/admin\/users"
              ],
              callback:null
              id:user_group.id

            res.send message

          .on 'failure', (err) ->
            console.log 'database error ', err
                
      .on 'failure', (err) ->
        console.log 'database error ', err
    
  #
  # Editing a new group
  #
  @post '/:lang/admin/groups/edit/:id_group' : (req) ->
    loadGroup = ->
      User_group.find({where:{id:req.params.id_group}})
        .on 'success', (user_group) ->
          renderPage( user_group )
        .on 'failure', (err) ->
          console.log 'database error ', err
      
    renderPage = (user_group) =>
      @render "backend_group", 
        layout      : no
        hardcode    : @helpers           
        lang        : @params.lang      
        ion_lang    : ion_lang[ @params.lang ]
        user_group  : user_group

    loadGroup()

  #
  # Updating group record
  #
  @post '/:lang/admin/groups/update' : (req, res) ->
    values = req.body

    loadGroup = ->
      User_group.find({where:{id_group:values.group_PK}})
        .on 'success', (user_group) ->
          updateGroup( user_group )
        .on 'failure', (err) ->
          console.log 'database error ', err
        
    updateGroup = (user_group) ->

      user_group.group_name = values.group_name
      user_group.level = values.level

      user_group.save()
        .on 'success', (user_group) ->

          message = 
            message_type:"success"
            message:"Group updated"
            update:[
              element:"mainPanel"
              url:"\/"+req.params.lang+"\/admin\/users"
            ],
            callback:null
            id:user_group.id_group

          res.send message

        .on 'failure', (err) ->
          console.log 'database error ', err
        
    loadGroup()


