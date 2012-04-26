# Include helper, used to include partials with ECO template engine
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

@include = ->
  #*****
  #* Include a .eco file  
  #* 
  #**
  @helpers['ion_include'] = (filename, args...) -> 
    tagName = 'ion_include'

    #
    # We are launching an asynchronous request,
    # we need to register it, to be able to wait for it to be finished
    # and insert the content in the response sent to browser 
    #
    requestId = @registerRequest( tagName )

    #
    # Finished callback
    #
    finished = (response) =>
      @requestCompleted requestId, response

    htmlResponse = filename

    #htmlResponse += yield args[args.length-1] # Compile the nested content to html

    finished( htmlResponse )
            
    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId}**}"
    
    
      
    

      