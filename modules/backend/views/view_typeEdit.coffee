# Type edition page in backend
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
  # Displaying type edition page
  #
  @view backend_typeEdit: ->    
    form "#article_typeForm#{@article_type.id_type}", name: "article_typeForm#{@article_type.id_type}", action: "/admin/article_type\/\/update", ->
      # "Hidden fields"
      input "#id_type", name: "id_type", type: "hidden", value: @article_type.id_type
      input "#parent", name: "parent", type: "hidden", value: ""
      input "#id_parent", name: "id_parent", type: "hidden", value: ""
      # "Name"
      dl ".small", ->
        dt ->
          label for: "type", "Type"
        dd ->
          input "#type.inputtext.required", name: "type", type: "text", value: @article_type.type
      # "Flag"
      dl ".small", ->
        dt ->
          label for: "flag_type#{@article_type.id_type}", title: @ion_lang.ionize_help_flag, -> @ion_lang.ionize_label_flag
        dd ->
          for flag in [0..5]
            label ".flag.flag#{flag}", ->
              input ".inputradio", name: "type_flag", type: "radio", value: flag, checked: ("checked" if @article_type.type_flag is flag)

      # "Description"
      dl ".small", ->
        dt ->
          label for: "description_type#{@article_type.id_type}", -> @ion_lang.ionize_label_description
        dd ->
          textarea "#description_type#{@article_type.id_type}.tinyType_type#{@article_type.id_type}.w240.h120", name: "description", -> @article_type.description
      
    #  Save / Cancel buttons
    #     Must be named bSave[windows_id] where 'window_id' is the used ID for the window opening through ION.formWindow()    
    div ".buttons", ->
      button "#bSavearticle_type#{@article_type.id_type}.button.yes.right.mr40", type: "button", -> @ion_lang.ionize_button_save_close
      button "#bCancelarticle_type#{@article_type.id_type}.button.no.right", type: "button", -> @ion_lang.ionize_button_cancel

    text """
    <script>
      var id_type = #{@article_type.id_type};
    </script>
    """

    coffeescript ->
      ION.windowResize "article_type#{id_type}", {width:450, height:200}
      
      tinyMCE.init ION.tinyMceSettings "tinyType_type#{id_type}", 240, 120, 'small'


