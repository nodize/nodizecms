@include = ->

  #
  # Displaying lang settings toolbox
  #
  @view backend_langToolbox: ->
    html ->
      div '.toolbox.divider nobr', ->
        input '#existingLangFormSubmit.submit', type: 'button', value: @ion_lang.ionize_button_save
      div '.toolbox.divider', ->
        input '#sidecolumnSwitcher.toolbar-button', type: 'button', value: @ion_lang.ionize_label_hide_options

    coffeescript ->
      #
      # Adds action to the existing languages form
      # See mocha-init.js for more information about this method
      #      
      ION.setFormSubmit 'existingLangForm', 'existingLangFormSubmit', 'lang\/\/update'

      #
      # Options show / hide button
      #      
      ION.initSideColumn()

      #
      # Save with CTRL+s
      #
      #
      ION.addFormSaveEvent 'existingLangFormSubmit'