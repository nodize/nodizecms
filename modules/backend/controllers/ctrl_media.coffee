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

    DB.query( "SELECT * FROM media, article_media WHERE article_media.id_media = media.id_media AND article_media.id_article = #{@params.id_article} ORDER BY article_media.ordering", Media)
      .on 'success', (medias) =>
        content = ''

        server_address = __nodizeSettings.get("pixlr_callback_server")
        

        template = ->  
          div '.picture.drag', id:"picture_#{@media.id_media}", ->
            div '.thumb', style:"width:120px;height:120px; background-image:url(/#{@media.path});", ->
            p class:"icons", ->
              a class:"icon delete right", href:"javascript:mediaManager.detachMedia('picture', '#{@media.id_media}');", title:"Unlink media"
              #a class:"icon edit left mr5 ", href:"javascript:ION.formWindow('picture#{@media.id_media}', 'mediaForm#{@media.id_media}', '#{@media.file_name}', '#{@media.base_path}', {width:520,height:430,resize:true});", title:"Edit"
              a class:"icon edit left mr5 ", href:"javascript:pixlr.overlay.show({image:'#{@server_address}/#{@media.path}', title:'#{@media.file_name}', service:'editor'})", title:"Edit"
              a class:"icon edit left mr5 ", href:"javascript:pixlr.overlay.show({image:'#{@server_address}/#{@media.path}', title:'#{@media.file_name}', service:'express'})", title:"Edit"
              #a class:"icon refresh left mr5 "; href:"javascript:mediaManager.initThumbs('#{@media.id_media}');", title:"Init thumbnails"
              #a class:"icon info left help", href:"javascript:ION.formWindow('picture#{@media.id_media}', 'mediaForm#{@media.id_media}', '#{@media.file_name}', '#{@media.base_path}', {width:520,height:430,resize:true});", title:"#{@media.id_media} : #{@media.file_name} ", rel:"Image settings"
    
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
  @post '/:lang/admin/media/detach_media/:type/article/:id_article/:id_media' : (req, res) ->
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

    res.send "ok"

    
    #@io.sockets.send 'testEvent'

  #
  # Make avalaible the routes we just defined
  #
  @get routes



  @on connection: (socket_client) ->
    #console.log "connection"
    
    #global.broadcast = socket_client.emit
    
    #
    # We should do a selective broadcast to backoffice users
    #

    #@broadcast testEvent: {message:'init'}
    
  #
  # File UPLOAD to ARTICLE
  #
  @post '/:lang?/admin/media/add_file/article/:id_article' : (req) ->

    fs = require 'fs' 
    util = require 'util'

    if req.files

      for file in req.files.files

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
                associateMediaToArticle( media )
              .on 'failure', (err) ->
                console.log "Error while saving media to DB", err

            #
            # Removing temp file
            #
            fs.unlink file.path


    #
    # Link the file to the article
    #
    associateMediaToArticle = ( media ) =>
      article_media = Article_media.build()
      article_media.id_article = @params.id_article
      article_media.id_media = media.id_media

      article_media.save()
        .on 'success', (article_media) =>          
          @send '{"name":"loading.gif","type":"image/gif","size":3897}'# TODO: Send correct file type / file size
        .on 'failure', (err) ->
          console.log "Error on associate ", err

  #
  # Link existing FILE to ARTICLE
  # 
  @post '/:lang/admin/media/add_media/picture/article/:id_article' : (req, res) ->
    associateMediaToArticle = ( media ) =>
      article_media = Article_media.build()
      article_media.id_article = @params.id_article
      article_media.id_media = media.id_media

      article_media.save()
        .on 'success', (article_media) =>          
          @send '{"name":"loading.gif","type":"image/gif","size":3897}'
        .on 'failure', (err) ->
          console.log "Error on associate ", err

    res.send("not implemented yet")

  #
  # ORDERING MEDIAS
  #
  @post '/:lang/admin/media/save_ordering/article/:id_article' : (req) ->
    values = req.body

    requestCount = 0

    #
    # Call back on request finish
    # We send success response when all requests are done
    #
    checkFinished = =>
      requestCount--
      
      if requestCount is 0
        #
        # Building JSON response
        # - Notification
        #  
        message =  
          message_type  : "success"
          message       : "Medias ordered"              
          update        : []                   
          callback      : null
              
        @send message  

    ordering = 1

    #
    # Doing UPDATE queries
    #
    for id_media in values.order.split ','
      requestCount++
      
      DB.query( "UPDATE article_media SET ordering=#{ordering} WHERE id_media=#{id_media} and id_article=#{@params.id_article}")
        .on 'success', ->
          checkFinished()
          
        .on 'failure', (err) ->
          console.log 'database error ', err
              
      ordering++
  
