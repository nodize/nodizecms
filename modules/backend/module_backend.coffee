@include = ->
  #
  # Defining the current module name
  # Must be the same than the folder name,
  # it will be used to load views, models, helpers... 
  #
  _moduleName = "backend"
  _moduleAssetsPath = "/backend" # Subfolder in module/public path used to store assets

  @Settings = {}
  @Settings['assetsPath'] =  _moduleAssetsPath
  

  console.log( "Module ", _moduleName, " loaded" )

  @use 'static': __dirname + "/public" # Allow to request static content from /public folder of the module
  
  #**********************************
  #* ROUTES
  #* 
  #* ROUTES ORDER IS SUPER IMPORTANT, you might break access security if you change it 
  #**      


  # Access to admin page with lang specified
  @get "/:lang/admin/login" : (req) ->
    @render 'backend_login',
      hardcode    : @helpers
      layout      : no 
      lang        : req.params.lang
      ion_lang    : ion_lang[ req.params.lang ]
      assetsPath  : _moduleAssetsPath

  #
  # LOGIN/PASSWORD POST
  # Checking if user can log in
  #
  @post "/:lang/admin/login" : (req) -> 
    values = req.body

    #
    # If user exists and password is ok, let the user in
    # TODO: also check that the group is valid for backoffice access
    #
    validateUser = ->
      User.find({where:{username:values.username}})
        .on 'success', (user) ->
          crypto = require "crypto"
          hmac = crypto.createHmac("sha1", __sessionSecret)
          hash = hmac.update values.password
      
          #
          # A temp admin password can be set in settings/nodize.json if password is lost 
          #
          if user?.password is hash.digest(encoding="base64") or values.password is __adminPassword
            req.session.authenticated = true
            req.session.user = values.username

            #
            # Get user group(s) info
            # TODO: Manage multiple groups
            #
            User_group.find({where:{id_group:user?.id_group}})
              .on 'success', (user_group) ->
                if user_group
                  req.session.usergroup_name = user_group.group_name 
                  req.session.usergroup_level = user_group.level

                req.redirect "/#{req.params.lang}/admin"          
              .on 'failure', (err) ->
                console.log 'database error ', err
            

            
          else 
            req.redirect "/#{req.params.lang}/admin/login"

        .on 'failure', (err) ->
          console.log 'database error ', err
          req.redirect "/#{req.params.lang}/admin/login"      

    validateUser()  

  #
  # LOGIN OUT
  #
  @get "/:lang?/admin/logout" : (req) ->   
    #
    # Authentication's session values reset 
    # 
    req.session.authenticated = false
    req.session.user = null
    req.session.usergroup_name = null
    req.session.usergroup_level = null

    #
    # Redirect to login page
    #
    path = @params.lang or ""
    path = "/"+path if path isnt ""

    @redirect path+"/admin/login"  

  #
  # Securing admin routes, redirecting to login page if needed
  #
  @get "/:lang/admin*" : (req) ->        
    if req.session and req.session.authenticated is true
      @next()
    else      
      @redirect "/#{@params.lang}/admin/login"


  @get "/admin*" : (req) ->
    if (req.session and req.session.authenticated is true)
      @next()
    else
      @redirect "/"+__default_lang+"/admin/login"  

  @get "/:lang?/backend*" : (req,res) ->
    if req.session and req.session.authenticated is true
      @next()
    else
      res.send('nope', 502)
      

  @post "/:lang/admin*" : (req) ->        
    if req.session and req.session.authenticated is true
      @next()
    else      
      @redirect "/#{@params.lang}/admin/login"


  @post "/admin*" : (req) ->
    if (req.session and req.session.authenticated is true)
      @next()
    else
      @redirect "/"+__default_lang+"/admin/login"  

  
  # Access to admin page with lang specified
  @get "/:lang?/admin" : (req,res) =>
    lang = req.params.lang or 'en'
    res.render 'backend_desktop',
      hardcode    : @helpers
      layout      : no 
      lang        : lang
      ion_lang    : ion_lang[ req.params.lang ]
      assetsPath  : _moduleAssetsPath
      user        : req.session.user


  

  # Unimplemented (yet) pages/views
  @get "/:lang/admin/desktop/get/toolboxes/structure_toolbox" : ->
    "toolbox"

  @get "/:lang/admin/desktop/get/toolboxes/empty_toolbox" : ->
    ""

  @get "/:lang/admin/dashboard" : ->
    @render 'backend_dashboard', {hardcode: @helpers, layout: no, lang:@params.lang, assetsPath : _moduleAssetsPath}
    

  @get "/control" : (req) =>
    @backend_controller req

  

  


  # ARTICLE links
  @post '/:lang/admin/articleget_link' : ->
  	@render 'backend_getLink', {layout:no}

  #
  # INTERFACE header
  #  
  @get "/:lang/admin/desktop/get_header" : (req,res) =>
    res.render "backend_desktopNavBar",
      hardcode  : @helpers 
      lang      : req.params.lang      
      ion_lang  : ion_lang[ req.params.lang ]
      layout    : no
      user      : req.session.user


  #
  # ARTICLE toolbox
  #
  @get '/:lang/admin/desktop/get/toolboxes/article_toolbox' : ->
    @render "backend_articleToolbox", 
      hardcode  : @helpers      
      ion_lang  : ion_lang[ @params.lang ]
      layout    : no

  #
  # PAGE toolbox
  #
  @get '/:lang/admin/desktop/get/toolboxes/page_toolbox' : ->    
    @render "backend_pageToolBox", 
      hardcode  : @helpers
      lang      : @params.lang # Current lang      
      ion_lang  : ion_lang[ @params.lang ] # Array of translations for current lang
      layout    : no


  # Display "article edition" page (same action than previous, onReload callback, Ionize Javascript seems to remove a "/")
  @get "/:lang/admin/articleedit/:ids" : =>
    @backend_editArticle req

  #
  # ARTICLE, changing "online" state
  #
  @post "/:lang/admin/articleswitch_online/:id_page/:id_article" : (req) =>
    @backend_articleSwitchOnline( req )

  #
  # ARTICLE, deletion
  #
  @post "/:lang/admin/article/delete/:id_article" : (req) =>
    @backend_articleDelete( req )

    
  #**********************************
  #* LOADING VIEWS, HELPERS, CONTROLLERS
  #** 
  fs = require 'fs'
  path = require 'path'
   
  includeFolders = []
  includeFolders.push "./modules/#{_moduleName}/views/"
  includeFolders.push "./modules/#{_moduleName}/controllers/"
  includeFolders.push "./modules/#{_moduleName}/helpers/"

  for includeFolder in includeFolders
    if path.existsSync includeFolder
      files = fs.readdirSync includeFolder
      @include includeFolder+file for file in files

  #
  # Events test
  #
  __nodizeEvents
    .on 'test', (message)->
      console.log( "test event fired >backend> ", message )

  # @io.sockets.on 'connection', (socket) ->
  #   socket.emit 'backofficeConnected'



