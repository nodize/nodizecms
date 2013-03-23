# GROUP, edition modal window
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
  # Displaying group edition page
  #
  @view backend_group: ->
    html ->
      form "#groupForm", name: "groupForm", action:  "/admin/groups\/\/update", ->
        # "Hidden fields"
        input "#group_PK", name: "group_PK", type: "hidden", value: @user_group.id
        # "Group name"
        dl ".small", ->
          dt ->
            label for: "group_name", -> @ion_lang.ionize_label_group_name
          dd ->
            input "#group_name.inputtext", name: "group_name", type: "text", value: @user_group.group_name
        # "Level"
        dl ".small", ->
          dt ->
            label for: "level", -> @ion_lang.ionize_label_group_level
          dd ->
            input "#level.inputtext", name: "level", type: "text", value: @user_group.level

      div ".buttons", ->
        button "#bSave#{@user_group.id}.button.yes.right.mr40", type: "button", -> @ion_lang.ionize_button_save_close
        button "#bCancel#{@user_group.id}.button.no.right", type: "button", -> @ion_lang.ionize_button_cancel