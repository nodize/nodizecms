# Controller for article categories
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
  Settings = @Settings

  #
  # CATEGORIES SETTINGS 
  #
  @post "/:lang/admin/category/get_list" : ->    
    #
    # Retrieve menus
    #
    Category.findAll({order:'ordering'})
      .on 'success', (categories) =>
        #
        # Display menu edition page
        #    
        @render "backend_category", 
          layout    : no
          hardcode  : @helpers 
          settings  : Settings
          lang      : @params.lang      
          ion_lang  : ion_lang[ @params.lang ]

          categories : categories
        
      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # CATEGORIES ORDERING
  #
  @post "/:lang/admin/category/save_ordering" : (req) ->
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
          message       : "categories ordered"              
          update        : []                   
          callback      : null
              
        @send message  

    ordering = 1

    #
    # Doing UPDATE queries
    #
    for id_category in values.order.split ','
      requestCount++

      DB.query( "UPDATE category SET ordering=#{ordering} WHERE id_category=#{id_category}")
        .on 'success', ->
          checkFinished()
          
        .on 'failure', (err) ->
          console.log 'database error ', err
              
      ordering++
  
  #
  # ADD A CATEGORY
  #
  @post "/:lang/admin/category/save" : (req, res) ->
    values = req.body    

    category = Category.build()
    category.name = values.name

    requestCount = 0
    
    #
    # Add CATEGORY record
    #
    doCategorySave = (ordering)->
      category.ordering = ordering

      category.save()
        .on 'success', (new_category) ->          
          # Sequelize needs "id" field & current primary key is "id_menu" in Ionize database
          DB.query( "UPDATE category SET id = id_category")

          # We will send as many async requests than existing langs
          requestCount += Static_langs.length 
          for lang in Static_langs
            doCategoryLangSave( lang, new_category.id_category )
          
          
        .on 'failure', (err) ->
          console.log "category save error ", err

    #
    # Save lang info for a category
    #
    doCategoryLangSave = (lang, id_category) ->
      category_lang = Category_lang.build()
      category_lang.title = values['title_'+lang]
      category_lang.subtitle = values['subtitle_'+lang]
      category_lang.description = values['description_'+lang]
      category_lang.id_category = id_category
      category_lang.lang = lang

      category_lang.save()
        .on 'success', ->
          requestCount--
          if requestCount is 0
            #
            # Building JSON response
            #  
            message =  
              message_type  : "success"
              message       : "Category saved"
              
              update        : []
              
              callback      : [ 
                fn:"ION.HTML"
                args: ["category\/\/get_list","",{"update":"categoriesContainer"}]
              ,
                fn:"ION.clearFormInput"
                args:{"form":"newCategoryForm"} 
              ]

              id: id_category

            res.send message

        .on 'failure', (err) ->
          console.log "Category_lang save error", err

    #
    # Find Category's max ordering value, then starting saving process
    #      
    Category.max('ordering')
      .on 'success', (max) ->
        doCategorySave( max+1 )


  #
  # UPDATE A CATEGORY
  #
  @post "/:lang/admin/category/update" : (req, res) ->
    values = req.body    

    requestCount = 0

    doCategoryLangUpdate = (lang, id_category) ->
      Category_lang.find({where:{id_category:id_category, lang:lang}})
        .on 'success', (category_lang) ->
          category_lang.title = values['title_'+lang]
          category_lang.subtitle = values['subtitle_'+lang]
          category_lang.description = values['description_'+lang]

          category_lang.save()
            .on 'success', ->
              requestCount--

              if requestCount is 0
                #
                # Building JSON response
                #  
                message =  
                  message_type  : "success"
                  message       : "Category saved"
                  
                  update        : []
                  
                  callback      : [ 
                    fn:"ION.HTML"
                    args: ["category\/\/get_list","",{"update":"categoriesContainer"}]
                  ,
                    fn:"ION.clearFormInput"
                    args:{"form":"newCategoryForm"} 
                  ]

                  id: id_category

                res.send message


            .on 'failure', (err) ->
              console.log 'database error ', err
              

        .on 'failure', (err) ->
          console.log 'database error ', err
      

    Category.find({where:{id_category:values.id_category}})
      .on 'success', (category) ->
        category.name = values.name
        
        category.save()
          .on 'success', (category) ->
            # We will send as many async requests than existing langs
            requestCount += Static_langs.length 
            for lang in Static_langs
              doCategoryLangUpdate( lang, category.id_category )
  
          .on 'failure', (err) ->
            console.log 'database error ', err
        
      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # CATEGORY DELETE
  #
  @post "/:lang/admin/category/delete/:id_category" : ->
    requestCount = 0

    deleteCategoryLang = (category_lang) =>
      category_lang.destroy()
        .on 'success', =>
          requestCount--
          if requestCount is 0
            #
            # Building JSON response
            #  
            message =  
              message_type  : "success"
              message       : "Category deleted"              
              update        : [
                element : "categories"
                url     : "\/#{@params.lang}\/admin\/category\/\/get_select"
              ]              
              callback      : [
                "fn":"ION.deleteDomElements"
                "args":[".category"+@params.id_category]
              ]
              id  : @params.id_category
            # / Message
            
            @send message  
        .on 'failure', (err) ->
          console.log 'database error ', err


    Category.find({where:{id_category:@params.id_category}})
      .on 'success', (category) =>
        #
        # Also delete category langs
        #
        Category_lang.findAll( {where:{id_category:category.id_category}})
          .on 'success', (category_langs)->
            requestCount += category_langs.length
            for category_lang in category_langs
              deleteCategoryLang( category_lang )

        #
        # Then delete the category record
        #
        category.destroy()          
          .on 'failure', (err) ->
            console.log 'database error ', err

      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # CATEGORIES GET SELECT
  #
  @post "/:lang/admin/category/get_select" : ->    
    #
    # Retrieve categories
    #
    Category.findAll({order:'ordering'})
      .on 'success', (categories) =>
        #
        # Display response
        #    
        @render "backend_categorySelect", 
          layout    : no
          hardcode  : @helpers 
          settings  : Settings
          lang      : @params.lang      
          ion_lang  : ion_lang[ @params.lang ]

          categories : categories
        
      .on 'failure', (err) ->
        console.log 'database error ', err

  #
  # CATEGORY EDIT
  #
  @post "/:lang/admin/category/edit/:id_category" : ->    
    Category.find({where:{id_category:@params.id_category}})
      .on 'success', (category) =>
        #
        # Retrieve category langs 
        #
        Category_lang.findAll({where:{id_category:category.id_category}})
          .on 'success', (category_langs) =>
            #
            # Display type edition page
            #    
            @render "backend_categoryEdit", 
              layout    : no
              hardcode  : @helpers 
              settings  : Settings
              lang      : @params.lang      
              ion_lang  : ion_lang[ @params.lang ]

              category  : category
              category_langs : category_langs

          .on 'failure', (err) ->
            console.log 'database error ', err

      .on 'failure', (err) ->
        console.log 'database error ', err