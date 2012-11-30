# Page lang category model
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Original database model :
# IonizeCMS (http://www.ionizecms.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
module.exports = (sequelize, DataTypes)->
  sequelize.define "page_lang", 
    id_page           : DataTypes.INTEGER
    url               : DataTypes.STRING
    lang              : DataTypes.STRING
    # link              : DataTypes.STRING
    title             : DataTypes.STRING
    subtitle          : DataTypes.STRING
    nav_title         : DataTypes.STRING
    subnav_title      : DataTypes.STRING
    meta_title        : DataTypes.STRING
    meta_description  : DataTypes.STRING
    meta_keywords     : DataTypes.STRING    
    online            : DataTypes.INTEGER
    home              : DataTypes.INTEGER
  
  ,
  
    instanceMethods: 
      #
      # Define default values on page creation
      #
      createBlank : ->
        @title    = ""
        @url      = ""
        @id_page  = "" 
        @subtitle = ""
    
  
    classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'page_lang'

        migrations = [
          version : 1
          code : ->
            "First version"
        , 
          version : 2
          code : ->
            migrator.removeColumn( 'link' )
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

  