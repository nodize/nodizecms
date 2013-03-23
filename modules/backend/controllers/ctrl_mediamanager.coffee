# Controller for mediamanager
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
# Components used : 
# http://blueimp.github.com/jQuery-File-Upload/
# TinyMCE
# ...
@include = ->
  basePath = __applicationPath+'/themes/'+__nodizeTheme+"/public/files"

  #
  # Displaying MEDIA MANAGER
  #
  @get '/:lang/admin/media/get_media_manager' : ->
    renderPage = (user_groups) =>
      @render "backend_mediamanager", 
        layout    : no
        hardcode  : @helpers           
        lang      : @params.lang      
        ion_lang  : ion_lang[ @params.lang ]
        #user_groups : user_groups

    renderPage()

  #
  # Generating token
  #
  @post '/:lang?/admin/media/get_tokken' : ->
    response = 
      tokken:"8b84445bf7a72faf1de2fe58a058efe6"

    @send response


  #
  # Returning files & folders DETAIL
  # TODO: manage token
  #
  @post '/:lang?/admin/media/filemanager/detail' : (req, res) ->
    values = req.body
    # Params :
    # uploadTokken
    # directory
    # file
    # filter
    # mode (direct)
    #
    
    # console.log values

    fileDirectory =  values.directory.replace( basePath, '' )
    ck = require 'coffeecup'

    imageinfo = require 'imageinfo'
    fs = require 'fs'    
    
    #
    # Generate template & send response
    #
    generateTemplate = (filedata, filestats) ->
      if filedata
        fileinfo = imageinfo( filedata )
        fileinfo.length = filedata.length      
      else
        fileinfo = null

      template = ->  
        dl ->
          dt "${modified}"
          dd ".filemanager-modified", -> @filestats.mtime.toString()
          if @fileinfo
            dt "${type}"
            dd ".filemanager-type", -> @fileinfo.mimeType
            dt "${size}"
            dd ".filemanager-size", -> (@fileinfo.length/1024).toFixed(2)+" KB (#{@fileinfo.length} Bytes)"
            dt "${width}"
            dd @fileinfo.width+"px"
            dt "${height}"
            dd @fileinfo.height+"px"
        if @fileinfo
          div ".filemanager-preview-content", ->
            a href:"\/files"+@filename, "data-milkbox":"single", title:@filename, ->
              img src:"\/files"+@filename, class:"preview", alt:"preview", style:"width: 220px; height: 220px;" 

      content = ck.render( template, filename:fileDirectory+"\/"+values.file, fileinfo:fileinfo, filestats:filestats )    
      

      response = 
        status:1
        content:content
        path:basePath+fileDirectory+"\/"+values.file
        name:values.file
        date:filestats.mtime.toString()
        mime:fileinfo?.mimeType
        size:fileinfo?.length
        width:fileinfo?.width
        height:fileinfo?.height
        thumb250:"\/files"+fileDirectory+"\/"+values.file
        thumb250_width:220
        thumb250_height:220
        thumb48:"\/files"+fileDirectory+"\/"+values.file
        thumb48_width:120
        thumb48_height:120
        thumbs_deferred:true
        icon48:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/jpg.png"
        icon:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/jpg.png"
        metadata:null

      res.send response


    #
    # Retrieving modification date
    #
    getFileStat = (filename) ->
      fs.stat filename, (err, stats ) ->
        if err
          console.log "getFileStat error on ",filename, err
        else
          getFileInfos( filename, stats )

    getFileInfos = (filename, filestats) ->
      if filestats.isDirectory()
        generateTemplate( null, filestats )
      else
        fs.readFile filename, (err, filedata) ->
          if (err) 
            console.log "getFileInfos error",err
          else
            generateTemplate( filedata, filestats )

    #
    # Start process
    #    
    values.directory = basePath+"/"+values.directory if values.directory.indexOf( basePath )<0

    imageFile = values.directory + "/" + values.file
    getFileStat( imageFile )
    
  #
  # Returning files & folders list
  #
  @post '/:lang?/admin/media/filemanager/view' : (req,res) ->
    values = req.body
    #
    # Get file list (folder "files" in /themes)
    #
    fs = require 'fs'
    path = require 'path'
    
    files = ""
    
    basePath = __applicationPath+'/themes/'+__nodizeTheme+"/public/files"
    filesFolder = basePath+values.directory
    
    getFolders = (dir, done) ->
      results = []
      fs.readdir dir, (err, list) ->
        if (err) 
          done(err)
        else        
          done(null, list)

    path = require 'path'

    #
    # Get all files in a folder (recursive)
    #            
    walk = (dir, done) ->
      files = []
      folders = []
      fs.readdir dir, (err, list) ->        
        return done(err) if (err) 
        pending = list.length        

        return done(null, folders, files) if not pending 
                
        list.forEach (file) ->
          file = dir + '/' + file
                    
          fs.stat file, (err, stat) ->
            if (stat and stat.isDirectory())
              folders.push(file)
              pending--                
              done(null, folders, files) if not pending
            else
              files.push(file)
              pending--              
              done(null, folders, files) if not pending


    #
    # We fill JSON structures to store folders & files
    #
    walk filesFolder, (err, folders, files) -> 
      folders_json = []      
      
            
      #
      # Building file list JSON structure
      #
      files_json = []
      
      try
        files = files.sort()

        for filename in files        
          item = 
            path  : filename
            name  : path.basename( filename )
            mime  :"image\/jpeg"
            thumbs_deferred :true
            icon48 :"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/jpg.png"
            icon :"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/jpg.png"

          files_json.push( item )

      catch error
        console.log "files_json error : ",error
        
      

      #
      # Building folder list JSON structure
      #
      try        
        for folder in folders      
          item = 
            path  : folder.replace( basePath, '' )
            name  : path.basename( folder )
            mime:"text\/directory"
            icon48:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/directory.png"
            icon:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/directory.png"

          folders_json.push( item )

      catch error
        console.log error
      
      #
      # Adding access to parent folder
      #            
      if values.directory not in ['/','']      
        item = 
          path  : path.join( values.directory, '..' )
          name  : ".."
          mime:"text\/directory"
          icon48:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/directory_up.png"
          icon:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/directory_up.png"
        folders_json.push( item )     

      #
      # Remove trailing slash
      #
      values.directory = values.directory.substr( 0, values.directory.length - 1 ) if values.directory.substr(-1) is "/"

      #values.directory = basePath+"/"+values.directory if values.directory.indexOf( basePath )<0

      #console.log "this_dir path", basePath+values.directory
      #console.log "this_dir name", (if values.directory is "" then "/" else path.basename( values.directory ))
      #console.log "this_dir path", values.directory
      #console.log "this_dir name", path.basename( values.directory )

      response = 
        status:1
        root:"files\/"
        this_dir:
          #path: basePath+values.directory
          path: values.directory
          name: path.basename( values.directory )
          date:"20 Mar 2012 - 21:36"
          mime:"text\/directory"
          icon48:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/directory.png"
          icon:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/directory.png"
        preselect_index:0
        preselect_name:null
        dirs:folders_json
        files:files_json
      

      res.send response


  #
  # Creating folder  
  #
  @post '/:lang?/admin/media/filemanager/create' : (req, res) ->
    values = req.body
    # console.log values
    fs = require 'fs'

    fs.mkdir values.directory+'\/'+values.file, 0o0777, (err) ->
      if err 
        console.log err
        response = 
          status:0
      else
        response =
          status:1
          root:"files\/"
          this_dir:
            path:values.directory+"\/"+values.file
            name:values.file
            date:"20 Mar 2012 - 21:36"
            mime:"text\/directory"
            icon48:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/directory.png"
            icon:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/directory.png"
          preselect_index:0
          preselect_name:null
          dirs:[          
            path: values.directory.replace( basePath, "" )
            name:".."
            mime:"text\/directory"
            icon48:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/Large\/directory_up.png"
            icon:"\/backend\/javascript\/mootools-filemanager\/Assets\/Images\/Icons\/directory_up.png"
          ]
          files:[]


      res.send response
    
