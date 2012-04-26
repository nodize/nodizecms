@include = ->

  #
  # Displaying lang settings page
  #
  @view backend_langSettings: ->

    html ->
      div '#sidecolumn.close', ->
        # 'Informations'
        div class:'info'
        div '#options', ->
          # 'New language'
          h3 '.toggler.mt20', -> @ion_lang.ionize_title_add_language
          div '.element', ->
            form '#newLangForm', name: 'newLangForm', method: 'post', action: '/admin/lang/save', ->
              # 'Lang Code'
              dl '.small', ->
                dt ->
                  label for: 'lang_new', -> @ion_lang.ionize_label_code
                dd ->
                  input '#lang_new.inputtext.w40', name: 'lang_new', type: 'text', value: ''
              comment 'Name'
              dl '.small', ->
                dt ->
                  label for: 'name_new', -> @ion_lang.ionize_label_name
                dd ->
                  input '#name_new.inputtext.w140', name: 'name_new', type: 'text', value: ''
                  br()
              comment 'Online'
              dl '.small', ->
                dt ->
                  label for: 'online_new', -> @ion_lang.ionize_label_online
                dd ->
                  input '#online_new.inputcheckbox', name: 'online_new', type: 'checkbox', value: '1'
              # 'Submit button'
              dl '.small', ->
                dt ->
                  label '&#160;'
                dd ->
                  input '#submit_new.submit', type: 'submit', value: @ion_lang.ionize_button_save_new_lang
          
          # '/element'
          # 'Copy Content'
          h3 '.toggler', -> @ion_lang.ionize_title_content
          div '.element', ->
            dl '.small', ->
              dt ->
                label for: 'lang_copy_from', title: @ion_lang.ionize_help_copy_all_content, -> 
                  @ion_lang.ionize_label_copy_all_content
              dd ->
                div '.w100.left', ->
                  select '#lang_copy_from.w100.select', name: 'lang_copy_from', ->
                    option value: 'en', 'English'
                  br()
                  select '#lang_copy_to.w100.select mt5', name: 'lang_copy_to', ->
                    option value: 'en', 'English'
                div '.w30.h50 left ml5', style: 'background:url(/backend/images/icon_24_from_to.png) no-repeat 50% 50%;'
            # 'Submit button'
            dl '.small', ->
              dt '&#160;'
              dd ->
                input '#copy_lang.submit', type: 'submit', value: @ion_lang.ionize_button_copy_content
          
          # 'Advanced actions with content'
          h3 '.toggler', -> @ion_lang.ionize_title_advanced_language
          div '.element', ->
            p @ion_lang.ionize_notify_advanced_language
            form '#cleanLangForm', name: 'cleanLangForm', method: 'post', ->
              input '#submit_clean.submit', type: 'submit', value: @ion_lang.ionize_button_clean_lang_tables
              label title: @ion_lang.ionize_help_clean_lang_tables
        # '/options'
      # '/sidecolumn'
      # 'Main Column'
      div '#maincolumn', ->
        h2 '#main-title.main.languages', -> @ion_lang.ionize_title_language
        # 'No languages'
        form '#existingLangForm', name: 'existingLangForm', method: 'post', action: 'admin/lang/update', ->
          input '#current_default_lang', name: 'current_default_lang', type: 'hidden', value: 'en'
          h3 '.toggler1.mt20', -> @ion_lang.ionize_title_existing_languages
          
          div '.element1', ->
            # 'Sortable UL'
            ul '#langContainer.sortable.pb20', ->
              
              for lang in @langs          
                li "#langElement_#{lang.lang}.sortme.h100", rel: lang.lang, ->
                  # 'Drag icon'
                  div '.drag.left h100', ->
                    img src: '/backend/images/icon_16_ordering.png'
                  # 'Lang Code'
                  dl '.small', ->
                    dt ->
                      label for: "lang_#{lang.lang}", -> @ion_lang.ionize_label_code
                    dd ->
                      input "#lang_#{lang.lang}.inputtext", name: "lang_#{lang.lang}", type: 'text', value: lang.lang
                      # 'Delete button'
                      a class: 'icon right delete', rel: lang.lang
                  # 'Name'
                  dl '.small', ->
                    dt ->
                      label for: "name#{lang.lang}", -> @ion_lang.ionize_label_name
                    dd ->
                      input "#name_#{lang.lang}.inputtext", name: "name_#{lang.lang}", type: 'text', value: lang.name
                  # 'Online ?'
                  dl '.small', ->
                    dt ->
                      label for: "online_#{lang.lang}", -> @ion_lang.ionize_label_online
                    dd ->
                      input "#online_#{lang.lang}.inputcheckbox", name: "online_#{lang.lang}", checked: ('checked' if lang.online is 1), type: 'checkbox', value: '1'
                  # 'Default ?'
                  dl '.small', ->
                    dt ->
                      label for: "def_#{lang.lang}", -> @ion_lang.ionize_label_default
                    dd ->
                      input "#def_#{lang.lang}.inputradio", checked: ('checked' if lang.def is 1), type: 'radio', name: 'default_lang', value: lang.lang
          
          # 'URLs'
          h3 '.toggler1', -> @ion_lang.ionize_title_lang_urls
          div '.element1', ->
            dl '.last', ->
              dt ->
                label for: 'force_lang_urls', -> @ion_lang.ionize_label_force_lang_urls
              dd ->
                input '#force_lang_urls.inputcheckbox', type: 'checkbox', name: 'force_lang_urls', value: '1'

    coffeescript ->
      #
      # New lang form action
      # see init-form.js for more information about this method
      #
      ION.setFormSubmit "newLangForm", "submit_new", "lang\/\/save"
      
      #
      # Clean Lang tables form action
      #
      ION.setFormSubmit "cleanLangForm", "submit_clean", "lang\/\/clean_tables",
        message: Lang.get("ionize_confirmation_clean_lang")

      #
      # Panel toolbox
      #
      ION.initToolbox "lang_toolbox"
      ION.initAccordion ".toggler", "div.element", true, "langAccordion1"
      ION.initAccordion ".toggler1", "div.element1", false, "langAccordion2"

      #
      #  Init help tips on label
      #  see init-content.js
      #
      ION.initLabelHelpLinks "#options"
      
      #
      # Content copy confirmation callback
      #
      copyLang = ->
        url = admin_url + "lang/copy_lang_content"
        data =
          case: "lang"
          from: $("lang_copy_from").value
          to: $("lang_copy_to").value

        ION.sendData url, data

      #
      # Copy content
      #
      $("copy_lang").addEvent "click", (e) ->
        e.stop()
        ION.confirmation "copyLangConfWindow", copyLang, Lang.get("ionize_message_confirm_copy_whole_content")

      #
      # Lang itemManager
      # Use of ItemManager.deleteItem, etc.
      #
      langManager = new ION.ItemManager(
        element: "lang"
        container: "langContainer"
      )

      langManager.makeSortable()

