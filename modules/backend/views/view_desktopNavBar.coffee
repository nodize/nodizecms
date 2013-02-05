@include = ->
  
  #
  # This view is displaying the application header bar, with login & menus
  #
  @view 'backend_desktopNavBar': ->
    # div ".navbar.navbar-fixed-top", -> # Fixed "on top" 
    div ".navbar", ->
      div ".navbar-inner", ->
        div ".container-fluid", ->
          a ".brand", href: "/", ->
            
            i "#icon_connected", class:'icon-ok-sign icon-white', style:"display:none"
            i "#icon_disconnected", class:'icon-remove-sign icon-red', style:"display:none"

            text " Nodize"
          ul ".nav.user_menu.pull-right", ->
            # Can be used to display pending notifications 

            # li ".hidden-phone.hidden-tablet", ->
            #   div ".nb_boxes.clearfix", ->
            #     a ".label.ttip_b", "data-toggle": "modal", "data-backdrop": "static", href: "#invoiceAdd", title: "New messages", ->
            #       text "25 "
            #       i class:"splashy-mail_light"
            #     a ".label.ttip_b", "data-toggle": "modal", "data-backdrop": "static", href: "#myTasks", title: "New tasks", ->
            #       text "10 "
            #       i class:"splashy-calendar_week"

            li class:"divider-vertical hidden-phone hidden-tablet"
            li ".dropdown", ->
              a ".dropdown-toggle", href: "#", "data-toggle": "dropdown", ->
                text @user.toUpperCase().charAt(0)+@user.substring(1)+' '
                b class:"caret"
              ul ".dropdown-menu", ->
                li ->
                  a href: "/admin/logout", "Log Out"

          # a ".btn_menu", "data-target": ".nav-collapse", "data-toggle": "collapse", ->
          #   span class:"icon-align-justify icon-white"
          nav ->
            div ".nav-collapse", ->
              ul ".nav", ->

                # ----------------------------
                # Content
                # ----------------------------
                li ".dropdown", ->                  
                  #
                  # Dropdown title
                  #
                  a ".dropdown-toggle", "data-toggle": "dropdown", href: "#", ->
                    i class:"icon-list-alt icon-white"
                    text " #{@ion_lang.ionize_menu_content} "
                    b class:"caret"
                  #
                  # Dropdown items
                  #
                  ul ".dropdown-menu", ->
                    li ->
                      a '.navlink', href: "menu", -> @ion_lang.ionize_menu_menu
                    li ->
                      a '.navlink', href: "page\/\/create/0", -> @ion_lang.ionize_menu_page
                    li ->
                      a '.navlink', href: "article\/\/list_articles", -> @ion_lang.ionize_menu_articles
                    li class:"divider"
                    li ->
                      a '#mediamanagerlink', href: "media\/\/get_media_manager", -> @ion_lang.ionize_menu_media_manager
                    

                
                # ----------------------------
                # Settings
                # ----------------------------
                li ".dropdown", ->                  
                  #
                  # Dropdown title
                  #
                  a ".dropdown-toggle", "data-toggle": "dropdown", href: "#", ->
                    i class:"icon-wrench icon-white"
                    text " #{@ion_lang.ionize_menu_settings} "
                    b class:"caret"
                  #
                  # Dropdown items
                  #
                  ul ".dropdown-menu", ->
                    li ->
                      a '.navlink', href: "lang", -> @ion_lang.ionize_menu_languages
                    li ->
                      a '.navlink', href: "users", -> @ion_lang.ionize_menu_users
                    li ->
                      a '.navlink', href: "setting\/\/themes", -> @ion_lang.ionize_menu_theme
                             
                #     i class:"icon-th icon-white"
                #     text " Components "
                #     b class:"caret"
                             
                   
                # i class:"icon-file icon-white"
                # text " Pages "
              

    coffeescript ->
      $$(".navlink").each (item) ->
        item.addEvent "click", (event) ->
          event.preventDefault()
          MUI.Content.update
            url: admin_url + ION.cleanUrl(@getProperty("href"))
            element: "mainPanel"
            title: @getProperty("title")

      $("mediamanagerlink").addEvent "click", (event) ->
        event.preventDefault()
        MUI.Content.update
          url: admin_url + ION.cleanUrl(@getProperty("href"))
          element: "mainPanel"
          title: @getProperty("title")
          padding:
            top: 0
            right: 0
            bottom: 0
            left: 0