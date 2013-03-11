# Page model
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Original database model :
# IonizeCMS (http://www.ionizecms.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
module.exports = (sequelize, DataTypes)->
  sequelize.define "page", 
  
    id_page           : { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true }    
    id_parent         : DataTypes.INTEGER
    id_menu           : DataTypes.INTEGER
    id_subnav         : DataTypes.INTEGER
    name              : DataTypes.STRING
    ordering          : DataTypes.INTEGER
    level             : DataTypes.INTEGER
    online            : DataTypes.INTEGER
    home              : DataTypes.INTEGER
    author            : DataTypes.STRING
    view              : DataTypes.STRING
    view_single       : DataTypes.STRING
    article_list_view : DataTypes.STRING
    article_view      : DataTypes.STRING
    article_order     : DataTypes.STRING
    article_order_direction : DataTypes.STRING
    link              : DataTypes.STRING
    link_type         : DataTypes.STRING
    link_id           : DataTypes.STRING
    pagination        : DataTypes.INTEGER
    pagination_nb     : DataTypes.INTEGER
    id_group          : DataTypes.INTEGER
    priority          : DataTypes.INTEGER
    appears           : DataTypes.INTEGER
    created           : DataTypes.DATE
    updated           : DataTypes.DATE
    publish_on        : DataTypes.DATE
    publish_off       : DataTypes.DATE
    logical_date      : DataTypes.DATE
    has_url           : DataTypes.INTEGER
  ,
  
    classMethods:     
      #
      # Migration management
      #
      migrate : ->

        tableName = 'page'

        migrations = [
          version : 1
          code : ->
            "First version"
        ,
          version : 2
          code : ->
            migrator.addColumn( 'created', DataTypes.DATE )
            migrator.addColumn( 'updated', DataTypes.DATE )
            migrator.addColumn( 'publish_on'  , DataTypes.DATE )
            migrator.addColumn( 'publish_off' , DataTypes.DATE )
            migrator.addColumn( 'logical_date', DataTypes.DATE )
        ,
          version : 3
          code : ->
            migrator.addColumn( 'has_url', DataTypes.INTEGER )
        ]

        migrator = sequelize.getMigrator( tableName )
        migrator.doMigrations( tableName, migrations )
         
      #
      # Switch online status
      #  
      switch_online : (data, callback) ->
        #
        # Find page
        #
        @find( {where:data} )
          #
          # Change online value & call callback
          #
          .on 'success', (page) ->
            if page
              page.online = not page.online
              page.save()
                .on 'success', (page) ->
                  callback(null, page)
                .on 'failure', (err) ->
                  callback(err, null)
            else
              callback("page not found",null)

          .on 'failure', (err) ->
            console.log "Page database error", err
            callback(err, null)

      #
      # Retrieve page level
      #
      get_level : (data, callback) ->
        #
        # Find page
        #
        @find( {where:data} )          
          .on 'success', (page) ->
            if page              
              callback(null, page.level)                
            else
              callback("page not found",null)

          .on 'failure', (err) ->
            console.log "Page database error", err
            callback(err, null)


      #
      # Deleting pages
      # "data" contains a JSON array with filter to apply (=SQL WHERE)
      #
      delete : (data, callback) ->        
        requestCount = 0
        
        @findAll({where:data})
          .on 'success', (pages) =>
            #
            # We will launch as many delete requests than langs found
            #
            requestCount += pages.length

            #
            # Do deletion
            #
            for page in pages
              page.destroy()
                .on 'success', (page)->                  
                  #
                  # Removing linked records
                  #
                  Page_article.delete {id_page:page.id_page}, (err) ->
                    unless err
                      Page_lang.delete {id_page:page.id_page}, (err) ->
                        requestCount--
                        if requestCount is 0
                          callback( null )

                .on 'failure', (err) ->
                    callback( err )

          #
          # Failure when searching langs to delete
          #    
          .on 'failure', (err) ->
            console.log "Page deletion error,", err
            callback( err )

      #
      # Creating a link for a page
      #
      # @param data.link_rel = destination
      # @param data.receiver_rel = page we are adding a link to
      # @param data.link_type = "page" | "article" | "external"  
      addLink : (data, callback) ->        

        #
        # Retrieve the page we link to
        #
        findDestinationPage = =>
          if data.link_type is 'page'
            @find({where:{id_page:data.link_rel}})
              .on 'success', (page) =>
                createLink( page )
              
              .on 'failure', (err) ->
                callback( err, null )
          else
            createLink( null )

        createLink = (pageLink) =>
          @find({where:{id_page:data.receiver_rel}})
            .on 'success', (page) =>
              page.link_type = data.link_type
              
              #
              # If the link is an internal page
              #
              if page and data.link_type is "page"                
                page.link = pageLink.name
                page.link_id = pageLink.id_page
              #
              # if the link is external
              #
              else if data.link_type is "external"
                page.link = data.url
                console.log "link = #{data.url}"


              page.save()
                .on 'success', (page) =>
                  callback( null, page )
                .on 'failure', (err) ->
                  callback( err, null )
                      
          .on 'failure', (err) ->
            callback( err, null )

        #
        # Start process
        #
        findDestinationPage()

      #
      # Removing a link for a page
      #
      # @param data.id_page = page
      removeLink : (data, callback) ->
        findPage = =>
          @find({where:{id_page:data.id_page}})
            .on 'success', (page) =>
              deleteLink( page )
            
            .on 'failure', (err) ->
              callback( err, null )

        deleteLink = (page) =>
          page.link_type = null
          page.link = null
          page.link_id = null

          page.save()
            .on 'success', (page) =>
              callback( null, page )
            .on 'failure', (err) ->
              callback( err, null )
                      
          
        #
        # Start process
        #
        findPage()
    
    instanceMethods:       
      #
      # Define default values on page creation
      #
      createBlank : ->
        @name           = ""
        @created        = new Date()
        @updated        = new Date()
        @publish_on     = ''
        @publish_off    = ''
        @logical_date   = ''
        @pagination     = -1
        @pagination_nb  = -1
        @id_group       = -1
        @priority       = -1
        @has_url        = 1


        
