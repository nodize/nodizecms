# MySQL session store module
# Based on https://github.com/CarnegieLearning/connect-mysql-session
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Copyright 2012, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  console.log( "Module nodize-sessions loaded" )
  _moduleName = "nodize-sessions"

  Store = @express.session.Store
  #Sequelize = require("sequelize")

  #
  # Retrieve database configuration from json setting file
  #
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

  nconf.add( 'config', {type: 'file', file:databaseSettingsFile } )
  config = nconf

  console.log "Using database settings from",databaseSettingsFile,"->",config.get('database')

  Sequelize = require 'sequelize'

  # Connecting to the database
  sequelize = new Sequelize( config.get('database'),config.get('user'), config.get('password'), 
    { 
      host: config.get('host'), 
      logging:  config.get('logging'), 
      dialect: config.get('dialect'),
      storage: global.__applicationPath+'/database/db.sqlite',
      define: { timestamps: false, freezeTableName: true },
      maxConcurrentQueries:500; 
    }
  )
  
  global.sequelize = sequelize
  sequelize.sync()

  global.initialized = false

  #
  # MySQL SESSION STORE OBJECT
  #
  class MySQLStore extends @express.session.Store 

    #
    # Creates the table if needed
    #
    initialize = (callback) ->
      unless global.initialized
        sequelize.sync(force: @forceSync)
        .on "success", ->
          console.log config.get('dialect')," session store initialized."
          global.initialized = true
          callback()
        .on "failure", (error) ->
          console.log "Failed to initialize sequelize session store:"
          console.log error
          callback error
      else
        callback()

    constructor: ( options) ->    
      options = options or {}
      Store.call this, options
      self = this

      @forceSync = options.forceSync or false
      checkExpirationInterval = options.checkExpirationInterval or 1000 * 60 * 10
      @defaultExpiration = options.defaultExpiration or 1000 * 60 * 60 * 24
      
      #
      # Defining table structure
      #
      @Session = sequelize.define("session_store",
        sid:
          type: Sequelize.STRING
          unique: true
          allowNull: false

        expires: Sequelize.INTEGER
        json: Sequelize.TEXT
      )

      @initialized = false

      setInterval (=>        
        initialize (error) =>
          return if error
          @Session.findAll(where: [ "expires < ?", Math.round(Date.now() / 1000) ]).on("success", (sessions) ->
            if sessions.length > 0
              console.log "Destroying " + sessions.length + " expired sessions."
              for i of sessions
                sessions[i].destroy()
          ).on "failure", (error) ->
            console.log "Failed to fetch expired sessions:"
            console.log error
      ), checkExpirationInterval


    get : (sid, fn) ->
      initialize (error) =>
        return fn(error, null)  if error
                
        @Session.find(where: { sid: sid } )
          .on "success", (record) ->
            # With SQLite, " are replaced with \" 
            # TODO: submit an issue + test to sequelize git repo if confirmed 
            if record
              record.json = record.json.replace(/\\/g,"") 

            session = record and JSON.parse(record.json)
            fn null, session
          .on "failure", (error) ->
            fn error, null

    set : (sid, session, fn) ->
      initialize (error) =>
        return fn and fn(error)  if error
        
        @Session.find(where:
          sid: sid
        ).on("success", (record) =>
          record = @Session.build(sid: sid)  unless record
          record.json = JSON.stringify(session)
          expires = session.cookie.expires or new Date(Date.now() + @defaultExpiration)
          record.expires = Math.round(expires.getTime() / 1000)
          record.save().on("success", ->
            fn and fn()
          ).on "failure", (error) ->
            fn and fn(error)
        ).on "failure", (error) ->
          fn and fn(error)

    destroy : (sid, fn) ->
      initialize (error) =>
        return fn and fn(error)  if error
        @Session.find(where:
          sid: sid
        ).on("success", (record) ->
          if record
            record.destroy().on("success", ->
              fn and fn()
            ).on "failure", (error) ->
              console.log "Session " + sid + " could not be destroyed:"
              console.log error
              fn and fn(error)
          else
            fn and fn()
        ).on "failure", (error) ->
          fn and fn(error)

    length : (callback) ->
      initialize (error) =>
        return callback(null)  if error
        @Session.count().on("success", callback).on "failure", ->
          callback null

    clear : (callback) ->
      sequelize.sync
        force: true
      , callback

  global.__sessionStore = new MySQLStore(
      cookie:
        maxAge: 4 * 7 * 24 * 60 * 60 * 1000
    )
  #
  # Starting the session manager
  #
  @use 'session':{
    secret: __sessionSecret
    store: __sessionStore
  }








