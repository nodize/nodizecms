# Nodize core "ionize" module
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Copyright 2012-2013, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  _moduleName = "ionize"

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

  # Managing all other cases
  @all '*': (req, res) =>

    @catch_all( req, res )


  @catch_all = ( req, res ) =>
    name = req.params[0]

    #
    # We don't intercept request for zappa.js client libs
    #
    if name in ["/zappa/zappa.js", "/zappa/Zappa.js", "/zappa/Zappa-simple.js", "/zappa/jquery.js" ] or name.indexOf("/zappa/socket/") is 0
      #console.log "passthru ->", name
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
      if segments[1] in Static_langs?
        lang = segments[1]
        #
        # Remove lang segment
        #
        segments.splice( 1, 1 )
        name = segments.join("/")
        #
        # Do the redirection
        #
        res.redirect( name )
      else
        res.send("you are requesting #{req.params[0]} (file extension:#{ext})", 404)

  #
  # Error management
  #
  nodizeErrorHandler = (err, req, res, next) ->
    res.send( 500, "Nodize error <hr/>"+err )
    console.log "Nodize error \r\n", err.stack

  @configure
    development: => @use nodizeErrorHandler
    production: => @use 'errorHandler'

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
nodize_db = require __applicationPath+"/modules/ionize/libs/nodize_db"



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
