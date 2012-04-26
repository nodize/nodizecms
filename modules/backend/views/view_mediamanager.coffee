# Media Manager in backend
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
  # Toolboxes for article
  #
  @view backend_mediamanager: ->
    div id:"mootools-filemanager"

    coffeescript ->
      ION.initToolbox()
      xhr = new Request.JSON(
        url: "/admin/media/get_tokken"
        method: "post"
        onSuccess: (responseJSON, responseText) ->
          if responseJSON and responseJSON.tokken isnt ""
            filemanager = new FileManager(
              url: admin_url + "media/filemanager"
              URLpath4assets: theme_url + "javascript/mootools-filemanager/Assets"
              language: Lang.get("current")
              standalone: false
              selectable: false
              createFolders: true
              destroy: true
              rename: true
              move_or_copy: true
              hideOnClick: false
              hideOnSelect: false
              parentContainer: "mainPanel"
              propagateData:
                uploadTokken: responseJSON.tokken

              mkServerRequestURL: (fm_obj, request_code, post_data) ->
                url: fm_obj.options.url + "/" + request_code
                data: post_data
            )
            content = filemanager.show()
            content.inject $("mootools-filemanager")
      ).send()

