# Themes / views edition controller
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Copyright 2012, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->

  #
  # Displaying THEME EDITION PAGE
  #
	@get '/:lang/admin/setting/themes' : ->
    #
    # Get theme list (folder list in /themes)
    #
    fs = require 'fs'
    
    views = ""
    # File containing views definition (page/blocks)
    viewsParamFile = __applicationPath+'/themes/'+__nodizeTheme+"/settings/views.json"

    getFolders = (dir, done) ->
      results = []
      fs.readdir dir, (err, list) ->
        if (err) 
          done(err)
        else        
          done(null, list)

    #
    # Get all files in a folder (recursive)
    #            
    walk = (dir, done) ->
      results = []
      fs.readdir dir, (err, list) ->        
        return done(err) if (err) 
        pending = list.length        
        return done(null, results) if not pending 
                
        list.forEach (file) ->
          file = dir + '/' + file
                    
          fs.stat file, (err, stat) ->
            if (stat and stat.isDirectory())
              walk file, (err, res) ->
                results = results.concat(res)
                pending--                
                done(null, results) if not pending
            else
              results.push(file)
              pending--              
              done(null, results) if not pending
    
    #
    # Retrieve theme list
    #
    getThemes = (err, themes) =>      
      if not err
        #
        # Storing installed themes in @themes
        #
        @themes = themes

        #
        # Find files in the current used theme
        #
        for theme in themes          
          if theme is __nodizeTheme
            walk __applicationPath+'/themes/'+theme+"/views", getFiles 

    #
    # Retrieve files in a theme
    #
    getFiles = (err, files) =>      
      if not err                
        @render "backend_themes", 
          layout    : no
          hardcode  : @helpers 
          lang      : @params.lang        
          ion_lang  : ion_lang[ @params.lang ]
          themes    : @themes
          files     : files
          views     : views
      else
        console.log "Error in themes, ", err
        @send "Error in themes, " + err

    #
    # Loading "views" settings file
    # then find installed themes
    #
    loadViews = ->
      fs.readFile viewsParamFile, (err, data) ->
        views = JSON.parse( data )        
        #
        # retrieving themes
        #
        getFolders __applicationPath+'/themes', getThemes
      
    startProcess = ->
      loadViews()
      

    #
    # Check if views config file does exist for the theme in use
    # Then, start the process, looking for folders & files
    #
    fs.stat viewsParamFile, (err, stat) ->
      #
      # File doesn't exists, we create a basic template
      #
      # if true==true # Forcing default template creation
      if err      
        console.log "View setting file doesn't exists, creating it"
        viewsParamFileTemplate = 
          "pages" : 
            "# real file" : "# logical name"            
          ,
          "blocks" : 
            "# real file" : "# logical name"
          "page_default" : ""
          "block_default" : ""
          
                
        fs.writeFile viewsParamFile, JSON.stringify( viewsParamFileTemplate, null, 4), (err) ->
          if err
            console.log err
          else
            startProcess()
        null

      else
        startProcess()




  #
  # SAVE VIEWS
  #      
  @post '/:lang/admin/setting/save_views' : (req) ->
    values = req.body

    pages = {}
    blocks = {}

    page_default = values.page_default or ""
    block_default = values.block_default or ""

    filename = ''
    for value of values      
      if value.indexOf( "viewtype_" ) == 0
        filename = value.replace("viewtype_", "")
        
        type = values[value]
        if type=='page'
          pages[filename]=values["viewdefinition_"+filename] if values["viewdefinition_"+filename] isnt ''
        if type=='block'
          blocks[filename]=values["viewdefinition_"+filename] if values["viewdefinition_"+filename] isnt ''
    
    views = 
      "pages" : 
        pages
      ,
      "blocks" : 
        blocks      
      "page_default" : page_default
      "block_default" : block_default

    # File containing views definition (page/blocks)
    viewsParamFile = __applicationPath+'/themes/'+__nodizeTheme+"/settings/views.json"
    
    fs = require 'fs'

    fs.writeFile viewsParamFile, JSON.stringify( views, null, 4), (err) =>
      if err
        console.log err
      else
        message = 
          "message_type":"success"
          "message":"Views settings saved"
          "update":[]
          "callback":null

        @send message

    

  #
  # Displaying THEME TOOLBOX
  #      
  @get '/:lang/admin/desktop/get/toolboxes/setting_theme_toolbox' : ->
      @render "backend_themesToolbox", 
        layout    : no
        hardcode  : @helpers 
        lang      : @params.lang        
        ion_lang  : ion_lang[ @params.lang ]

  #
  # SAVE THEME SELECTION
  #      
  @post '/:lang/admin/setting/save_themes' : (req, res) ->
    #
    # If a local file exists we use it, else we fallback on the regular settings file
    #
    path = require 'path'
    fs = require 'fs'

    existsSync = fs.existsSync or path.existsSync

    if existsSync( 'settings/nodize.local.json')
      nodizeSettingsFile = __applicationPath+'/settings/nodize.local.json' 
    else
      nodizeSettingsFile = __applicationPath+'/settings/nodize.json' 
    
    
    fs = require 'fs'      

    #
    # Retrieve existing settings
    #
    fs.readFile nodizeSettingsFile, (err, data) ->
      if (err) 
        console.log err
      else
        nodizeSettings = JSON.parse( data )
        nodizeSettings.theme = req.body.theme

        
        message = 
          "message_type":"success"
          "message":"New theme is loading, please restart the server and login again"
          "update":[]
          "callback":null

        res.send message

        
        saveThemeSettings = ->
          #
          # If a filewatcher like runjs is installed,
          # the server might restart before the response is sent
          #      
          fs.writeFile nodizeSettingsFile, JSON.stringify( nodizeSettings, null, 4), (err) =>
            if err
              console.log err
            else
              console.log "Theme changed"
        
        #
        # We give the server enough time to reload if needed
        # Might need to be adjusted 
        #
        setTimeout saveThemeSettings, 3000
