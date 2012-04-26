# Toolbox for article list page in backend
#
# Nodize CMS
# https://github.com/hypee/nodize
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
  # This view is displaying the articles list toolbox
  #
  @view 'backend_articleListToolbox': ->
    div ".toolbox.divider", ->
      input "#newArticleToolbarButton.toolbar-button", type: "button", value: @ion_lang.ionize_title_create_article
      div ".toolbox"

    coffeescript ->
      #
      # New article button
      #
      $("newArticleToolbarButton").addEvent "click", (e) ->
        e.stop()
        MUI.Content.update
          element: $(ION.mainpanel)
          loadMethod: "xhr"
          url: admin_url + "article/create"
          title: Lang.get("ionize_title_create_article")
