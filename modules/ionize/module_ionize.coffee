# Nodize core "ionize" module
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
  _moduleName = "ionize"

  z = require('zappajs')
  console.log z.app

  #**********************************
  #* LOADING VIEWS, HELPERS, CONTROLLERS
  #** 
  fs = require 'fs'
  #path = require 'path'
   
  includeFolders = []
  includeFolders.push "./modules/#{_moduleName}/views/"
  includeFolders.push "./modules/#{_moduleName}/controllers/"
  includeFolders.push "./modules/#{_moduleName}/helpers/"

  for includeFolder in includeFolders
    if fs.existsSync includeFolder
      files = fs.readdirSync includeFolder
      @include includeFolder+file for file in files

  #**********************************
  #* HELPERS FOR JADE ENGINE
  #**  
  jade_support = require __applicationPath+"/modules/ionize/libs/jade_helpers_filters"
  jade_support.createFilters( @helpers )

  #**********************************
  #* CATCH ALL & PAGES DISPLAY MANAGEMENT
  #**  
  
  # Managing all other cases (problem w/ zappa/zappa.js which is intercepted)
  @get '*': (req, res) =>
    name = req.params[0]

    #
    # We don't intercept request for zappa.js client lib
    #
    if name=="/zappa/Zappa.js"
      req.next()
      return 

    #
    # Looking for a matching page in Ionize database (if no extension is specified)
    #
    ext = getExt(name)

    if ext == ""
      name=name.replace( "/", "" )
      @ionize_displayPage( req, res, @helpers, name )
    else
      #
      # Extracting lang from URI
      #
      segments = name.split('/')
            
      #
      # Redirect to / path for resources if lang is specified
      # (/en/css/styles.css is redirected to /css/styles.css)
      #
      if segments[1] in Static_langs
        lang = segments[1]
        #
        # Remove lang segment
        #
        segments.splice( 1, 1 )
        name = segments.join("/") 
        #
        # Do the redirection
        #       
        req.redirect( name )
      else
        res.send("you are requesting #{req.params[0]} (file extension:#{ext})", 404)

      

#**********************************
#* GENERIC FUNCTIONS
#**

# Return file extension
# @param {string} file name
# @return {string} file extension, without the .
getExt = (filename) ->
  ext = filename.split('.').pop();
  if ext == filename
    ''
  else
    ext

#**********************************
#* LANGS
#**

#
# Load translation from settings folder
# TODO: auto load existing files
#
nconf = require 'nconf'

nconf.add( 'lang_en', {type: 'file', file:'settings/langs/lang_en.json' } )
nconf.add( 'lang_fr', {type: 'file', file:'settings/langs/lang_fr.json' } )

global.ion_lang = {}
ion_lang['en'] = nconf.get "en"
ion_lang['fr'] = nconf.get "fr"

#
# Monkey patching Date, to allow returning date in MySQL format
#
Date::_toMysql = ->
  if isNaN( this.getDate() )
    strDate = ''
  else  
    strDate = this.getFullYear()+'-'
    
    # Month starts at 0, we add 1 for human display
    strDate += '0' if parseInt(this.getMonth())<=8
    strDate += this.getMonth()+1+'-'
    
    strDate += '0' if this.getDate()<=9
    strDate += this.getDate()+' '
    
    strDate += '0' if this.getHours()<=9
    strDate += this.getHours()+':'
    strDate += '0' if this.getMinutes()<=9
    strDate += this.getMinutes()+':00'

  return strDate

#
# Monkey patching String, to emulate "Date" fields when using SQLite
#
String::_toMysql = ->
  myDate = new Date()
  if isNaN( myDate.getDate(this) )
    strDate = ''
  else  
    date = myDate.getDate( this )
    return ""

    strDate = date.getFullYear()+'-'
    strDate += '0' if date.getMonth()<=9
    strDate += date.getMonth()+1+'-'
    strDate += '0' if date.getDate()<=9
    strDate += date.getDate()+' '
    
    strDate += '0' if date.getHours()<=9
    strDate += date.getHours()+':'
    strDate += '0' if date.getMinutes()<=9
    strDate += date.getMinutes()+':00'

  return strDate

String::getDate = ->
  return ""

String::getMonth = ->
  return ""

#**********************************
#* DATABASE MODELS
#*
#**

#
# Connecting to the database & creating models
#
db = require __applicationPath+"/modules/ionize/libs/nodize_db"
global.DB = db

#
# Retrieve models
#
Article           = db.import( __dirname + "/models/model_article" )
Article_lang      = db.import( __dirname + "/models/model_articleLang" )
Article_media     = db.import( __dirname + "/models/model_articleMedia" )
Article_type      = db.import( __dirname + "/models/model_articleType" )
Article_category  = db.import( __dirname + "/models/model_articleCategory" )
Category          = db.import( __dirname + "/models/model_category" )
Category_lang     = db.import( __dirname + "/models/model_categoryLang" )
Lang              = db.import( __dirname + "/models/model_lang" )
Menu              = db.import( __dirname + "/models/model_menu" )
Media             = db.import( __dirname + "/models/model_media" )
Page              = db.import( __dirname + "/models/model_page" )
Page_article      = db.import( __dirname + "/models/model_pageArticle" )
Page_lang         = db.import( __dirname + "/models/model_pageLang" )
User              = db.import( __dirname + "/models/model_user" )
User_group        = db.import( __dirname + "/models/model_userGroup" )


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
