# Users list page in backend
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
  @view backend_userList: ->
    html ->
      # "Pages"
      ul "#users_pagination.pagination", table "#usersTable.list", ->
        thead ->
          tr ->
            th axis: "string", -> @ion_lang.ionize_label_id
            th axis: "string", -> @ion_lang.ionize_label_username
            th axis: "string", -> @ion_lang.ionize_label_screen_name
            th axis: "string", -> @ion_lang.ionize_label_email
            th axis: "string", -> @ion_lang.ionize_label_group
            th axis: "string", -> @ion_lang.ionize_label_join_date
            th()
        tbody ->
          for user in @users
            tr ".users"+user.id_user, ->
              td user.id_user
              td ->
                a "#user#{user.id_user}.user", rel: user.id_user, href: "/admin/users\/\/edit/#{user.id_user}", -> user.username
              td user.screen_name
              td user.email
              td @groups[ user.id_group ]
              td user.join_date?._toMysql()
              td ->
                a ".icon.delete", rel: user.id_user

    coffeescript ->
      #
      # Users itemManager
      # Manager delete
      #
      usersManager = new ION.ItemManager(
        container: "usersTable"
        element: "users"
      )
      #
      # Sortable on the current users list table
      #
      new SortableTable("usersTable",
        sortOn: 0
        sortBy: "ASC"
      )

      #
      # User Edit window
      #
      $$(".user").each (item) ->
        item.addEvent "click", (e) ->
          e.stop()
          id = item.getProperty("rel")
          wid = "user" + id
          ION.formWindow wid, "userForm", "ionize_title_user_edit", "users\/\/edit/" + id,
            width: 400
            resize: true

      #
      # Pagination element link
      #
      $$("#users_pagination li a").each (item, idx) ->
        item.addEvent "click", (e) ->
          e.stop()
          new Request.HTML(
            url: admin_url + "users\/\/users_list/" + @getProperty("rel") + "/50"
            method: "post"
            loadMethod: "xhr"
            data: $("usersFilter")
            update: $("usersList")
          ).send()


