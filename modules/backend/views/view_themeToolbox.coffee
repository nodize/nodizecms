@include = ->

  #
  # Displaying lang settings page
  #
  @view backend_themesToolbox: ->
    div '.toolbox.divider nobr', ->
      input '#viewsFormSubmit.submit', type: 'button', value: 'Save'
    div '.toolbox.divider', ->
      input id:'sidecolumnSwitcher', class:'toolbar-button', type: 'button', value: 'Hide Options'

    coffeescript ->
      #
      # Views form
      # see ionize-form.js for more information about this method
      #
      ION.setFormSubmit "viewsForm", "viewsFormSubmit", "setting\/\/save_views"

      #
      # Options show / hide button
      #
      ION.initSideColumn()

      #
      # Save with CTRL+s
      #
      ION.addFormSaveEvent "viewsFormSubmit"