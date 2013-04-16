@include = ->

  #
  # Displaying article list on page edition
  #
  @view backend_pageArticleList: ->
    html ->
      ul "#articleList#{@page.id_page}.sortable-container", ->
        for article in @articles
          li id:"articleinpage#{@page.id_page}", class:"sortme article#{article.id_article} article#{@page.id_page}x2 online", rel: "#{@page.id_page}.#{article.id_article}", ->
            # 'Drag icon'
            img '.icon.left.drag.pr5', src: "#{@settings.assetsPath}/images/icon_16_ordering.png"
            # 'Status icon'
            a class: 'icon right pr5 status article#{article.id_article} article#{@page.id_page}x#{article.id_article} online', rel: "#{@page.id_page}.#{article.id_article}"
            # 'Unlink icon'
            a class: 'icon right pr5 unlink', rel: "#{@page.id_page}.#{article.id_article}", title: 'Unlink'
           
            # 'Flags : Available content for language'

            #span '.right.mr10 ml10', style: 'width:25px;display:block;height:16px;', ->
            #  img '.left.pl5 pt3', src: "#{@settings.assetsPath}/images/world_flags/flag_en.gif"

            # 'Type'
            span class:'right ml10 type-block', rel: "#{@page.id_page}.#{article.id_article}", ->              
              select "#type#{@page.id_page}x#{article.id_article}.select.w80.type.left", style: 'padding:0;', rel: "#{@page.id_page}.#{article.id_article}", ->
                option value: '--', ->  @ion_lang.ionize_select_no_type
                for type in @types
                  option selected: ('selected' if type.id_type==article.id_type), value: type.id_type, -> type.type
            # 'Used view'
            span '.right.ml10', ->
              select "#view#{@page.id_page}x#{article.id_article}.customselect.select.w110.view", style: 'padding:0;', rel: "#{@page.id_page}.#{article.id_article}", ->
                option value: '--', -> @ion_lang.ionize_select_default_view               
                for block in @blocks
                  option selected: ('selected' if article.view==block.file), value: block.file, -> block.name
                  
                  #option selected: ('selected' if view==article.view), value: view, -> @views["blocks"][view]
                                
            # 'Main parent page'
            # 'Title (draggable)'
            a style: 'overflow:hidden;height:16px;display:block;', class: "pl5 pr10 article article#{@page.id_page}.#{article.id_article} online", title: 'Edit / Drag to a page', rel: "#{@page.id_page}.#{article.id_article}", ->
              span class:'flag flag0'
              text article.title or article.name

    #
    # Setting variables used by coffeescript section
    #
    text """
    <script>
      id_page = #{@page.id_page}
    </script>
    """
    

    coffeescript ->
      #
      # Articles view / type select for articles list
      #
      $$("#articleList#{id_page} .type").each (item, idx) ->
        rel = item.getAttribute("rel").split(".")
        item.addEvents change: (e) ->
          @removeClass "a"
          @addClass "a"  if @value isnt "0" and @value isnt ""
          ION.JSON admin_url + "article\/\/save_context",
            id_page: rel[0]
            id_article: rel[1]
            id_type: @value

      $$("#articleList#{id_page} .view").each (item, idx) ->
        rel = item.getAttribute("rel").split(".")
        item.addEvents change: (e) ->
          @removeClass "a"
          @addClass "a"  if @value isnt "0" and @value isnt ""
          ION.JSON admin_url + "article\/\/save_context",
            id_page: rel[0]
            id_article: rel[1]
            view: @value

      $$("#articleList#{id_page} .parent").each (item, idx) ->
        rel = item.getAttribute("rel").split(".")
        item.addEvents change: (e) ->
          @removeClass "a"
          @addClass "a"  if @value isnt "0" and @value isnt ""
          ION.JSON admin_url + "article\/\/save_main_parent",
            id_page: @value
            id_article: rel[1]

      #
      # Makes article title draggable
      #
      $$("#articleList#{id_page} .article").each (item, idx) ->
        id_article = item.getProperty("rel")
        title = item.get("text")
        ION.addDragDrop item, ".folder", "ION.dropArticleInPage"
        item.addEvent "click", (e) ->
          e.stop()
          MUI.Content.update
            element: $("mainPanel")
            url: admin_url + "article/edit/" + id_article
            title: Lang.get("ionize_title_edit_article") + " : " + title

      #
      # Article list itemManager
      #
      articleManager = new ION.ArticleManager(
        container: "articleList#{id_page}"
        id_parent: id_page
      )

