@include = ->

  #
  # Displaying page toolbox page
  #
  @view backend_pageToolBox: ->    
    html ->
      div '.toolbox.divider nobr', ->
        input '#pageFormSubmit.button.yes', type: 'button', value:@ion_lang.ionize_button_save_page
      div '#tPageDeleteButton.toolbox.divider nobr', ->
        input '#pageDeleteButton.button.no', type: 'button', value:@ion_lang.ionize_button_delete
      div '.toolbox.divider', ->
        input '#sidecolumnSwitcher.toolbar-button', type: 'button', value:@ion_lang.ionize_label_hide_options
      # div '#tPageAddContentElement.toolbox.divider', ->
      #   input '#addContentElement.toolbar-button.element', type: 'button', value:@ion_lang.ionize_label_add_content_element
      div '#tPageMediaButton.toolbox.divider', ->
        input '#addMedia.fmButton.toolbar-button pictures', type: 'button', value:@ion_lang.ionize_label_attach_media
      div '#tPageAddArticle.toolbox', ->
        input '#addArticle.toolbar-button.plus', type: 'button', value:@ion_lang.ionize_label_add_article  

    coffeescript ->

      #
      # Form save action
      # see init.js for more information about this method
      #
      ION.setFormSubmit "pageForm", "pageFormSubmit", "page\/\/save"
      
      #
      # Delete & Duplicate button buttons
      #
      id = $("id_page").value
      unless id
        $("tPageDeleteButton").hide()
        #$("tPageAddContentElement").hide()
        $("tPageMediaButton").hide()
        $("tPageAddArticle").hide()
      else
        url = admin_url + "page\/\/delete/"
        ION.initRequestEvent $("pageDeleteButton"), url + id,
          redirect: true
        ,
          confirm: true
          message: Lang.get("ionize_confirm_element_delete")
      
        # $("addContentElement").addEvent "click", (e) ->
        #   ION.dataWindow "contentElement", "ionize_title_add_content_element", "element/add_element",
        #     width: 500
        #     height: 350
        #   ,
        #     parent: "page"
        #     id_parent: id
      
        $("addMedia").addEvent "click", (e) ->
          e.stop()
          mediaManager.initParent "page", $("id_page").value
          mediaManager.toggleFileManager()
      
        #
        # Article create button link
        #
        $("addArticle").addEvent "click", (e) ->
          e.stop()
          MUI.Content.update
            element: $("mainPanel")
            loadMethod: "xhr"
            url: admin_url + "article/create/" + id
            title: Lang.get("ionize_title_create_article")
      
      #
      # Options show / hide button
      #
      ION.initSideColumn()
      
      #
      # Save with CTRL+s
      #  
      ION.addFormSaveEvent "pageFormSubmit"
