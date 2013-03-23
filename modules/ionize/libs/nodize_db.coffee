# Nodize database management library
#
# Also used to handle migrations
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
    
    #
    # If we are in test mode, a specific database setting files must be defined
    #
    switch process.env.NODE_ENV
      when 'test'
        themeDatabaseSettingsFile = 'themes/'+__nodizeTheme+'/settings/database.test.json'
      else
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
        port: if config.get('port') then config.get('port') else 3306
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
      .error ->
        console.log "nodize_db | Sync error"
      .success ->
        # Action to run once the "tableVersion" has been created
        initializeTables( sequelize )


        
        
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
        queryInterface.addColumn( @table, name, {type:datatype, allowNull : true} )
          # .on 'success', ->
            # console.log "success"
          .on 'failure', (err) ->
            console.log "error", err

      removeColumn: (name) ->
        # console.log "[#{@table}] removing column"
        queryInterface.removeColumn( @table, name )
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
            #
            # Last element of "migrations" array has to be the last version
            #
            lastVersion = migrations[ migrations.length-1 ].version

            if tableVersion
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
                  console.log "Table '#{tableVersion.name}' created, @version #{tableVersion.version}"
                .on 'failure', (err) ->
                  console.log "Database error", err


          .on "failure", (err) ->
            console.log "fail", err



    sequelize.migrator = new Migrator

    sequelize.getMigrator = (tableName) ->
      migrator = new Migrator( tableName )


