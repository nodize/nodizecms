# Themes / views edition view
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
@include = ->

  #
  # Displaying lang settings page
  #
  @view backend_themes: ->
  	html ->
      div '#sidecolumn.close', ->
        div '.info', ->
          dl '.small.compact', ->
            dt ->
              label @ion_lang.ionize_label_current_theme
            dd __nodizeSettings.get("theme")
        
        div '#options', ->
          # Themes
          h3 '.toggler', -> @ion_lang.ionize_title_themes
          div '.element', ->
            form '#themesForm', name: 'themesForm', method: 'post', action: '/admin/setting/save_themes', ->
              # 'Theme'
              dl '.small', ->
                dt ->
                  label for: 'theme', -> @ion_lang.ionize_label_theme
                dd ->
                  select '#theme', name: 'theme', ->
                    for theme in @themes                      
                      option value: theme, selected: 'selected', theme
              # 'Submit button'
              dl '.small', ->
                dt '&#160;'
                dd ->
                  input '#themesFormSubmit.submit', type: 'submit', value: @ion_lang.ionize_button_save_themes
              br()
          # '/element'
        # '/togglers'
      # '/sidecolumn'
      # 'Main Column'
      div '#maincolumn', ->
        h2 '#main-title.main.themes', @ion_lang.ionize_title_themes
        # 'Views list'
        h3 '.mt20', @ion_lang.ionize_title_views_list + ' : ' + __nodizeSettings.get("theme")
        # '<div class="element">'
        form '#viewsForm', name: 'viewsForm', method: 'post', action: 'save_views', ->
          div '#viewsTableContainer', ->
            # 'Views table list'
            table '#viewsTable.list', ->
              thead ->
                tr ->
                  #th axis: 'string', style: 'width:20px;'
                  th axis: 'string', -> @ion_lang.ionize_label_view_filename
                  #th axis: 'string', -> @ion_lang.ionize_label_view_folder
                  th axis: 'string', -> "Default"
                  th @ion_lang.ionize_label_view_name
                  th @ion_lang.ionize_label_view_type
              tbody ->
                for file in @files.sort() 
                  do (file) =>                 
                    #
                    # Extract filename without path
                    #
                    filename = file.split('/').pop();

                    #
                    # Define variables used in the loop
                    #
                    logical_name = ''
                    view_type = ''

                    #
                    # Search current file in views definition to guess its type
                    #
                    if @views["pages"][filename]
                      logical_name = @views["pages"][filename] 
                      view_type = 'page'

                    if @views["blocks"][filename]
                      logical_name = @views["blocks"][filename] 
                      view_type = 'block'
                    
                    tr ->

                      #
                      # File edition with CodeMirror
                      #
                      #td ->
                      #  a class: 'icon edit viewEdit', rel: filename
                      td ->
                        a class: 'viewEdit', rel: 'page_home', -> filename
                      td ->
                        if view_type is 'page'
                          checked = if @views["page_default"] is filename then "checked" else ""
                          input type:'radio', id: 'page_default', name: 'page_default', value: filename, checked: checked
                        if view_type is 'block'
                          checked = if @views["block_default"] is filename then "checked" else ""
                          input type:'radio', id: 'block_default', name: 'block_default', value: filename, checked: checked

                      td ->                      
                        input '.inputtext.w160', type: 'text', name: 'viewdefinition_'+filename, value: logical_name

                      td ->                    
                        select '.select', name: 'viewtype_'+filename, ->
                          option selected: ('selected' if view_type is 'page'), class: 'type_page', value: 'page', 'Page'                        
                          option selected: ('selected' if view_type is 'block'), value: 'block', class: 'type_block', 'Block'
                          option selected: ('selected' if view_type is ''), value: '', '-- No type --'
        
                
        br()
        br()
        # '</div>'
      # '/maincolumn'

    

    #
    # COFFEESCRIPT SECTION / CLIENT SIDE
    #
    coffeescript ->
      
      j$ = jQuery.noConflict() 

      # Using ui.select jQuery widget for selects
      # Disabled, seems to bug item type 
      
      # j$('document').ready ->           
      #   j$('select').selectmenu
      #     width : 140
      #     style : 'dropdown'
      #     icons: [
      #       {find: '.type_page', icon: 'ui-icon-document'},
      #       {find: '.type_article', icon: 'ui-icon-script'},
      #       {find: '.type_block', icon: 'ui-icon-document-b'}
      #     ]
        

      #
      # Panel toolbox
      #
      ION.initToolbox "setting_theme_toolbox"

      #
      # Options Accordion
      #    
      ION.initAccordion ".toggler", "div.element"

      #
      # Adds Sortable function to the user list table
      #
      new SortableTable("viewsTable",
        sortOn: 1
        sortBy: "ASC"
      )

      #
      # Views Edit links
      #
      $$(".viewEdit").each (item) ->
        rel = item.getProperty("rel")
        id = rel.replace(/\//g, "")
        form = "formView" + id

        item.addEvent "click", (e) ->
          e.stop()
          self = this
          @resizeCodeMirror = (w) ->
            contentEl = w.el.contentWrapper
            mfw = contentEl.getElement(".CodeMirror-wrapping")
            mfw.setStyle "height", contentEl.getSize().y - 70

          wOptions =
            id: "w" + id
            title: Lang.get("ionize_title_view_edit") + " : " + rel
            content:
              url: admin_url + "setting/edit_view/" + rel
              method: "post"
              onLoaded: (element, content) ->

                # CodeMirror settings
                c = $("editview_" + id).value
                mirrorFrame = new ViewCodeMirror(CodeMirror.replace($("editview_" + id)),
                  height: "360px"
                  width: "95%"
                  content: c
                  tabMode: "shift"
                  parserfile: [ "parsexml.js", "parsecss.js", "tokenizejavascript.js", "parsejavascript.js", "parsehtmlmixed.js", "tokenizephp.js", "parsephp.js", "parsephphtmlmixed.js" ]
                  stylesheet: [ "http://192.168.1.162/themes/admin/javascript/codemirror/css/basic.css", "http://192.168.1.162/themes/admin/javascript/codemirror/css/xmlcolors.css", "http://192.168.1.162/themes/admin/javascript/codemirror/css/jscolors.css", "http://192.168.1.162/themes/admin/javascript/codemirror/css/csscolors.css", "http://192.168.1.162/themes/admin/javascript/codemirror/css/phpcolors.css" ]
                  path: "http://192.168.1.162/themes/admin/javascript/codemirror/js/"
                  lineNumbers: true
                )

                # Set height of CodeMirror
                self.resizeCodeMirror this
                form = "formView" + id

                # Get the form action URL and adds 'true' so the transport is set to XHR
                formUrl = $(form).getProperty("action")

                # Add the cancel event if cancel button exists
                if bCancel = $("bCancel" + id)
                  bCancel.addEvent "click", (e) ->
                    e.stop()
                    ION.closeWindow $("w" + id)

                # Event on save button
                if bSave = $("bSave" + id)
                  bSave.addEvent "click", (e) ->
                    e.stop()

                    # Get the CodeMirror Code
                    $("contentview_" + id).value = mirrorFrame.mirror.getCode()
                    
                    # Get the form
                    options = ION.getFormObject(formUrl, $(form))
                    r = new Request.JSON(options)
                    r.send()

            y: 80
            width: 800
            height: 450
            padding:
              top: 12
              right: 12
              bottom: 10
              left: 12

            maximizable: true
            contentBgColor: "#fff"
            onResize: (w) ->
              self.resizeCodeMirror w

            onMaximize: (w) ->
              self.resizeCodeMirror w

            onRestore: (w) ->
              self.resizeCodeMirror w

          # Window creation
          new MUI.Window(wOptions)

      #
      # Database form action
      # see ionize-form.js for more information about this method
      #
      ION.setFormSubmit "themesForm", "themesFormSubmit", "setting\/\/save_themes"
          
