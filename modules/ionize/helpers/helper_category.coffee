# Category helper, used to display existing categories
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
  #* Displaying categories, 
  #* use @category.title, .description, .subtitle... in nested views (fields from category_lang table)
  #* 
  #**
  @helpers['ion_categories'] = (args...) -> 
    tagName = 'ion_categories'

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

    Category_lang.findAll({where:{lang:'en'}})
      .on 'success', (categories) =>
        #
        # Content that will be built and sent
        #
        htmlResponse = ""

        for category in categories
          @category = category
          #console.log @article.title
      
          # Render nested tags
          if args.length>=1
            htmlResponse += cede args[args.length-1] # Compile the nested content to html
            args[args.length-1]() 

        finished( htmlResponse )
      
      
      .on 'failure', (err) ->
        console.log "category request failed : ", err
        finished()
  
    #
    # Inserting placeholder in the html for replacement once async request are finished
    #
    text "{**#{requestId.name}**}"
    
    
      
    

      