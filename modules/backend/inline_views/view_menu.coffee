@include = ->

  #
  # Displaying lang settings page
  #
  @view backend_menu: ->    
    html ->
      div '#sidecolumn.close', ->
        div '#options.mt20', ->
          # New Menu'
          h3 '.toggler', @ion_lang.ionize_title_add_menu
          div '.element', ->
            form '#newMenuForm', name: 'newMenuForm', method: 'post', action: 'admin/menu\/\/save', ->
              # Menu Name'
              dl '.small', ->
                dt ->
                  label for: 'name_new', -> @ion_lang.ionize_label_name
                dd ->
                  input '#name_new.inputtext.w140', name: 'name_new', type: 'text', value: ''
              # Menu Title'
              dl '.small', ->
                dt ->
                  label for: 'title_new', -> @ion_lang.ionize_label_title
                dd ->
                  input '#title_new.inputtext.w140', name: 'title_new', type: 'text', value: ''
                  br()
              # Submit button'
              dl '.small', ->
                dt '&#160;'
                dd ->
                  input '#submit_new.submit', type: 'submit', value: 'Save Menu'
          # /element'
        # /options'
      # /sidecolumn'
      # Main Column'

      div '#maincolumn', ->
        form '#existingMenuForm', name: 'existingMenuForm', method: 'post', action: '/admin/menu/update', ->
          h3 @ion_lang.ionize_title_existing_menu
          # Sortable UL'
          ul '#menuContainer.sortable', ->
            #
            # Loop through menus
            #
            for menu in @menus
              li "#menu_#{menu.id_menu}.sortme", rel: menu.id_menu, ->
                # Drag icon'
                div '.drag', style: 'float:left;height:100px;', ->
                  img src: "#{@settings.assetsPath}/images/icon_16_ordering.png"
                # Name'
                dl '.small', ->
                  dt ->
                    label for: "name_#{menu.id_menu}", -> @ion_lang.ionize_label_name
                  dd ->
                    input '.inputtext', type: 'text', disabled: 'disabled', value: menu.name
                    input "#name_#{menu.id_menu}.inputtext", type: 'hidden', name: "name_#{menu.id_menu}", value: menu.name
                    # Delete button'                    
                    a class:'icon right delete', rel:menu.id_menu if menu.id_menu > 1
                # Title'
                dl '.small', ->
                  dt ->
                    label for: 'title_1', -> @ion_lang.ionize_label_title
                  dd ->
                    input '#title_#{menu.id_menu}.inputtext', name: "title_#{menu.id_menu}", type: 'text', value: menu.title
                # Internal ID'
                dl '.small', ->
                  dt ->
                    label @ion_lang.ionize_label_internal_id
                  dd menu.id_menu

            
      # /maincolumn'
      
    coffeescript ->
      #
      # Form action
      # see init-form.js for more information about this method
      #
      ION.setFormSubmit "newMenuForm", "submit_new", "menu\/\/save"

      #
      # Panel toolbox
      #
      ION.initToolbox "menu_toolbox"
            
      ION.initAccordion ".toggler", "div.element", true, "menuAccordion1"
      
      #
      # Menu itemManager
      # Use of ItemManager.deleteItem, etc.
      #
      menuManager = new ION.ItemManager(
        element: "menu"
        container: "menuContainer"
      )
      menuManager.makeSortable()
    