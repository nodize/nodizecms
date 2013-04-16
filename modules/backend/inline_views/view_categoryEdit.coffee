# Category edition page in backend
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
  # Displaying category edition page
  #
  @view backend_categoryEdit : ->    
    html ->
      # "Category edit view - Modal window"
      form "#categoryForm"+@category.id_category, name: "categoryForm"+@category.id_category, action: "/admin/category\/\/update", ->
        # "Hidden fields"
        input "#id_category", name: "id_category", type: "hidden", value: @category.id_category
        input "#parent", name: "parent", type: "hidden", value: ""
        input "#id_parent", name: "id_parent", type: "hidden", value: ""
        input "#ordering", name: "ordering", type: "hidden", value: @category.ordering
        # "Name"
        dl ".small", ->
          dt ->
            label for: "name", -> @ion_lang.ionize_label_name
          dd ->
            input "#name.inputtext.required", name: "name", type: "text", value: @category.name
        fieldset "#blocks", ->
          # "Tabs"
          div "#categoryTab#{@category.id_category}.mainTabs", ->
            ul ".tab-menu", ->
              for lang in Static_langs_records
                li ".tab_edit_category"+@category.id_category, rel: lang.lang, ->
                  a lang.name              
            div class:"clear"
          div "#categoryTabContent"+@category.id_category, ->
            # "Text block"
            for category_lang in @category_langs           
              div ".tabcontent"+@category.id_category, ->
                # "title"
                dl ".small", ->
                  dt ->
                    label for: "title", -> @ion_lang.ionize_label_title
                  dd ->
                    input "#title_#{category_lang.lang}.inputtext.w180", name: "title_#{category_lang.lang}", type: "text", value: category_lang.title or ""
                # "subtitle"
                dl ".small", ->
                  dt ->
                    label for: "subtitle#{category_lang.lang}", -> @ion_lang.ionize_label_subtitle
                  dd ->
                    input "#subtitle_#{category_lang.lang}.inputtext", name: "subtitle_#{category_lang.lang}", type: "text", value: category_lang.subtitle or ""
                # "description"
                dl ".small", ->
                  dt ->
                    label title: @ion_lang.ionize_label_help_description, for: "description_#{category_lang.lang}", -> @ion_lang.ionize_label_help_description
                  dd ->
                    textarea "#description_#{category_lang.lang}.tinyCategory.w220.h120", name: "description_#{category_lang.lang}", rel: category_lang.lang, 
                      -> category_lang.description
                    
      # 
      #  Save / Cancel buttons
      #  Must be named bSave[windows_id] where 'window_id' is the used ID for the window opening through ION.formWindow()
      #  
      div ".buttons", ->
        button "#bSavecategory#{@category.id_category}.button.yes.right.mr40", type: "button", -> @ion_lang.ionize_button_save_close
        button "#bCancelcategory#{@category.id_category}.button.no.right", type: "button", -> @ion_lang.ionize_button_cancel


      text """
      <script>
        var id_category = #{@category.id_category};
      </script>
      """

      coffeescript ->
        #
        # Tabs init
        #
        new TabSwapper(
          tabsContainer: "categoryTab"+id_category
          sectionsContainer: "categoryTabContent"+id_category
          selectedClass: "selected"
          deselectedClass: ""
          tabs: "li"
          clickers: "li a"
          sections: "div.tabcontent"+id_category
        )
        ION.initLabelHelpLinks "#categoryForm"+id_category

        #
        # TinyEditors
        # Must be called after tabs init.
        #
        ION.initTinyEditors ".tab_edit_category"+id_category, "#categoryTabContent#{id_category} .tinyCategory", "small",
          height: 120

        #
        # Window resize
        #
        ION.windowResize "category"+id_category,
          width: 500



