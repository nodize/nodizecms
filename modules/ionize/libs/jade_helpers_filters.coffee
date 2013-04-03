# Monkey patching Jade to allow using Nodize CMS helpers
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

jade    = require "jade"

#
# Adding helpers compatibility to Jade templates,
# Creating a new filter for each existing helpers 
#
createFilters = (helpers) ->

  for helper_name,helper_function of helpers
    do (helper_name,helper_function) ->      
      jade.filters[ helper_name ] = (block, options) ->

        try      
          # Calling the regular helper
          @template_engine = "jade"           
          helper_function.call( @, options, block )
        catch error
          console.log "Template error [#{helper_name}]: ", error
          console.log "jade_helpers_filters | stack", error.stack

      

init = ->  
  
  filters = require "jade/lib/filters"
  utils   = require "jade/lib/utils"

  #
  # Modification to send the context (locals) to the Jade template executed inside the filter
  #
  jade.Compiler::visitFilter = (filter) ->
    fn = filters[filter.name]
    
    #console.log "Filter is ", filter

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

module.exports.createFilters = createFilters

#module.exports = sequelize
#exports.config = config

