# Users / groups management page in backend
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Original page design :
# IonizeCMS (http://www.ionizecms.com), 
# (c) Partikule (http://www.partikule.net)
#
# CoffeeKup conversion & adaptation :
# Hypee (http://hypee.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->

  #
  # Displaying users management page
  #
  @view backend_users: ->
    html ->
      div "#maincolumn", ->
        h2 "#main-title.main.groups", @ion_lang.ionize_title_users
        # ------------------------------
        # Tabs definition
        # ------------------------------
        div "#usersTab.mainTabs.mt20", ->
          ul ".tab-menu", ->
            li "#usersListTab", ->
              a @ion_lang.ionize_title_existing_users
            li ->
              a @ion_lang.ionize_title_existing_groups
            
          div class:"clear"
        
        # ------------------------------
        # List of existing users
        # ------------------------------
        div "#usersTabContent", ->
          div ".tabcontent", ->
            div ".tabsidecolumn", ->
              # "Infos about all users"
              div ".info.mb10", ->
                #
                # Displaying user count & last registered user
                # Not implemented yet
                #

                # dl ".small.compact", ->
                #   dt ->
                #     label @ion_lang.ionize_label_users_count
                #   dd "1"
                # dl ".small.compact", ->
                #   dt ->
                #     label @ion_lang.ionize_label_last_registered
                #   dd()
              h3 ".toggler1", @ion_lang.ionize_title_filter_userslist
              div ".element1", ->
                # "User list filter"
                form "#usersFilter", name: "usersFilter", method: "post", action: "http://192.168.1.162/admin/users/users_list", ->
                  # "Users / page"
                  dl ".small", ->
                    dt ->
                      label for: "filter_nb", -> @ion_lang.ionize_label_users_per_page
                    dd ->
                      input "#filter_nb.inputtext.w60", type: "text", name: "nb", value: 50
                  # "Group"
                  dl ".small", ->
                    dt ->
                      label for: "filter_id_group", -> @ion_lang.ionize_label_group
                    dd ->
                      select "#filter_slug.select", name: "slug", ->
                        option value: "", -> @ion_lang.ionize_label_all_groups
                        for user_group in @user_groups
                          option value: user_group.slug, -> user_group.group_name
                        
                  # "ID"
                  dl ".small", ->
                    dt ->
                      label for: "filter_username", -> @ion_lang.ionize_label_username
                    dd ->
                      input "#filter_username.inputtext.w140", type: "text", name: "username", value: ""
                  # "Screen name"
                  dl ".small", ->
                    dt ->
                      label for: "filter_screenname", -> @ion_lang.ionize_label_screen_name
                    dd ->
                      input "#filter_screenname.inputtext.w140", type: "text", name: "screenname", value: ""
                  # "Email"
                  dl ".small", ->
                    dt ->
                      label for: "filter_email", -> @ion_lang.ionize_label_email
                    dd ->
                      input "#filter_email.inputtext.w140", type: "text", name: "email", value: ""
                  # "Last registered"
                  dl ".small", ->
                    dt ->
                      label for: "filter_registered", -> @ion_lang.ionize_label_last_registered
                    dd ->
                      input "#filter_registered.inputcheckbox", type: "checkbox", name: "registered", value: 1
                  # "Submit"
                  dl ".small", ->
                    dt "&#160;"
                    dd ->
                      input "#submit_filter.submit", type: "submit", value: "Filter"
              h3 ".toggler1", @ion_lang.ionize_title_add_user
              div ".element1", ->
                form "#newUserForm", name: "newUserForm", method: "post", action: "http://192.168.1.162/admin/users/save", ->
                  # "Username"
                  dl ".small", ->
                    dt ->
                      label for: "username", -> @ion_lang.ionize_label_username
                    dd ->
                      input "#username.inputtext.w140", name: "username", type: "text", value: ""
                  # "Screen name"
                  dl ".small", ->
                    dt ->
                      label for: "screen_name", -> @ion_lang.ionize_label_screen_name
                    dd ->
                      input "#screen_name.inputtext.w140", name: "screen_name", type: "text", value: ""
                  # "Group"
                  dl ".small", ->
                    dt ->
                      label for: "group_FK", -> @ion_lang.ionize_label_group
                    dd ->
                      select ".select", name: "id_group", ->
                        for user_group in @user_groups
                          option value: user_group.id_group, -> user_group.group_name
                        
                  # "Email"
                  dl ".small", ->
                    dt ->
                      label for: "email", -> @ion_lang.ionize_label_email
                    dd ->
                      input "#email.inputtext.w140", name: "email", type: "text", value: ""
                  # "Password"
                  dl ".small", ->
                    dt ->
                      label for: "password", -> @ion_lang.ionize_label_password
                    dd ->
                      input "#password.inputtext.w120", name: "password", type: "password", value: ""
                  # "Password confirm"
                  dl ".small", ->
                    dt ->
                      label for: "password2", -> @ion_lang.ionize_label_password2
                    dd ->
                      input "#password2.inputtext.w120", name: "password2", type: "password", value: ""
                  # "Submit button"
                  dl ".small", ->
                    dt "&#160;"
                    dd ->
                      input "#submit_new_user.submit", type: "submit", value: @ion_lang.ionize_button_save
            # "Users list"
            div ".tabcolumn", ->
              div id:"usersList"

          # ------------------------------
          # Groups
          # ------------------------------
          div ".tabcontent", ->
            #
            # "New group" box
            #
            div ".tabsidecolumn", ->
              h3 @ion_lang.ionize_title_add_group
              form "#newGroupForm", name: "newGroupForm", method: "post", action: "/admin/groups/save", ->
                # "Group name"
                dl ".small", ->
                  dt ->
                    label for: "group_name", -> @ion_lang.ionize_label_group_name
                  dd ->
                    input "#slug.inputtext.w140", name: "group_name", type: "text", value: ""
                # "Level"
                dl ".small", ->
                  dt ->
                    label for: "level", -> @ion_lang.ionize_label_group_level
                  dd ->
                    input "#slug.inputtext.w140", name: "level", type: "text", value: "100"
                # "Submit button"
                dl ".small", ->
                  dt "&#160;"
                  dd ->
                    input "#submit_new_group.submit", type: "submit", value: "Save"

            #
            # "Groups list"
            #
            div ".tabcolumn", ->
              table "#groupsTable.list", ->
                thead ->
                  tr ->
                    th axis: "string", -> @ion_lang.ionize_label_id
                    th axis: "string", -> @ion_lang.ionize_label_group_name
                    #th axis: "string", -> @ion_lang.ionize_label_group_title
                    th axis: "string", -> @ion_lang.ionize_label_group_level
                    #th axis: "string", -> @ion_lang.ionize_label_group_description
                    th()
                tbody ->
                  for user_group in @user_groups                          
                    tr ".groups#{user_group.id}", ->
                      td user_group.id
                      td ->
                        a "#group#{user_group.id}.group", rel: user_group.id, href: @lang+"/admin/groups/edit/"+user_group.id, -> user_group.group_name
                      #td user_group.group_name
                      td user_group.level
                      # td()
                      td ->
                        a ".icon.delete", rel:user_group.id_group
                  
          
      # /maincolumn

      coffeescript ->
        #
        # Panel toolbox
        #
        ION.initToolbox "empty_toolbox"

        #
        # Options Accordion
        #
        ION.initAccordion ".toggler1", "div.element1", false, "usersAccordion"

        #
        # Tabs init
        #
        usersTabSwapper = new TabSwapper(
          tabsContainer: "usersTab"
          sectionsContainer: "usersTabContent"
          selectedClass: "selected"
          deselectedClass: ""
          tabs: "li"
          clickers: "li a"
          sections: "div.tabcontent"
          cookieName: "usersTab"
        )

        #
        # Users list tab
        #
        $("usersListTab").addEvent "click", ->
          unless @retrieve("loaded")
            ION.updateElement
              url: "users\/\/users_list"
              element: "usersList"


        #
        # Init help tips on label
        #
        $("usersListTab").fireEvent "click"
        ION.initLabelHelpLinks "#newUserForm"
        ION.initLabelHelpLinks "#newGroupForm"        

        #
        # New user form action
        # see init.js for more information about this method
        #
        ION.setFormSubmit "newUserForm", "submit_new_user", "users\/\/save"
        ION.setFormSubmit "newGroupForm", "submit_new_group", "groups\/\/save"

        #
        # Filter users list
        #
        $("submit_filter").addEvent "click", (e) ->
          e.stop()
          new Request.HTML(
            url: admin_url + "users\/\/users_list"
            method: "post"
            loadMethod: "xhr"
            data: $("usersFilter")
            update: $("usersList")
            onRequest: ->
              MUI.showSpinner()

            onFailure: (xhr) ->
              MUI.hideSpinner()

            onComplete: ->
              MUI.hideSpinner()
          ).send()

        #
        # Events to each group
        # Opens an edition window
        #
        $$(".group").each (item) ->
          item.addEvent "click", (e) ->
            e.stop()
            id = item.getProperty("rel")
            ION.formWindow id, "groupForm", "ionize_title_group_edit", "groups\/\/edit\/" + id,
              width: 340
              height: 230

        #
        # Groups itemManager
        #
        groupsManager = new ION.ItemManager(
          container: "groupsTable"
          element: "groups"
        )

        #
        #  Adds Sortable function to the user list table
        #
        new SortableTable("groupsTable",
          sortOn: 3
          sortBy: "ASC"
        )
