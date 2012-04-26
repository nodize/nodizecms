@include = ->

  #
  # Return types in select, used on deletion
  # TODO: see if it's useful, probably can be removed
  #
  @view backend_typeSelect: ->   
    select '.select', name:'id_type', ->
      index=0
      for article_type in @article_types
        index++
        text """<option value="#{index}">#{article_type.type}</option>"""
          

  #
  # Displaying types settings tab
  #
  @view backend_type: ->   
    html ->
      ul '#article_typeList.sortable-container', ->
        for article_type in @article_types
          li "#article_type_#{article_type.id_type}.sortme.article_type#{article_type.id_type}", rel: article_type.id_type, ->
            a class: 'icon delete right', rel: article_type.id_type
            img '.icon.left drag pr5', src: "#{@settings.assetsPath}/images/icon_16_ordering.png"
            a class: 'left pl5 title', rel: article_type.id_type, ->
              span class:"flag flag#{article_type.type_flag}"
              text article_type.type
          

    coffeescript ->
      typesManager = new ION.ItemManager(
        element: "article_type"
        container: "article_typeList"
      )
      typesManager.makeSortable()
      $$("#article_typeList .title").each (item, idx) ->
        rel = item.getProperty("rel")
        item.addEvent "click", (e) ->
          ION.formWindow "article_type" + rel, "article_typeForm" + rel, Lang.get("ionize_title_type_edit"), "article_type\/\/edit/" + rel


