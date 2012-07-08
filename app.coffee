
#
#  ._   _           _ _         
#  | \ | |         | (_)        
#  |  \| | ___   __| |_ _______ 
#  | . ` |/ _ \ / _` | |_  / _ \
#  | |\  | (_) | (_| | |/ /  __/
#  \_| \_/\___/ \__,_|_/___\___|
#
#  v0.0.4
#
#  Nodize CMS by Hypee (c)2012 (www.hypee.com)
#  Released under MIT License
#
#  

#
# Retrieve database configuration from json setting file
#
fs = require 'fs'
path = require 'path'

nodizeSettings = require 'nconf'
global.__nodizeSettings = nodizeSettings

#
# If a local file exists we use it, else we fallback on the regular settings file
#
if path.existsSync( 'settings/nodize.local.json')
  nodizeSettingsFile = 'settings/nodize.local.json' 
else
  nodizeSettingsFile = 'settings/nodize.json' 

nodizeSettings.add( 'nodize', {type: 'file', file:nodizeSettingsFile } )

#
# Starting profiler if specified in settings
#
require("nodetime").profile() if nodizeSettings.get("nodetime_profiler")

application = ->
    
  @use bodyParser:{ uploadDir: __dirname+'/uploads' } # Needed to get POST params & handle uploads
  
  #@use 'debug' # Connect debug middleware, uncomment to activate
  #@use 'responseTime' # Display response time in HTTP header, uncomment to activate
  
  
  
  #
  # Storing application path & theme path for later use in modules
  #
  global.__applicationPath = __dirname
  global.__nodizeTheme = nodizeSettings.get( "theme" )
  global.__sessionSecret = nodizeSettings.get( "session_secret" )
  global.__adminPassword = nodizeSettings.get( "admin_password" )  
  
  
  global.__default_lang = 'en'
 
  # Allow to request static content from /public folder of current theme
  @use 'staticCache'
  @use 'static': __dirname + "/themes/" + __nodizeTheme + "/public" 


  @use 'cookieParser'
  @use 'cookieDecoder'
 
  #
  # Using redis as session store (if option redis-enabled is set)
  #
  if nodizeSettings.get("redis_enabled")
    RedisStore = require('connect-redis')(@express)
    global.__sessionStore = new RedisStore
    
    @use 'session':{
      secret: __sessionSecret
      store: __sessionStore
    }
  else  
    # Including Nodize MySQL/SQLite session store (use same database dialect than specified in config file)
    @include './modules/nodize-sessions/module_nodize-sessions.coffee'
    
  

  #
  # Logging connexions to /logs/access.log file
  #  
  logFile = fs.createWriteStream('./logs/access.log', {flags:'a'})
  #@use 'logger':{stream:logFile}

  #
  # Defining views folder, in current theme
  #
  @set 'views' : __dirname + "/themes/" + __nodizeTheme + "/views"

  #
  # Activating jade engine
  # 
  # @register jade: @zappa.adapter 'jade' # Uncomment to use jade engine

  #
  # Event engine
  #
  EventEmitter = require( "events" ).EventEmitter
  global.__nodizeEvents = new EventEmitter();  
  
  #  
  # Defining helpers container
  #
  @helpers = {}
  
  # Including backend/administration module
  @include './modules/backend/module_backend.coffee'

  # Including theme/site modules
  _moduleName = "ionize"


  #
  # LOADING VIEWS, HELPERS, CONTROLLERS from THEME'S MODULES
  #
  fs = require 'fs'
  path = require 'path'

  themeModuleDir = './themes/'+__nodizeTheme+'/modules'

  if path.existsSync themeModuleDir
    modules = fs.readdirSync themeModuleDir
    for _moduleName in modules
      console.log "Module found :",_moduleName
      includeFolders = []
      includeFolders.push themeModuleDir+"/"+_moduleName+"/views/"
      includeFolders.push themeModuleDir+"/"+_moduleName+"/controllers/"
      includeFolders.push themeModuleDir+"/"+_moduleName+"/helpers/"

      for includeFolder in includeFolders
        if path.existsSync includeFolder
          files = fs.readdirSync includeFolder
          @include includeFolder+file for file in files

      #
      # Load main module file, if it exists
      #
      includeFile = themeModuleDir+"/"+_moduleName+"/module_"+_moduleName
      @include includeFile




  # Must be the last module, it's handling the "catch all" router
  @include './modules/ionize/module_ionize.coffee'

  # Retrieving helpers defined in modules, making them available to views
  helpers = @helpers

  

nodize = require('zappajs').app( application, {disable_io: false, require_css: []} )


#
# Desactivating socket.io console debug messages
#
nodize.io.set 'log level', 1

#
# Defining the port we listen on
# Default to 3000
#
port = process.env.PORT or 3000


#
# Start the server
#

cluster = require 'cluster'



# Cluster mode enabled if cores > 0
numCPUs = nodizeSettings.get( "cores" )
# Use all available cores if cores = 'max'
numCPUs = require('os').cpus().length if numCPUs is 'max'

if cluster.isMaster
  console.log "ZappaJS", nodize.zappa.version, "orchestrating the show"

  console.log """
  ._   _           _ _         
  | \\ | |         | (_)        
  |  \\| | ___   __| |_ _______ 
  | . ` |/ _ \\ / _` | |_  / _ \\
  | |\\  | (_) | (_| | |/ /  __/
  \\_| \\_/\\___/ \\__,_|_/___\\___|

  """
  console.log "listening on port",port

  console.log "using",numCPUs," CPU(s)" if numCPUs>0

  #
  # In development mode, set numCPU to 0 to allow clean automatic reload when using run.js
  #
  if numCPUs>0
    # Fork workers.
    for i in [1..numCPUs] 
      cluster.number = i
      cluster.fork()
      
      cluster
        .on 'death', ->
          console.log 'worker ' + worker.pid + ' died'
  else
    nodize.app.listen( port )

else 
  # Worker processes have a Express/Zappa/Nodize server.

  console.log "Cluster", cluster.pid, "started" if cluster.pid # pid seems to be available in node.js >= 0.6.12
  nodize.app.listen( port )  

#
# THROW INITIALIZATION EVENT
#
#
__nodizeEvents.emit  'initialization', 'application ready'



