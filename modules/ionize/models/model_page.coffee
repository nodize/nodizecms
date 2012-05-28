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
  ,
  
    classMethods:             
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
    
    instanceMethods: 
      #
      # Define default values on page creation
      #
      createBlank : ->
        @name    = ""


        