initializeTables = (db) ->
  global.DB = db

  #
  # Retrieve models
  #
  Article           = db.import( __dirname + "/../models/model_article" )
  Article_lang      = db.import( __dirname + "/../models/model_articleLang" )
  Article_media     = db.import( __dirname + "/../models/model_articleMedia" )
  Article_type      = db.import( __dirname + "/../models/model_articleType" )
  Article_category  = db.import( __dirname + "/../models/model_articleCategory" )
  Category          = db.import( __dirname + "/../models/model_category" )
  Category_lang     = db.import( __dirname + "/../models/model_categoryLang" )
  Lang              = db.import( __dirname + "/../models/model_lang" )
  Menu              = db.import( __dirname + "/../models/model_menu" )
  Media             = db.import( __dirname + "/../models/model_media" )
  Page              = db.import( __dirname + "/../models/model_page" )
  Page_article      = db.import( __dirname + "/../models/model_pageArticle" )
  Page_lang         = db.import( __dirname + "/../models/model_pageLang" )
  User              = db.import( __dirname + "/../models/model_user" )
  User_group        = db.import( __dirname + "/../models/model_userGroup" )


  #
  # Run migrations
  #
  Article.migrate()
  Article_category.migrate()
  Article_lang.migrate()
  Article_media.migrate()
  Article_type.migrate()
  Category.migrate()
  Category_lang.migrate()
  Lang.migrate()
  Media.migrate()
  Menu.migrate()
  Page.migrate()
  Page_article.migrate()
  Page_lang.migrate()
  User.migrate()
  User_group.migrate()

  #
  # Associations, not used right now
  # Seems to need an "id" field to work
  #
  Page.hasMany( Page_lang, {as:"Langs", foreignKey: 'id_page'} )
  User.hasOne( User_group, {as:"Group", foreignKey: 'id_group'} )

  #
  # Remapping id fields, for compatibility w/ Ionize (www.ionizecms.com) database,
  # we might break compatibily in later version to have cleaner DB structure
  #
  DB.query( "UPDATE page SET id = id_page" )
  DB.query( "UPDATE menu SET id = id_menu")
  #DB.query( "UPDATE article_lang SET id = id_article" )



  #
  # Give a global access to these DB objects
  #
  global.Article            = Article
  global.Article_lang       = Article_lang
  global.Article_media      = Article_media
  global.Article_type       = Article_type
  global.Article_category   = Article_category
  global.Category           = Category
  global.Category_lang      = Category_lang
  global.Lang               = Lang
  global.Menu               = Menu
  global.Media              = Media
  global.Page               = Page
  global.Page_lang          = Page_lang
  global.Page_article       = Page_article
  global.User               = User
  global.User_group         = User_group

  #
  # Keeping a in-memory static array of langs,
  # for simplicity & speed
  #
  updateStaticLangs = ->
    Lang.findAll({order:'ordering'})
      .on 'success', (langs) ->
        global.Static_lang_default = lang.lang for lang in langs when lang.def is 1
        global.Static_langs = (lang.lang for lang in langs)
        global.Static_langs_records = langs
      .on 'failure', (err) ->
        console.log 'database error ', err
        global.Static_langs = 'en'
        global.Static_langs_records = ['en']
        global.Static_lang_default = 'en'

  #
  # Creating a basic structure if the database is empty
  #
  initDatabase = ->


    #
    # Generating a simple random password
    #
    randomString = ->
      #chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz"
      chars = "0123456789AB"
      string_length = 5;
      randomString = '';
      for i in [1..string_length]
        rnum = Math.floor(Math.random() * chars.length)
        randomString += chars.substring(rnum,rnum+1)

      return randomString

    #
    # Create SuperAdmin group
    #
    createGroup = ->
      user_group = User_group.build()
      user_group.group_name = "SuperAdmin"
      user_group.id_group = 1
      user_group.level = 10000
      user_group.save()
        .on "success", (user_group)->
          console.log "SuperAdmin group created"
          createAdmin( user_group )
        .on "failure", (err) ->
          console.log "Error on group creation", err

    #
    # Creating admin user
    #
    createAdmin = (group) ->
      crypto = require "crypto"
      hmac = crypto.createHmac("sha1", __sessionSecret)
      password = randomString()
      hash = hmac.update password

      crypted = hash.digest(encoding="base64")

      user = User.build()
      user.username = "admin"
      user.password = crypted
      user.id_group = group.id_group

      user.save()
        .on "success", ->
          console.log "Default user created, login = admin, password =", password
          createLang()
        .on "failure", (err) ->
          console.log "Error on database initialization :", err

    #
    # Creating lang
    #
    createLang =->
      lang = Lang.build()
      lang.lang = "en"
      lang.name = "English"
      lang.online = 1
      lang.def = 1
      lang.ordering = 1

      lang.save()
        .on "success", ->
          console.log "Default lang created"
          updateStaticLangs()
          createMenu()

    #
    # Creating menus
    #
    createMenu = ->
      menu = Menu.build()
      menu.title = "Main Menu"
      menu.name = "main"
      menu.ordering = 1

      menu.save()
        .on "success", (menu) ->
          menu.id_menu = menu.id
          menu.save()
            .on 'success', ->
              console.log "Default menu created"

      menu = Menu.build()
      menu.title = "System"
      menu.name = "system"
      menu.ordering = 2

      menu.save()
        .on "success", (menu) ->
          menu.id_menu = menu.id
          menu.save()

    #
    # Start process
    #
    createGroup()

  # ---------------------------
  # EVENTS
  #
  __nodizeEvents
    #
    # Page has been updated, we could store pages in a static JSON array
    # TODO: should probably be in backend module
    #
    .on 'pageSave', (message)->
      #console.log( "PageSave event in mod_ionize -> ", message )
      return


    #
    # Langs have been modified, we rebuild the static array
    #
    .on 'langsUpdate', (message) ->
      updateStaticLangs()




  #
  # Creating tables that doesn't exist in database
  #
  DB.sync()
    .on "success", ->
      User.count()
        .on "success", (count)->
          #
          # Create default base records
          #
          if count is 0
            initDatabase()

          #
          # Normal boot
          #
          else
            updateStaticLangs()

    .on "failure", (err) ->
      console.log "Database synchronisation error :", err




init()


#console.log sequelize.getMigrator().queryInterface

module.exports = sequelize
exports.config = config
exports.boot = "BooYTa"


