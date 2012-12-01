# Lang model
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
  sequelize.define "lang", 
    lang        : DataTypes.STRING
    name        : DataTypes.STRING
    online      : DataTypes.INTEGER
    def         : DataTypes.INTEGER
    ordering    : DataTypes.INTEGER
  ,      
    instanceMethods: 

      #
      # Creating a new lang
      #
      add : (data, callback) ->
        #
        # Assigning data to record's fields
        #
        for value of data
          @[value] = data[value]
        
        #
        # Find Lang's max ordering value to put the new lang at the end of the list
        #      
        Lang.max('ordering')
          .on 'success', (max) =>
            @ordering = max+1
            #
            # Saving the record
            #
            @save()
              .on 'success', (record) ->
                callback(null, record )
              .on 'failure', (err) ->
                callback(err, null)


    classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'lang'

        migrations = [
          version : 1
          code : ->
            "First version"
#        ,
#          version : 2
#          code : ->
#            migrator.addColumn( 'newField', DataTypes.STRING )
#            migrator.removeColumn( 'field' )
        ]

        migrator = sequelize.getMigrator( tableName )
        migrator.doMigrations( tableName, migrations )
      #
      # Updating a lang
      #
      update : (data, callback) ->
        #
        # Find record
        #        
        getExistingRecord = ->
          Lang.find({where:{lang : data.lang}})
            .on 'success', (record) ->                            
              if record
                updateRecord( record, callback ) 
              else
                callback( "Record not found", null )    

            .on 'failure', (err) ->
              callback( err, null )

        #
        # Update record 
        #
        updateRecord = ( record, callback ) ->
          #
          # Assigning data to record's fields
          #
          for value of data
            record[value] = data[value]
                  
          #
          # Saving the record
          #
          record.save()
            .on 'success', (record) ->
              callback(null, record )
            .on 'failure', (err) ->
              callback(err, null)

        #
        # Start process
        #
        getExistingRecord()

      #
      # Deleting langs
      # "data" contains a JSON array with filter to apply (=SQL WHERE)
      #
      delete : (data, callback) ->        
        requestCount = 0
        
        @findAll({where:data})
          .on 'success', (langs) =>
            #
            # We will launch as many delete requests than langs found
            #
            requestCount += langs.length

            #
            # Do deletion
            #
            for lang in langs              
              lang.destroy()
                .on 'success', (lang)->
                  requestCount--
                  if requestCount is 0
                    callback( null )

                .on 'failure', (err) ->
                    callback( err )

          #
          # Failure when searching langs to delete
          #    
          .on 'failure', (err) ->
            console.log "Lang deletion error,", err
            callback( err )
