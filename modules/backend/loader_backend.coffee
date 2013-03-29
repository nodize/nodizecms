#
# Attempt to do a lazy/on demand loading of the backend
# but loading inside a "get" doesn't seems to work (middleware is not used...)
#

@include = ->
  backend_loaded = false

  @include './modules/backend/module_backend.coffee'

  loadModule = =>
    if not backend_loaded
      #
      # Removing "catch all" rules
      #
      @unmount_all "*"
      @unmount_all "/*"

      #
      # Loading backoffice routes
      #
      @include './modules/backend/module_backend.coffee'

      #
      # Restoring "catch all" routes
      #

      @all '*': (req, res) =>
        @catch_all( req, res )

      backend_loaded = true
      "Ok loaded"
    else
      "Already loaded"

  #loadModule()

#  @get "/loadadmin" : ->
#    loadModule()




