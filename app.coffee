
#
#  ._   _           _ _
#  | \ | |         | (_)
#  |  \| | ___   __| |
#  | . ` |/ _ \ / _` | |_  / _ \
#  | |\  | (_) | (_| | |/ /  __/
#  \_| \_/\___/ \__,_|_/___\___|
#
#  v0.0.5
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
sugar = require 'sugar'
io = require 'socket.io'

nodizeSettings = require 'nconf'
global.__nodizeSettings = nodizeSettings


existsSync = fs.existsSync or path.existsSync
#
# If a local file exists we use it,
# else we fallback on the regular settings file
#
if existsSync( 'settings/nodize.local.json')
  nodizeSettingsFile = 'settings/nodize.local.json'
else
  nodizeSettingsFile = 'settings/nodize.json'

nodizeSettings.add( 'nodize', {type: 'file', file:nodizeSettingsFile } )

nodize = ->

  require "./modules/ionize/libs/express_multiple_views"

  # Needed to get POST params & handle uploads
  @use bodyParser:{ uploadDir: __dirname+'/uploads' }
  
  # Disabling Express native cache, you'll have to use Nodize's cache to speed up your website
  # Required to make Jade templates work correctly
  @disable "view cache"

  #@use 'debug' # Connect debug middleware, uncomment to activate

  # Display response time in HTTP header, uncomment to activate
  #@use 'responseTime'
  
  #
  # Desactivating socket.io console debug messages
  #
  #nodize.io.set 'log level', 1
  @io.set 'log level', 1

  #@use 'partials'


  #@use @myPartials
  ###@use 'partials':
    coffee: @zappa.adapter 'coffeecup'
    jade: @zappa.adapter 'jade'###

  #
  # Storing application path & theme path for later use in modules
  #
  global.__applicationPath = __dirname
  global.__nodizeTheme = nodizeSettings.get( "theme" )
  global.__sessionSecret = nodizeSettings.get( "session_secret" )
  global.__adminPassword = nodizeSettings.get( "admin_password" )
  
  
  global.__default_lang = 'en'
 
  # Allow to request static content from /public folder of current theme
  @use 'static': __dirname + "/themes/" + __nodizeTheme + "/public"

  #@use 'partials'

  @use 'cookieParser'
  @use 'cookieDecoder'
 
  #
  # Using redis as session store (if option redis-enabled is set)
  #
  if nodizeSettings.get("redis_enabled")
    console.log "Using redis session store"
    RedisStore = require('connect-redis')(@express)
    global.__sessionStore = new RedisStore
    
    @use 'session':{secret: __sessionSecret, store: __sessionStore}
  else
    # Including Nodize MySQL/SQLite session store
    # (use same database dialect than specified in config file)
    console.log "Loading Nodize session module"
    @include './modules/nodize-sessions/module_nodize-sessions.coffee'
    
  

  #
  # Logging connexions to /logs/access.log file
  #
  logFile = fs.createWriteStream('./logs/access.log', {flags:'a'})
  #@use 'logger':{stream:logFile}

  #
  # Defining views folder, in current theme
  #
  @set 'views' : [ __dirname + "/themes/" + __nodizeTheme + "/views" ]

  #
  # Express 3.x compatibility with "old" template engines
  #
  @app.engine "eco", require("consolidate").eco

  #
  # Event engine
  #
  EventEmitter = require( "events" ).EventEmitter
  global.__nodizeEvents = new EventEmitter()


  #
  # Express session available in Socket.io
  #
  @include "./modules/ionize/libs/session_socketio_express.coffee"

  #
  # Defining helpers container
  #
  @helpers = {}

  #
  # Express routes removal, used by lazy loading
  #
  @include "./modules/ionize/libs/express_route_unmount.coffee"

  # Backend, lazy loading (not ready yet)
  #@include "./modules/backend/loader_backend.coffee"

  # Including backend/administration module
  @include "./modules/backend/module_backend.coffee"

  # Including theme/site modules
  _moduleName = "ionize"

  #
  # LOADING VIEWS, HELPERS, CONTROLLERS from THEME'S MODULES
  #
  fs = require 'fs'
  path = require 'path'

  themeModuleDir = './themes/'+__nodizeTheme+'/modules'



  if existsSync themeModuleDir
    modules = fs.readdirSync themeModuleDir

    #
    # Sorting modules, to allow module with a name
    # starting with "_" to be loaded first
    #
    modules = modules.sort()
    
    for _moduleName in modules
      console.log "Loading module (#{_moduleName})"
      includeFolders = []


      #
      # Adding the module's "views" folder as valid view folder
      #
      if existsSync themeModuleDir+"/"+_moduleName+"/views/"
        views = @app.get "views"
        views.push themeModuleDir+"/"+_moduleName+"/views/"


      includeFolders.push themeModuleDir+"/"+_moduleName+"/inline_views/"
      includeFolders.push themeModuleDir+"/"+_moduleName+"/controllers/"
      includeFolders.push themeModuleDir+"/"+_moduleName+"/helpers/"

      for includeFolder in includeFolders
        if existsSync includeFolder
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







#
# Defining the port we listen on
# Default to 3000
#
port =  process.env.VCAP_APP_PORT or # Used by AppFog 
        process.env.PORT or 
        nodizeSettings.get( "server_port" ) or # Defined in "/settings/nodize.json" of "/settings/nodize.local.json"
        3000


#
# Start the server
#

cluster = require 'cluster'

zappa = require("zappajs")




# Cluster mode enabled if cores > 0
numCPUs = nodizeSettings.get( "cores" )
# Use all available cores if cores = 'max'
numCPUs = require('os').cpus().length if numCPUs is 'max'

if cluster.isMaster
  #console.log "ZappaJS", zappa.version, "orchestrating the show"

  console.log """
  ._   _           _ _
  | \\ | |         | (_)
  |  \\| | ___   __| |_ _______
  | . ` |/ _ \\ / _` | |_  / _ \\
  | |\\  | (_) | (_| | |/ /  __/
  \\_| \\_/\\___/ \\__,_|_/___\\___|

  """
  #console.log "listening on port",port

  console.log "using",numCPUs," CPU(s)" if numCPUs>0

  #
  # In development mode, set numCPU to 0 to allow clean
  # & automatic reload when using run.js
  #
  if numCPUs>0
    # Fork workers.
    for i in [1..numCPUs]
      cluster.number = i
      console.log "app | Forking on CPU", i

      cluster.fork()
      
      cluster.on 'death', ->
        console.log 'worker ' + worker.pid + ' died'
  else
    #nodize.app.listen( port )
    
    require( "zappajs")( nodize, port )

else
  # Worker processes have a Express/Zappa/Nodize server.

  # pid seems to be available in node.js >= 0.6.12
  console.log "Cluster", cluster.pid, "started" if cluster.pid

  require( "zappajs")( nodize, port )

#
# THROW INITIALIZATION EVENT
#
#
# __nodizeEvents.emit  'initialization', 'application ready'





