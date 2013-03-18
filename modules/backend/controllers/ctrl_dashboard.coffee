# Dashboard controller
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Copyright 2012-2013, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  dashboard_info =
    usercount : 0
    maxuser : 5
    memory : 0 
    maxmemory : 50 

  io = @io

  util = require('util')

  @io.sockets.on 'connection', (socket) ->

    dashboard_info.usercount++
    dashboard_info.maxuser = dashboard_info.usercount if dashboard_info.usercount>dashboard_info.maxuser
    
    socket.join "backend"   
    # socket.broadcast.emit 'dashboard_info_update', dashboard_info
    io.sockets.in('backend').emit 'dashboard_info_update', dashboard_info

    socket.on 'disconnect', () ->
      dashboard_info.usercount--
      # console.log "ctrl_dash -> disconnection (#{dashboard_info.usercount})"
      io.sockets.in('backend').emit 'dashboard_info_update', dashboard_info

  setInterval(
    -> 
      #
      # Memory usage
      #      
      mem_info = process.memoryUsage().rss / 1024 / 1024
      dashboard_info.memory = mem_info.toFixed(1)
      dashboard_info.maxmemory = dashboard_info.memory if dashboard_info.memory>dashboard_info.maxmemory
      io.sockets.in('backend').emit 'dashboard_info_update', dashboard_info
    , 2000
  )

    
    