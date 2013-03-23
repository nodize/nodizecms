#
# Displaying article edition page
#

html ->
  form '#pageForm', name: 'pageForm', method: 'post', action: '/admin/page/save', ->
    input '#element', type: 'hidden', name: 'element', value: 'page'
    input '#action', type: 'hidden', name: 'action', value: 'save'

    #input type: 'hidden', name: 'id_menu', value: @page.id_menu
    input type: 'hidden', name: 'created', value: '0000-00-00 00:00:00'
    input '#id_page', type: 'hidden', name: 'id_page', value: @page.id_page
    input '#rel', type: 'hidden', name: 'rel', value: @page.id_page
    input '#name', type: 'hidden', name: 'name', value: 'welcome-url'
    input '#origin_id_parent', type: 'hidden', value: @page.id_parent
    input '#origin_id_subnav', type: 'hidden', value: '0'
    #input '.online2', type: 'hidden', name: 'online', value: '1'
    div '#sidecolumn.close', ->

      div '.info', ->
        if @page.id_page
          # 'Main informations'
          dl '.compact.small', ->
            dt ->
              label @ion_lang.ionize_label_status
            dd '.icon', ->
              onlineClass = if @page.online then ' online' else ' offline'
              a id: 'iconPageStatus', class: "page2 "+onlineClass
          dl '.compact.small', ->
            dt ->
              label @ion_lang.ionize_label_date
            dd ->
              if @page.created
                dateArray = @page.created?._toMysql().split(' ')
                text dateArray[0]
                span class:'lite'

          dl '.small.compact', ->
            dt ->
              label @ion_lang.ionize_label_updated
            dd ->
              if @page.updated
                dateArray = @page.updated?._toMysql().split(' ')
                text dateArray[0]
                span '.lite', ' '+dateArray[1]

          # 'Link ?'
          div id:'linkContainer'

      div '#options', ->

        # 'Modules PlaceHolder'
        # 'Options'
        h3 '.toggler', -> @ion_lang.ionize_title_attributes
        div '.element', ->
          # 'Existing page'
          if @page.id_page
            # 'Appears as menu item in menu ?'
            dl '.small', ->
              dt ->
                label for: 'appears', title:@ion_lang.ionize_help_appears, -> @ion_lang.ionize_label_appears
              dd ->
                input '#appears.inputcheckbox', name: 'appears', type: 'checkbox', checked: (@page.appears is 1), value: '1'
          # 'Has one URL ? Means is reachable through its URL'
          dl '.small', ->
            dt ->
              label for: 'has_url', title:@ion_lang.ionize_help_has_url, -> @ion_lang.ionize_label_has_url
            dd ->
              input '#has_url.inputcheckbox', name: 'has_url', type: 'checkbox', checked: (@page.has_url is 1), value: '1'


          # 'Page view'
          if @page.id_page
            dl '.small', ->
              dt ->
                label for: 'view', title:@ion_lang.ionize_help_page_view, -> @ion_lang.ionize_label_view
              dd ->
                select '.customselect.select.w160', name: 'view', ->
                  for view of @views["pages"]
                    option selected: (view is @page.view), value: view, -> @views["pages"][view]


        # Parent

        if @page.id_page
          h3 '.toggler', -> @ion_lang.ionize_title_page_parent
          div '.element', ->
            # Menu
            dl '.small', ->
              dt ->
                label for: 'id_menu', -> @ion_lang.ionize_label_menu
              dd ->
                select '#id_menu.select', name :'id_menu', ->
                  for menu in @menus
                    option value:menu.id_menu, selected:(menu.id_menu is @page.id_menu), -> menu.title
            # Parent
            dl '.small.last', ->
              dt ->
                label for: 'id_parent', -> @ion_lang.ionize_label_parent
              dd ->
                select '#id_parent.select.w150', name: 'id_parent', ->
                  option value: '--', '--'

        # Dates
        h3 '.toggler', -> @ion_lang.ionize_title_dates
        div '.element', ->
          dl '.small', ->
            dt ->
              label for: 'logical_date', -> @ion_lang.ionize_label_date
            dd ->
                logical_date = ''
                logical_date = @page.logical_date?._toMysql() if @page.logical_date? isnt ''
                input '#logical_date.inputtext.w120.date', name: 'logical_date', type: 'text', value: logical_date
          dl '.small', ->
            dt ->

              label for: 'publish_on', title: @ion_lang.ionize_help_publish_on, -> @ion_lang.ionize_label_publish_on
            dd ->
              publish_on = ''
              publish_on = @page.publish_on?._toMysql() if @page.publish_on? isnt ''
              input '#publish_on.inputtext.w120.date', name: 'publish_on', type: 'text', value: publish_on
          dl '.small.last', ->
            dt ->
              label for: 'publish_off', title: @ion_lang.ionize_help_publish_off, -> @ion_lang.ionize_label_publish_off
            dd ->
              publish_off = ''
              publish_off = @page.publish_off?._toMysql() if @page.publish_off? isnt ''
              input '#publish_off.inputtext.w120.date', name: 'publish_off', type: 'text', value: publish_off

        # 'Advanced Options'
         h3 '.toggler', -> @ion_lang.ionize_title_advanced
         div '.element', ->
        #   # 'Pagination'
        #   dl '.small', ->
        #     dt ->
        #       label for: 'pagination', title: 'If>0, activates the pagination of article.', ->
        #         text 'Articles / page'
        #     dd ->
        #       input '#pagination.inputtext.w40', name: 'pagination', type: 'text', value: '0'
           # 'Home page'
           dl '.small.last', ->
             dt ->
               label for: 'home', title:@ion_lang.ionize_help_home_page, -> @ion_lang.ionize_label_home_page
             dd ->
               input '#home.inputcheckbox', name: 'home', type: 'checkbox', checked: (@page.home is 1), value: '1'
        # 'SEO'
        # h3 '.toggler', 'SEO'
        # div '.element', ->
        #   # 'Meta_Description'
        #   dl '.small', ->
        #     dt ->
        #       label title: 'Replace the global website META when not empty', 'Description'
        #     dd ->
        #       # 'Tabs'
        #       div '#metaDescriptionTab.mainTabs.small gray', ->
        #         ul '.tab-menu', ->
        #           li ->
        #             a 'En'
        #         div class:'clear'
        #       div '#metaDescriptionTabContent.w160', ->
        #         div '.tabcontent', ->
        #           textarea '#meta_description_en.h80', name: 'meta_description_en', style: 'border-top:none;width:142px;'
        #   # 'Meta_Keywords'
        #   dl '.small.last', ->
        #     dt ->
        #       label title: 'Replace the global website META when not empty', 'Keywords'
        #     dd ->
        #       # 'Tabs'
        #       div '#metaKeywordsTab.mainTabs.small gray', ->
        #         ul '.tab-menu', ->
        #           li ->
        #             a 'En'
        #         div class:'clear'
        #       div '#metaKeywordsTabContent.w160', ->
        #         div '.tabcontent', ->
        #           textarea '#meta_keywords_en.h40', name: 'meta_keywords_en', style: 'border-top:none;width:142px;'
        #   # 'Priority'
        #   dl '.small', ->
        #     dt ->
        #       label for: 'priority', title: 'Page priority, between 0 and 10', 'Sitemap priority'
        #     dd ->
        #       select '#priority.inputtext.w40', name: 'priority', ->
        #         option value: '0', '0'
        #         option value: '1', '1'
        #         option value: '2', '2'
        #         option value: '3', '3'
        #         option value: '4', '4'
        #         option value: '5', selected: 'selected', '5'
        #         option value: '6', '6'
        #         option value: '7', '7'
        #         option value: '8', '8'
        #         option value: '9', '9'
        #         option value: '10', '10'
        # 'Access authorization'
        # h3 '.toggler', 'Access authorizations'
        # div '.element', ->
        #   dl '.small.last', ->
        #     dt ->
        #       label for: 'template', 'Groups'
        #     dd ->
        #       div '#groups', ->
        #         select '.select', name: 'id_group', ->
        #           option value: '0', selected: 'selected', '-- Everyone --'
        #           option value: '1', 'Super Admins'
        #           option value: '2', 'Admins'
        #           option value: '3', 'Editors'
        #           option value: '4', 'Users'
        #           option value: '5', 'Pending'
        #           option value: '6', 'Guests'
        #           option value: '7', 'Banned'
        #           option value: '8', 'Deactivated'

