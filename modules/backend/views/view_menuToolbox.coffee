@include = ->

  #
  # Displaying lang settings page
  #
  @view backend_menuToolbox: ->
    html ->
      div '.toolbox.divider nobr', ->
        input '#existingMenuFormSubmit.submit', type: 'button', value: 'Save'
      div '.toolbox.divider', ->
        input '#sidecolumnSwitcher.toolbar-button', type: 'button', value: 'Hide Options'

    coffeescript ->
      #
      # Adds action to the existing menus form
      # See mocha-init.js for more information about this method
      #
      ION.setFormSubmit "existingMenuForm", "existingMenuFormSubmit", "menu\/\/update"

      #
      # Options show / hide button
      #
      ION.initSideColumn()

      #
      # Save with CTRL+s
      #
      ION.addFormSaveEvent "existingMenuFormSubmit"