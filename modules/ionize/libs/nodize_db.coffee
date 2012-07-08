sequelize = null
config = null

init = ->
  #
  # TODO:Should be put in a module
  #
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
    
    console.log "** Using database settings from",databaseSettingsFile,"->",config.get('database')

    # Connecting to the database
    sequelize = new Sequelize( config.get('database'),config.get('user'), config.get('password'), 
      { 
        host: config.get('host')
        logging:  config.get('logging')
        dialect: config.get('dialect')
        storage: global.__applicationPath+'/database/db.sqlite'
        define: { timestamps: false, freezeTableName: true }      
        maxConcurrentQueries:50
      }
    )

init()

module.exports = sequelize
exports.config = config

