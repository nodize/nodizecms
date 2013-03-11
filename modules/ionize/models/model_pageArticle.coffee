# Page article category model
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
  sequelize.define "page_article", 
    id_page     : DataTypes.INTEGER
    id_article  : DataTypes.INTEGER 
    online      : DataTypes.INTEGER 
    view        : DataTypes.STRING        
    ordering    : DataTypes.INTEGER 
    id_type     : DataTypes.INTEGER
    link_type   : DataTypes.STRING
    link_id     : DataTypes.INTEGER
    link        : DataTypes.STRING
    main_parent : DataTypes.INTEGER
  ,
  
    instanceMethods: 
      #
      # Define default values on article creation
      #
      createBlank : ->
       @online = 0
       @link_type = ''
       @link_id = ''
       @link = ''

    classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'page_article'
      
        migrations = [
          version : 1
          code : ->
            "First version"
#         ,
#           version : 2
#           code : ->
#             migrator.addColumn( 'newField', DataTypes.STRING )
#             migrator.removeColumn( 'link_type' )

        ]

        migrator = sequelize.getMigrator( tableName )
        migrator.doMigrations( tableName, migrations )
      #
      # Deleting page article
      # "data" contains a JSON array with filter to apply (=SQL WHERE)
      #
      delete : (data, callback) ->        
        requestCount = 0
                  
        @findAll({where:data})
          .on 'success', (records) ->            
            callback(null) if records.length is 0 

            #
            # We will launch as many delete requests than records found
            #
            requestCount += records.length

            #
            # Do deletion
            #
            for record in records              
              record.destroy()
                .on 'success', (record)->                  
                  requestCount--
                  if requestCount is 0
                    callback( null )

                .on 'failure', (err) ->
                    callback( err )          
          #
          # Failure when searching records to delete
          #    
          .on 'failure', (err) ->
            console.log "Record deletion error,", err
            callback( err )
  