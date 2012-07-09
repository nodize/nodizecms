sequelize = null
config = null

init = ->  
  if not sequelize  
    console.log "sequelize initialization"
    Sequelize = require 'sequelize'
    nconf = require 'nconf'
  
    #
    # Looking for specific settings for the current theme
    #
    fs = require 'fs'
    themeDatabaseSettingsFile = 'themes/'+__nodizeTheme+'/settings/database.json'
    try
      result = fs.statSync themeDatabaseSettingsFile
      #
      # Using theme's settings
      #
      databaseSettingsFile = themeDatabaseSettingsFile
    catch error
      #
      # Using default's settings
      #
      databaseSettingsFile = 'settings/database.json'

    #
    # Retrieve database configuration from json setting file
    #
    nconf.add( 'config', {type: 'file', file:databaseSettingsFile } )
    config = nconf
    
    console.log "Using database settings from",databaseSettingsFile,"->",config.get('database')
          

    # Connecting to the database
    sequelize = new Sequelize( config.get('database'),config.get('user'), config.get('password'), 
      { 
        host: config.get('host')
        logging:  config.get('logging')
        dialect: config.get('dialect')
        storage: global.__applicationPath+'/database/db.sqlite'
        define: { timestamps: false, freezeTableName: true }      
        maxConcurrentQueries:50
        pool: { maxConnections: 5, maxIdleTime : 30 }
      }
    )

    

    #
    # TableVersion definition
    #
    TableVersion = sequelize.define 'tableVersion',
      name       : Sequelize.STRING
      version    : Sequelize.INTEGER 
    #
    # Create tableVersion if doesn't exists
    #
    sequelize.sync() 
    sequelize.TableVersion = TableVersion
    
    #
    # Migrations management
    #    

    # Retrieving object to make low level database calls for migrations
    queryInterface = sequelize.getMigrator().queryInterface

    class Migrator
      constructor: (table) ->
        @table = table

      setTable: (table) ->
        @table = table

      addColumn: (name, datatype) ->
        # console.log "[#{@table}] adding column"
        queryInterface.addColumn( @table, name, datatype )
          # .on 'success', ->
            # console.log "success"
          .on 'failure', (err) ->
            console.log "error", err

      doMigrations: (tableName, migrations ) ->
        @table = tableName
        #
        # Search for table version 
        #
        sequelize.TableVersion.find( { where:{'name':tableName} } )
          .on "success", (tableVersion) ->
            if tableVersion
              
              #
              # Last element of "migrations" array has to be the last version
              #
              lastVersion = migrations[ migrations.length-1 ].version

              #
              # We have a version for this table, we check if migration are needed
              #  
              for migration in migrations
                if lastVersion >= migration.version > tableVersion.version
                  console.log "[#{tableName}] applying upgrade to version #{migration.version}"
                  migration.code()

              #
              # Version update if needed
              #
              if tableVersion.version<lastVersion
                tableVersion.version = lastVersion
                tableVersion.save()
                  .on 'success', (tableVersion) ->
                    console.log "[#{tableVersion.name}] updated to version ", tableVersion.version
                  .on 'failure', (err) ->
                    console.log "Database error", err

            else
              #
              # No version found for this table, we expect to have the last version (just created) 
              #
              tableVersion = TableVersion.build()
              tableVersion.name = tableName
              tableVersion.version = lastVersion
              tableVersion.save()
                .on 'success', (tableVersion) ->
                  console.log "version created for", tableVersion.name
                .on 'failure', (err) ->
                  console.log "Database error", err


          .on "failure", (err) ->
            console.log "fail", err

        

    sequelize.migrator = new Migrator

    sequelize.getMigrator = (tableName) ->
      migrator = new Migrator( tableName )



init()



#console.log sequelize.getMigrator().queryInterface

module.exports = sequelize
exports.config = config