#            # Operations on Page
#            h3 '.toggler', 'Operations'
#            div '.element', ->
#              # 'Copy Content'
#              dl '.small', ->
#                dt ->
#                  label for: 'lang_copy_from', title: 'Copy the element content from one language to another. Copy of all content (titles, subtitle, content, etc.)', 'Copy content'
#                dd ->
#                  div '.w100.left', ->
#                    select '#lang_copy_from.w100.select', name: 'lang_copy_from', ->
#                      option value: 'en', 'English'
#                    br()
#                    select '#lang_copy_to.w100.select.mt5', name: 'lang_copy_to', ->
#                      option value: 'en', 'English'
#                  div '.w30.h50 left ml5', style: 'background:url(/backend/images/icon_24_from_to.png) no-repeat 50% 50%;'
#              # 'Include article content'
#              dl '.small', ->
#                dt ->
#                  label for: 'copy_article', title: 'Also copy content for linked articles', 'Include articles'
#                dd ->
#                  input '#copy_article', type: 'checkbox', name: 'copy_article', value: '1'
#              # 'Submit button'
#              dl '.small.last', ->
#                dt '&#160;'
#                dd ->
#                  input '#copy_lang.submit', type: 'submit', value: 'Copy content'
          ###hr '.ml10'
          dl '.small.compact.mt10', ->
            dt ->
              label for: 'reorder_direction', title: 'Reorder articles by date. Date calculation : Logical or Publish On or Creation.', 'Reorder Articles'
            dd ->
              select '#reorder_direction.w140.select', name: 'reorder_direction', ->
                option value: 'DESC', 'Date Descendant'
                option value: 'ASC', 'Date Ascendant'
          # 'Submit button'
          dl '.small.last', ->
            dt '&#160;'
            dd ->
              input '#button_reorder_articles.submit.mt10', type: 'submit', value: 'Reorder'###

        # 'Modules PlaceHolder'
      # '/options'
    # '/sidecolumn'

    div '#maincolumn', ->
      fieldset ->

        if @page.id_page
          h2 '#main-title.main.page', @page_by_lang[@lang].title
          # 'Breadcrumb'
          div style: 'margin: -15px 0pt 20px 72px;', ->
            p ->
              span '.lite', 'IDx :'
              text "#{@page.id_page} |"
              #span '.lite', text @page_by_lang['en'].title
              span '.lite', ->
                input "page_name", name: "page_name", type: 'text', value: @page.name

            # 'extend fields goes here...'
        # ------------------
        # When it's a new page
        # ------------------
        else
          h2 '#main-title.main.page', -> @ion_lang.ionize_title_new_page
          #
          # Menus list
          #
          dl '.mt20', ->
            dt ->
              label for: 'id_menu', -> @ion_lang.ionize_label_menu
            dd ->
              select '#id_menu.select', name :'id_menu', ->
                for menu in @menus
                  option value:menu.id_menu, selected:(menu.id_menu is parseInt( @menu_id ) ), -> menu.title

          #
          # Parents list (pages), loaded via XHR on menu selection change
          #
          dl ->
            dt ->
              label for: 'id_parent', -> @ion_lang.ionize_label_parent
            dd ->
              select '#id_parent.select', name: 'id_parent', ->
                option value:'--', '--'
          # 'View'
          dl ->
            dt ->
              label for: 'view', title:@ion_lang.ionize_help_page_view, -> @ion_lang.ionize_label_view
            dd ->
              select '.select.w160.customselect', name: 'view', ->
                for view of @views["pages"]
                  option value: view, selected :(@views["page_default"] is view), -> @views["pages"][view]


          # 'endif'
          # 'Online / Offline'
          dl ->
            dt ->
              label for: 'online', title: @ion_lang.ionize_help_page_online, -> @ion_lang.ionize_label_page_online
            dd ->
              div ->
                input '#online.class', checked: 'checked', name: 'online', inputcheckbox: 'inputcheckbox online', type:'checkbox', value:'1'
          # 'Appears as menu item in menu ?'
          dl ->
            dt ->
              label for: 'appears', title: @ion_lang.ionize_help_appears, -> @ion_lang.ionize_label_appears
            dd ->
              input '#appears.inputcheckbox', name: 'appears', type: 'checkbox', checked: 'checked', value: '1'


      fieldset '.mt10', ->
        # 'Tabs'
        div '#pageTab.mainTabs', ->
          ul '.tab-menu', ->
            for lang in Static_langs_records
              li "#{".dl" if lang.def is 1}", rel: lang.lang, ->
                a lang.name

          div class:'clear'
        div '#pageTabContent', ->
          # 'Text block'
          for lang in Static_langs
            div '.tabcontent.#{lang}', ->
              # p '.clear.h15', ->
              #   a class: 'right icon copy copyLang', rel: lang, title: @ion_lang.ionize_label_copy_to_other_languages
              # 'title'
              dl '.first', ->
                dt ->
                  label for: "title_#{lang}", -> @ion_lang.ionize_label_title
                dd ->
                  input "#title_#{lang}.inputtext.title", name: "title_#{lang}", type: 'text', value: @page_by_lang[lang].title, title: @ion_lang.ionize_label_title
              # 'Sub title'
              dl ->
                dt ->
                  label for: "subtitle_#{lang}", -> @ion_lang.ionize_label_subtitle
                dd ->
                  textarea "#subtitle_#{lang}.inputtext.h30", name: "subtitle_#{lang}", type: 'text', -> @page_by_lang[lang].subtitle
              # 'URL'
              dl '.mt15', ->
                dt ->
                  label for: "url_#{lang}", title: @ion_lang.ionize_help_page_url, -> @ion_lang.ionize_label_url
                dd ->
                  input "#url_#{lang}.inputtext", name: "url_#{lang}", type: 'text', value: @page_by_lang[lang].url, title: @ion_lang.ionize_help_page_url
                  a href: "/#{@page_by_lang[lang].url}", target: '_blank', title: @ion_lang.ionize_label_see_online, ->
                    img src: "#{@settings.assetsPath}/images/icon_16_right.png"
              # 'Nav title'
              dl ->
                dt ->
                  label for: "nav_title_#{lang}", title: @ion_lang.ionize_help_page_nav_title, -> @ion_lang.ionize_label_nav_title
                dd ->
                  input "#nav_title_#{lang}.inputtext", name: "nav_title_#{lang}", type: 'text', value: @page_by_lang[lang].nav_title
              # 'Meta title : used for browser window title'
              dl '.mb20', ->
                dt ->
                  label for: "meta_title_#{lang}", title: 'Browser window title', 'Window title'
                dd ->
                  input "#meta_title_#{lang}.inputtext", name: "meta_title_#{lang}", type: 'text', value: @page_by_lang[lang].meta_title
              # 'Online'
              input "#online_#{lang}", name: "online_#{lang}", type: 'hidden', value: @page_by_lang[lang].online
              # 'extend fields goes here...'



      # 'Articles'
      #
      if @page.id_page
        fieldset '#articles.mt20', ->
          div '#childsTab.mainTabs', ->
            ul '.tab-menu', ->
              li '.selected', ->
                a 'Articles'
            div class:'clear'
          div '#childsTabContent.dropArticleInPage', rel: @page.id_page, ->
            # 'Articles List'
            div '.tabcontent', ->
              p ->
                #input "#articleCreate", type:"button", class:"light-button plus right", value:"Add Article", rel:"#{@page.id_page}"
                #button '.right.light-button helpme type', 'About Types'
                # Droppable to link one article to this page
                input '#new_article.inputtext.w120.italic.droppable.empty.nofocus', type: 'text', alt: 'drop an article here...'
                label title: 'Drag an article from the left tree by selecting its name.'
              br()
              div id:'articleListContainer'
            # '/ tabcontent'
  # File Manager Form
  # Mandatory for the filemanager'
  form '#fileManagerForm', name: 'fileManagerForm', ->
    input type: 'hidden', name: 'hiddenFile'

  #
  # Setting variables used by coffeescript section
  #
  script ->
    """
    id_page = #{@page.id_page}
    langs = #{JSON.stringify( Static_langs)}
    """

  #
  # COFFEE SCRIPT SECTION
  #
  coffeescript ->
    j$ = jQuery.noConflict()

    # Using ui.select jQuery widget for selects
    j$('document').ready ->
      j$('.customselect').selectmenu
        width : 140
        style : 'dropdown'



    #
    # Options Accordion
    #
    ION.initAccordion ".toggler", "div.element", true

    ION.initHelp "#articles.type.helpme", "article_type", Lang.get("ionize_title_help_articles_types")

    #
    # Init help tips on label
    #
    ION.initLabelHelpLinks "#pageForm"

    #
    # Panel toolbox
    #
    ION.initToolbox "page_toolbox"

    #
    # Droppables init
    #
    ION.initDroppable()

    #
    # Calendars init
    #
    ION.initDatepicker "%Y.%m.%d"

    #
    # Copy Lang data to other languages dynamically
    #
    ION.initCopyLang ".copyLang", Array("title", "subtitle", "url", "meta_title")

    #
    # Parent select list
    #
    $("id_menu").addEvent "change", ->
      # Current page ID
      id_current = (if ($("id_page").value) then $("id_page").value else "0")

      # Parent page ID
      id_parent = (if ($("origin_id_parent").value) then $("origin_id_parent").value else "0")
      xhr = new Request.HTML(
        url: admin_url + "page/get_parents_select/" + $("id_menu").value + "/" + id_current + "/" + id_parent
        method: "post"
        onSuccess: (responseTree, responseElements, responseHTML, responseJavaScript) ->
          $("id_parent").empty()
          if Browser.ie or (Browser.firefox and Browser.version < 4)
            $("id_parent").set "html", responseHTML
            selected = $("id_parent").getElement("option[selected=selected]")
            selected.setProperty "selected", "selected"
            $("id_parent").getFirst("option").setProperty "selected", "selected"  if $("origin_id_parent").value is "0"
          else
            $("id_parent").adopt responseTree

      ).send()

    $("id_menu").fireEvent "change"

    #
    # Auto-generate Main title
    #
    $$(".tabcontent .title").each (input, idx) ->
      input.addEvent "keyup", (e) ->
        $("main-title").set "text", @value

    # Auto-generate URL for new pages
    for lang in langs
      ION.initCorrectUrl "title_#{lang}", "url_#{lang}" if $("id_page").value is '' or $("url_#{lang}").value is ''

    # Tabs
    pageTab = new TabSwapper(
      tabsContainer: "pageTab"
      sectionsContainer: "pageTabContent"
      selectedClass: "selected"
      deselectedClass: ""
      tabs: "li"
      clickers: "li a"
      sections: "div.tabcontent"
      cookieName: "mainTab"
    )
    new TabSwapper(
      tabsContainer: "subnavTitleTab"
      sectionsContainer: "subnavTitleTabContent"
      selectedClass: "selected"
      deselectedClass: ""
      tabs: "li"
      clickers: "li a"
      sections: "div.tabcontent"
      cookieName: "subnavTitleTab"
    )
    new TabSwapper(
      tabsContainer: "metaDescriptionTab"
      sectionsContainer: "metaDescriptionTabContent"
      selectedClass: "selected"
      deselectedClass: ""
      tabs: "li"
      clickers: "li a"
      sections: "div.tabcontent"
      cookieName: "metaDescriptionTab"
    )
    new TabSwapper(
      tabsContainer: "metaKeywordsTab"
      sectionsContainer: "metaKeywordsTabContent"
      selectedClass: "selected"
      deselectedClass: ""
      tabs: "li"
      clickers: "li a"
      sections: "div.tabcontent"
      cookieName: "metaKeywordsTab"
    )
    new TabSwapper(
      tabsContainer: "permanentUrlTab"
      sectionsContainer: "permanentUrlTabContent"
      selectedClass: "selected"
      deselectedClass: ""
      tabs: "li"
      clickers: "li a"
      sections: "div.tabcontent"
      cookieName: "permanentUrlTab"
    )

    #
    # Copy content
    #
    ###$("copy_lang").addEvent "click", (e) ->
      e.stop()
      url = admin_url + "lang\/\/copy_lang_content"
      data =
        #case: "page"
        id_page: $("id_page").value
        include_articles: (if (($("copy_article").getProperty("checked")) is true) then "true" else "false")
        from: $("lang_copy_from").value
        to: $("lang_copy_to").value

      ION.sendData url, data###

    if $("id_page").value isnt ''
      #
      # Page status
      #
      ION.initRequestEvent $("iconPageStatus"), admin_url + "page\/\/switch_online/" + $("id_page").value

      #
      # Reorder articles
      #
      # $("button_reorder_articles").addEvent "click", (e) ->
      #   e.stop()
      #   url = admin_url + "page/reorder_articles"
      #   data =
      #     id_page: $("id_page").value
      #     direction: $("reorder_direction").value

      #   ION.sendData url, data

      #
      # Link to page or article
      #
      if $("linkContainer")
        ION.HTML admin_url + "page\/\/get_link",
          id_page: id_page
        ,
          update: "linkContainer"

      #
      # Articles List
      #
      ION.HTML admin_url + "article\/\/get_list",
        id_page: id_page
      ,
        update: "articleListContainer"

      #
      # Get Content Tabs & Elements
      # 1. ION.getContentElements calls element_definition/get_definitions_from_parent : returns the elements definitions which have elements for the current parent.
      # 2. ION.getContentElements calls element/get_elements_from_definition : returns the elements for each definition
      #
      $("desktop").store "tabSwapper", pageTab
      ION.getContentElements "page", $("id_page").value

      #
      # Loads media only when clicking on the tab
      #
      # mediaManager.initParent "page", $("id_page").value
      # mediaManager.loadMediaList "file"
      # mediaManager.loadMediaList "music"
      # mediaManager.loadMediaList "video"
      # mediaManager.loadMediaList "picture"

