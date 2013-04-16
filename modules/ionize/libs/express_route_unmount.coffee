#
# Monkey patch express to support routes removal
# http://stackoverflow.com/questions/10378690/remove-route-mappings-in-nodejs-express

@include = ->

  unmount = (type, routeToRemove) =>
    #
    # Building a new map, without route to remove
    #
    unless @app._router.map[type]
      return

    new_map = []
    for route in @app._router.map[type]
      new_map.push route if route.path isnt routeToRemove

    #
    # Replacing
    #
    @app._router.map[type] = new_map


  @unmount_all = (routeToRemove) =>

    unmount( 'get', routeToRemove )
    unmount( 'post', routeToRemove )







