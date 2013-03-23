
#
# Displaying lang settings page
#


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
              div '.drag.left.h100', ->
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
  # Lang itemManager
  # Use of ItemManager.deleteItem, etc.
  #
  langManager = new ION.ItemManager(
    element: "lang"
    container: "langContainer"
  )

  langManager.makeSortable()

