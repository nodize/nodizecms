
#
# Socket.io & express working together
# http://www.danielbaulig.de/socket-ioexpress/
# Session is stored in socket.handshake.session
#
# TODO : Move that in a better place !

@include = ->

  #parseCookie = require('connect').utils.parseCookie
  parseCookie = require('connect').utils.parseSignedCookies
  cookie = require("cookie")

  @io.set 'authorization', (data, accept) ->
    #console.log "ctrl_media | socketio auth", data, accept
    #console.log "session_socketio_express | data", data


    # check if there's a cookie header
    if data.headers.cookie

      # if there is a cookie, then parse it
      data.cookie = parseCookie(cookie.parse(data.headers.cookie), __sessionSecret);

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
            #console.log "session, ", session
            #console.log data.address
            console.log "Websocket @[#{data.address.address}:#{data.address.port}] -> error in get session, client cookie might be expired. Check server date if this is happening when it shouldn't."
            accept( 'Error', false )
          else
            #console.log "session retrieved ", session
            data.session = session
            accept( null, true )


      #console.log "ctrl_media | data.sessionID", data.sessionID
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
      # console.log "On connection"
      sessionID = socket.handshake.sessionID

      __sessionStore.get sessionID, (err, session) ->
        if err or not session
          console.log "error in get session"
        else
          socket.handshake.session = session
          # console.log "On connection session : ",socket.handshake.session