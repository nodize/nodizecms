# Category views
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
  #
  # Return categories in select, used on deletion
  # TODO: see if it's useful, probably can be removed
  #
  @view backend_categorySelect: ->   
    select '.select', name:'categories[]', multiple:"multiple", ->      
      for category in @categories
        option value:category.id_category, -> category.name        
          

  #
  # Displaying category settings tab
  #
  @view backend_category: ->   
    html ->
      ul '#categoryList.mb20.sortable-container', ->
        for category in @categories
          li "#category_#{category.id_category}.sortme.category#{category.id_category}", rel: category.id_category, ->
            a class: 'icon delete right', rel: category.id_category
            img '.icon.left drag pr5', src: "#{@settings.assetsPath}/images/icon_16_ordering.png"
            a class: 'left pl5 title', rel: category.id_category, ->              
              text category.name
          

      coffeescript ->
        #
        # Categories list itemManager
        #
        categoriesManager = new ION.ItemManager(
          element: "category"
          container: "categoryList"
        )

        categoriesManager.makeSortable()

        #
        # Make all categories editable
        #
        $$("#categoryList .title").each (item, idx) ->
          rel = item.getProperty("rel")
          item.addEvent "click", (e) ->
            ION.formWindow "category" + rel, "categoryForm" + rel, Lang.get("ionize_title_category_edit"), "category\/\/edit/" + rel
        
