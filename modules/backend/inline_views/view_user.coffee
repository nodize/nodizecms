# User edition page in backend
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
  @view backend_user: ->
    html ->
      form "#userForm", name: "userForm", action: "/admin/users\/\/update", ->
        # "Hidden fields"
        input "#user_PK", name: "user_PK", type: "hidden", value: @user.id_user
        # "Username"
        dl ".small", ->
          dt ->
            label for: "username", -> @ion_lang.ionize_label_username
          dd ->
            input "#username.inputtext", name: "username", type: "text", value: @user.username
        # "Screen Name"
        dl ".small", ->
          dt ->
            label for: "screen_name", -> @ion_lang.ionize_label_screen_name
          dd ->
            input "#screen_name.inputtext", name: "screen_name", type: "text", value: @user.screen_name
        # "Email"
        dl ".small", ->
          dt ->
            label for: "email", ->  @ion_lang.ionize_label_email
          dd ->
            input "#email.inputtext.w200", name: "email", type: "text", value: @user.email
        # "Group"
        dl ".small", ->
          dt ->
            label for: "email", -> @ion_lang.ionize_label_group
          dd ->
            select ".select", name: "id_group", ->              
              
              for group in @groups
                option value:group.id, selected:("selected" if @user.id_group is group.id), -> group.group_name
              
        # "New password"
        h3 @ion_lang.ionize_title_change_password
        # "Password"
        dl ".small", ->
          dt ->
            label for: "password", -> @ion_lang.ionize_label_password
          dd ->
            input "#password.inputtext.i120", name: "password", type: "password", value: ""
        # "Password confirm"
        dl ".small", ->
          dt ->
            label for: "password2", -> @ion_lang.ionize_label_password2
          dd ->
            input "#password2.inputtext.i120", name: "password2", type: "password", value: ""       
      div ".buttons", ->
        button "#bSaveuser1.button.yes.right.mr40", type: "button", -> @ion_lang.ionize_button_save_close
        button "#bCanceluser1.button.no.right", type: "button", -> @ion_lang.ionize_button_cancel