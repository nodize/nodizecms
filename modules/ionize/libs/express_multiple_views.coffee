# Monkey patching Express to allow using multiple views folder
# based on http://stackoverflow.com/questions/11315351/multiple-view-paths-on-node-js-express
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Copyright 2013, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#

enable_multiple_view_folders = ->
  # Monkey-patch express to accept multiple paths for looking up views.
  View = require("../../../node_modules/zappajs/node_modules/express/lib/view")

  lookup_proxy = View::lookup;

  View::lookup = (viewName) ->

    if (@root instanceof Array)
      for i in [0..@root.length]
        root = @root[i] or '' # Can be undefined, would break on "path.join" with Node.js >= 0.10
        context = {root: root}
        match = lookup_proxy.call(context, viewName)
        return match if (match)

      return null
 
    return lookup_proxy.call(this, viewName)


enable_multiple_view_folders()


