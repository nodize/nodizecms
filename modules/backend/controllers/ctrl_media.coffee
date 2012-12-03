# Controller for medias
# - display medias linked to an article
# - handle file upload 
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
# Components used : 
# http://blueimp.github.com/jQuery-File-Upload/
# TinyMCE
# ...
@include = ->
  #
  # Displaying PICTURES linked to an ARTICLE
  #
  @get '/:lang/admin/media/get_media_list/picture/article/:id_article' : ->
    
    ck = require 'coffeecup'

    DB.query( "SELECT * FROM media, article_media WHERE article_media.id_media = media.id_media AND article_media.id_article = #{@params.id_article}", Media)
      .on 'success', (medias) =>
        content = ''

        server_address = __nodizeSettings.get("pixlr_callback_server")
        

        template = ->  
          div '.picture.drag', id:'picture_10', ->
            div '.thumb', style:"width:120px;height:120px; background-image:url(/#{@media.path});", ->
            p class:"icons", ->
              a class:"icon delete right", href:"javascript:mediaManager.detachMedia('picture', '#{@media.id_media}');", title:"Unlink media"
              #a class:"icon edit left mr5 ", href:"javascript:ION.formWindow('picture#{@media.id_media}', 'mediaForm#{@media.id_media}', '#{@media.file_name}', '#{@media.base_path}', {width:520,height:430,resize:true});", title:"Edit"
              a class:"icon edit left mr5 ", href:"javascript:pixlr.overlay.show({image:'#{@server_address}/#{@media.path}', title:'#{@media.file_name}', service:'editor'})", title:"Edit"
              a class:"icon edit left mr5 ", href:"javascript:pixlr.overlay.show({image:'#{@server_address}/#{@media.path}', title:'#{@media.file_name}', service:'express'})", title:"Edit"
              a class:"icon refresh left mr5 "; href:"javascript:mediaManager.initThumbs('#{@media.id_media}');", title:"Init thumbnails"
              a class:"icon info left help", title:"#{@media.id_media} : #{@media.file_name} ", rel:"940 x 614 px<br/>138.83ko"
    
        for media in medias
          media_path = media.path
          media_filename = media.file_name
          media_basepath = media.base_path
          
          content += ck.render template, { media:media, server_address:server_address } 

        message = 
          message_type:"success"
          message:null
          update:[]
          callback:null
          type:"picture"
          content:content

            
        @send JSON.stringify( message )
    .on 'failure', (err) ->
        @send 'none'
  
  #
  # Unlinking file from article
  #
  @post '/:lang/admin/media/detach_media/:type/article/:id_article/:id_media' : (req) ->
    Media.find({where:{id_media:@params.id_media}})
      .on 'success', (media) ->        
        media.destroy()
        deleteArticleMedia()        
      .on 'failure', (err) ->
        console.log 'database error ', err

    deleteArticleMedia = =>
      Article_media.find({where:{id_media:@params.id_media}})
        .on 'success', (article_media) =>          
          article_media.destroy()

          message = """{"message_type":"success","message":"Media unlinked","update":[],"callback":null,"type":"picture","id":"#{article_media.id_media}"}"""
          @send message

        .on 'failure', (err) ->
          console.log 'database error ', err
      
 
  #
  # File reception from pixlr
  # Note : Funky / Tricky way of dynamically defining a route
  # TODO: tokens & security
  #
  routes = {}
  routes[__nodizeSettings.get("pixlr_callback_url")] = (req) =>      
    #console.log "pixlr get return"
    console.log req.query
    
    # .image .type .title .state are in req.query
    # Example of .image value :
    # image: 'http://app1.pixlr.com/_temp/4f4c2a10f92ea12702000051.jpg' 

    
    http = require 'http'    
    fs = require 'fs'
    url = require 'url'

    file = req.query.image

    options = url.parse(file)

    # Basic options example : 
    # options = 
    #   host: 'www.google.com'
    #   port: 80
    #   path: '/index.html'


    request = http.get options,  (res) ->
      imagedata = ''
      res.setEncoding('binary')

      res.on 'data', (chunk) ->
        imagedata += chunk
      
      res.on 'end', ->
        fs.writeFile __applicationPath + '/themes/'+__nodizeTheme+'/public/files/' +req.query.title+"."+req.query.type, imagedata, 'binary', (err) ->
            if (err) 
              console.log err
            else
              console.log 'File saved.'
              broadcast testEvent: {message:'file received'}

    req.send "ok"

    
    #@io.sockets.send 'testEvent'

  #
  # Use routes we just define
  #
  @get routes
    
  parseCookie = require('connect').utils.parseCookie  


  #
  # Socket.io & express working together
  # http://www.danielbaulig.de/socket-ioexpress/
  # Session is stored in socket.handshake.session
  #
  @io.set 'authorization', (data, accept) ->    
    # check if there's a cookie header
    if data.headers.cookie 
      # if there is, parse the cookie
      data.cookie = parseCookie(data.headers.cookie);
           
      # note that you will need to use the same key to grab the
      # session id, as you specified in the Express setup.      
      data.sessionID = data.cookie['connect.sid']
      #console.log "Auth / Session ID : ",data.sessionID

      if not data.sessionID
        accept( null, false )
        console.log "Websocket @[#{data.address.address}:#{data.address.port}] -> cookie expired."          

      else
        __sessionStore.get data.sessionID, (err, session) ->        
          if err or not session
            console.log data.address
            console.log "Websocket @[#{data.address.address}:#{data.address.port}] -> error in get session, client cookie might be expired. Check server date if this is happening when it shouldn't."          
            accept( 'Error', false )
          else
            #console.log "session retrieved ", session
            data.session = session
            accept( null, true )


      #console.log data.sessionID
    else 
       # if there isn't, turn down the connection with a message
       # and leave the function.
       console.log "rejecting socket"
       return accept('No cookie transmitted.', false)
    
    # accept the incoming connection
    accept(null, true)



  #
  # Server side event
  # TODO: we might wait a little bit to let session being retrieved from database
  # when server is restarted (connection is called before session retrieval)
  @io.sockets
    .on 'connection', (socket) ->
      sessionID = socket.handshake.sessionID
      
      __sessionStore.get sessionID, (err, session) ->        
        if err or not session
          console.log "error in get session"        
        else
          socket.handshake.session = session
          # console.log "On connection session : ",socket.handshake.session
        
      


  @on connection: (socket_client) ->
    #console.log "connection"
    
    global.broadcast = socket_client.emit
    
    #
    # We should do a selective broadcast to backoffice users
    #

    #@broadcast testEvent: {message:'init'}
    
  #
  # File UPLOAD to ARTICLE
  #
  # TODO: Check if we need to unlink files from /upload directory
  @post '/:lang/admin/media/add_file/article/:id_article' : (req) ->

    #console.log req
    fs = require 'fs' 
    util = require 'util'
    #console.log req.request.files
    if req.request.files
      #console.log req.request.files.files
      
      for file in req.request.files.files
        # file = req.request.files.myfiles

        #
        # file.path, file.size, file.type (image/png)
        #

        ins = fs.createReadStream(file.path);
        ous = fs.createWriteStream( __applicationPath + '/themes/'+__nodizeTheme+'/public/files/' + file.filename)
        util.pump ins, ous, (err) -> 
          if(err)
            console.log err
          else             

            media = Media.build()
            media.type = "picture"          
            media.file_name = file.filename
            media.path = 'files/'+file.filename
            media.base_path = 'files/'
            media.container = ''
            media.date = new Date()

            media.save()
              .on 'success', (media) ->
                console.log "media added to database ", media.id_media
                associateMediaToArticle( media )
              .on 'failure', (err) ->
                console.log "Error while saving media to DB", err
          
    associateMediaToArticle = ( media ) =>
      article_media = Article_media.build()
      article_media.id_article = @params.id_article
      article_media.id_media = media.id_media

      article_media.save()
        .on 'success', (article_media) =>          
          @send '{"name":"loading.gif","type":"image/gif","size":3897}'
        .on 'failure', (err) ->
          console.log "Error on associate ", err

  #
  # Link existing FILE to ARTICLE
  # 
  @post '/:lang/admin/media/add_media/picture/article/:id_article' : (req) ->
    associateMediaToArticle = ( media ) =>
      article_media = Article_media.build()
      article_media.id_article = @params.id_article
      article_media.id_media = media.id_media

      article_media.save()
        .on 'success', (article_media) =>          
          @send '{"name":"loading.gif","type":"image/gif","size":3897}'
        .on 'failure', (err) ->
          console.log "Error on associate ", err

    req.send("not implemented yet")

      
