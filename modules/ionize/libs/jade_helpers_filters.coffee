# Monkey patching Jade to allow using Nodize CMS helpers
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Copyright 2012-2013, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#


init = ->  
  jade    = require "jade"
  filters = require "jade/lib/filters"
  utils   = require "jade/lib/utils"

  #
  # Modification to send the context (locals) to the Jade template executed inside the filter
  #
  jade.Compiler::visitFilter = (filter) ->
    fn = filters[filter.name]
    
    # console.log "Filter is ", filter

    # unknown filter
    throw new Error("unknown filter \":" + filter.name + "\"")  unless fn
    text = filter.block.nodes.map((node) ->
      node.val
    ).join("\n")

    # console.log "text is ", text

    filter.attrs = filter.attrs or {}
    filter.attrs.filename = @options.filename
        
    # Original Javascript code, modified to send the context : 
    # this.buffer(utils.text(fn(text, filter.attrs)));
    try          
      @buffer utils.text(fn.call(@options, text, filter.attrs))    
    catch err
      console.log "visitFilter error : ", err


init()


#module.exports = sequelize
#exports.config = config

