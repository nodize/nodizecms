# Article list page in backend
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Original page design :
# IonizeCMS (http://www.ionizecms.com), 
# (c) Partikule (http://www.partikule.net)
#
# CoffeeKup conversion & adaptation :
# Hypee (http://hypee.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  #
  # Article list & types & categories edition
  #
  @view backend_articleList: ->
    html ->
      # Filters form : 
      # - Pages    
      # - Search field (title, content, etc.)
      div '#maincolumn', ->
        h2 '#main-title.main.articles', 'Articles'
        # 'Tabs'
        div '#articlesTab.mainTabs', ->
          ul '.tab-menu', ->
            # li ->
            #   a ->
            #     span 'Articles'
            li ->
              a ->
                span 'Categories'
            li ->
              a ->
                span 'Types'
           
          div class:'clear'
        # 'Articles list'
        div '#articlesTabContent', ->
        #   div '.tabcontent', ->
            # 'Article list filtering'
            # form '#filterArticles', ->
            #   label '.left', title: 'Filter articles (not fully implemented)', 'Filter'
            #   input '#contains.inputtext.w160 left', type: 'text'
            #   a id: 'cleanFilter', class: 'icon clearfield left ml5'

            # table '#articlesTable.list', ->
            #   thead ->
            #     tr ->
            #       th 'Title'
            #       th axis: 'string', 'Pages'
            #       th axis: 'string', style: 'width:30px;', 'Content'
            #       th '.right', style: 'width:70px;', 'Actions'
            #   tbody ->
                
            #     tr '.article1', ->
            #       td '.title', style: 'overflow:hidden;', ->
            #         div style: 'overflow:hidden;', ->
            #           span '.toggler.left', rel: 'content1', ->
            #             a class: 'left article', rel: '0.1', ->
            #               span class:'flag flag0'
            #               text '404'
            #         div '#content1.content', ->
            #           div '.text', ->
            #             div '.mr10.left langcontent dl', style: 'width:90%;', ->
            #               img '.pr5', src: 'http://192.168.1.162/themes/admin/images/world_flags/flag_en.gif'
            #               div ->
            #                 p 'The content you asked was not found !'
            #       td ->
            #         img '.help', src: 'http://192.168.1.162/themes/admin/images/icon_16_alert.png', title: 'Orphan article. Not linked to any page.'
            #       td ->
            #         img '.pr5', src: 'http://192.168.1.162/themes/admin/images/world_flags/flag_en.gif'
            #       comment '<td><img class="pr5" src="http://192.168.1.162/themes/admin/images/world_flags/flag_en.gif" /></td>'
            #       td ->
            #         a class: 'icon right delete', rel: '1'
            #         a class: 'icon right duplicate mr5', rel: '1|404'
            #         a class: 'icon right edit mr5', rel: '1', title: '404'
                
                
          

          # --------------------------- 'Categories'
          div '.tabcontent', ->
            div '.tabsidecolumn', ->
              h3 'New category'
              form '#newCategoryForm', name: 'newCategoryForm', action: '/admin/category/save', ->
                # 'Name'
                dl '.small', ->
                  dt ->
                    label for: 'name', 'Name'
                  dd ->
                    input '#name.inputtext.required', name: 'name', type: 'text', value: ''
                fieldset '#blocks', ->
                  # 'Category Lang Tabs'
                  div '#categoryTab.mainTabs', ->
                    ul '.tab-menu', ->
                      for lang in Static_langs_records
                        li '.tab_category', rel: lang.lang, ->
                          a ->
                            span -> lang.name                     
                    div class:'clear'
                  # 'Category Content'
                  div '#categoryTabContent', ->
                     for lang in Static_langs_records                      
                      div '.tabcontentcat', ->
                        # 'title'
                        dl '.small', ->
                          dt ->
                            label for: "title_#{lang.lang}", 'Title'
                          dd ->
                            input "#title_#{lang.lang}.inputtext", name: "title_#{lang.lang}", type: 'text', value: ''
                        # 'subtitle'
                        dl '.small', ->
                          dt ->
                            label for: "subtitle_#{lang.lang}", 'Subtitle'
                          dd ->
                            input "#subtitle_#{lang.lang}.inputtext", name: "subtitle_#{lang.lang}", type: 'text', value: ''
                        # 'description'
                        dl '.small', ->
                          dt ->
                            label for: "descriptionCategory#{lang.lang}", 'Description'
                          dd ->
                            textarea "#descriptionCategory#{lang.lang}.tinyCategory", name: "description_#{lang.lang}", rel: lang.lang
                  # 'save button'
                  dl '.small', ->
                    dt '&#160;'
                    dd ->
                      button '#bSaveNewCategory.button.yes', type: 'button', 'Save'
            div '#categoriesContainer.tabcolumn.pt15', ''

            
          # ------------------------------------------------- Types
          div '.tabcontent', ->
            # 'New type'
            div '.tabsidecolumn', ->
              h3 'New type'
              form '#newTypeForm', name: 'newTypeForm', action: "/admin/article_type\/\/save", ->
                # 'Name'
                dl '.small', ->
                  dt ->
                    label for: 'type', 'Type'
                  dd ->
                    input '#type.inputtext', name: 'type', type: 'text', value: ''
                # 'Flag'
                dl '.small', ->
                  dt ->
                    label for: 'flag0', title: 'An internal marked, just to be organized.', 'Flag'
                  dd ->
                    label class:'flag flag0', ->
                      input '#flag0.inputradio', name: 'type_flag', type: 'radio', value: '0'
                    label '.flag.flag1', ->
                      input '.inputradio', name: 'type_flag', type: 'radio', value: '1'
                    label '.flag.flag2', ->
                      input '.inputradio', name: 'type_flag', type: 'radio', value: '2'
                    label '.flag.flag3', ->
                      input '.inputradio', name: 'type_flag', type: 'radio', value: '3'
                    label '.flag.flag4', ->
                      input '.inputradio', name: 'type_flag', type: 'radio', value: '4'
                    label '.flag.flag5', ->
                      input '.inputradio', name: 'type_flag', type: 'radio', value: '5'
                    label '.flag.flag6', ->
                      input '.inputradio', name: 'type_flag', type: 'radio', value: '6'
                # 'Description'
                dl '.small', ->
                  dt ->
                    label for: 'descriptionType', 'Description'
                  dd ->
                    textarea '#descriptionType.tinyType', name: 'description'
                # 'save button'
                dl '.small', ->
                  dt '&#160;'
                  dd ->
                    button '#bSaveNewType.button.yes', type: 'button', 'Save'
            # 'Existing types'
            div id:'articleTypesContainer', class:'tabcolumn pt15'
          # 'Articles Markers'
         

    coffeescript ->
      #
      # Make each article draggable
      #
      # $$("#articlesTable .article").each (item, idx) ->
      #   ION.addDragDrop item, ".dropArticleInPage,.dropArticleAsLink,.folder", "ION.dropArticleInPage,ION.dropArticleAsLink,ION.dropArticleInPage"

      #
      # Adds Sortable function to the user list table
      #
      # new SortableTable("articlesTable",
      #   sortOn: 0
      #   sortBy: "ASC"
      # )
      # ION.initLabelHelpLinks "#articlesTable"
      # ION.initLabelHelpLinks "#filterArticles"

      #
      # Categories list
      #
      ION.HTML admin_url + "category\/\/get_list", "",
        update: "categoriesContainer"

      #
      # New category Form submit
      #
      $("bSaveNewCategory").addEvent "click", (e) ->
        e.stop()
        ION.sendData admin_url + "category\/\/save", $("newCategoryForm")

      #
      # New category tabs (langs)
      #
      new TabSwapper(
        tabsContainer: "categoryTab"
        sectionsContainer: "categoryTabContent"
        selectedClass: "selected"
        deselectedClass: ""
        tabs: "li"
        clickers: "li a"
        sections: "div.tabcontentcat"
        cookieName: "categoryTab"
      )

      #
      # TinyEditors
      # Must be called after tabs init.
      #
      ION.initTinyEditors ".tab_category", "#categoryTabContent .tinyCategory", "small"

      #
      # Type list
      #
      ION.HTML admin_url + "article_type\/\/get_list", "",
        update: "articleTypesContainer"

      #
      # New Type Form submit
      #
      $("bSaveNewType").addEvent "click", (e) ->
        e.stop()
        ION.sendData admin_url + "article_type\/\/save", $("newTypeForm")
      
      #
      # Articles Tabs
      #
      new TabSwapper(
        tabsContainer: "articlesTab"
        sectionsContainer: "articlesTabContent"
        selectedClass: "selected"
        deselectedClass: ""
        tabs: "li"
        clickers: "li a"
        sections: "div.tabcontent"
        cookieName: "articlesTab"
      )

      #
      # Table action icons
      #
      confirmDeleteMessage = Lang.get("ionize_confirm_element_delete")
      url = admin_url + "article/delete/"
      $$("#articlesTable .delete").each (item) ->
        ION.initRequestEvent item, url + item.getProperty("rel"), {},
          message: confirmDeleteMessage

      $$("#articlesTable .duplicate").each (item) ->
        rel = item.getProperty("rel").split("|")
        id = rel[0]
        url = rel[1]
        item.addEvent "click", (e) ->
          e.stop()
          ION.formWindow "DuplicateArticle", "newArticleForm", "ionize_title_duplicate_article", "article/duplicate/" + id + "/" + url,
            width: 520
            height: 280

      $$("#articlesTable .edit").each (item) ->
        id_article = item.getProperty("rel")
        title = item.getProperty("title")
        item.addEvent "click", (e) ->
          e.stop()
          MUI.Content.update
            element: $("mainPanel")
            loadMethod: "xhr"
            url: admin_url + "article/edit/0." + id_article
            title: Lang.get("ionize_title_edit_article") + " : " + title

      #
      # Content togglers
      #
      calculateTableLineSizes = ->
        $$("#articlesTable tbody tr td.title").each (el) ->
          c = el.getFirst(".content")
          toggler = el.getElement(".toggler")
          text = c.getFirst()
          s = text.getDimensions()
          if s.height > 0
            toggler.store "max", s.height + 10
            if toggler.hasClass("expand")
              el.setStyles height: 20 + s.height + "px"
              c.setStyles height: s.height + "px"
          else
            toggler.store "max", s.height

      window.removeEvent "resize", calculateTableLineSizes
      window.addEvent "resize", ->
        calculateTableLineSizes()

      window.fireEvent "resize"
      $$("#articlesTable tbody tr td .toggler").each (el) ->
        el.fx = new Fx.Morph($(el.getProperty("rel")),
          duration: 200
          transition: Fx.Transitions.Sine.easeOut
        )
        el.fx2 = new Fx.Morph($(el.getParent("td")),
          duration: 200
          transition: Fx.Transitions.Sine.easeOut
        )
        $(el.getProperty("rel")).setStyles height: "0px"

      toggleArticle = (e) ->
        # this.fx.toggle();
        e.stop()
        @toggleClass "expand"
        max = @retrieve("max")
        from = 0
        to = max
        if @hasClass("expand") is 0
          from = max
          to = 0
          @getParent("tr").removeClass "highlight"
        else
          @getParent("tr").addClass "highlight"
        @fx.start height: [ from, to ]
        @fx2.start height: [ from + 20, to + 20 ]

      $$("#articlesTable tbody tr td .toggler").addEvent "click", toggleArticle
      $$("#articlesTable tbody tr td.title").addEvent "click", (e) ->
        @getElement(".toggler").fireEvent "click", e

      $$("#articlesTable tbody tr td .content").addEvent "click", (e) ->
        @getParent("td").getElement(".toggler").fireEvent "click", e

      #
      # Filtering
      #
      filterArticles = (search) ->
        reg = new RegExp("<span class=\"highlight\"[^><]*>|<.span[^><]*>", "g")
        search = RegExp(search, "gi")
        $$("#articlesTable .text").each (el) ->
          c = el.get("html")
          tr = el.getParent("tr")
          m = c.match(search)
          if m
            tr.setStyles "background-color": "#FDFCED"
            h = c
            h = h.replace(reg, "")
            m.each (item) ->
              h = h.replace(item, "<span class=\"highlight\">" + item + "</span>")

            el.set "html", h
            tr.setStyle "visibility", "visible"
          else
            tr.removeProperty "style"
            h = c.replace(reg, "")
            el.set "html", h

      # $("contains").addEvent "keyup", (e) ->
      #   e.stop()
      #   search = @value
      #   if search.length > 2
      #     $clear @timeoutID  if @timeoutID
      #     @timeoutID = filterArticles.delay(500, this, search)

      # $("cleanFilter").addEvent "click", (e) ->
      #   reg = new RegExp("<span class=\"highlight\"[^><]*>|<.span[^><]*>", "g")
      #   $("contains").setProperty("value", "").set "text", ""
      #   $$("#articlesTable tr").each (el) ->
      #     el.removeProperty "style"

      #   $$("#articlesTable .text").each (el) ->
      #     c = el.get("html")
      #     c = c.replace(reg, "")
      #     el.set "html", c

      ION.initToolbox "articles_toolbox"
