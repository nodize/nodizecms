# Article edition page in backend
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
  # Displaying article edition page
  #
  @view backend_article: ->
    html ->
      form '#articleForm', name: 'articleForm', method: 'post', action: "/en/admin/article/save/{@article.id_article}", ->
        input '#element', type: 'hidden', name: 'element', value: 'article'
        input '#id_article', type: 'hidden', name: 'id_article', value: @article.id_article
        input '#rel', type: 'hidden', name: 'rel', value: "#{@page.id_page}.#{@article.id_article or ''}"        
        input type: 'hidden', name: 'created', value: @article.created._toMysql()
        input type: 'hidden', name: 'author', value: ''
        input '#name', type: 'hidden', name: 'name', value: ''
        input '#main_parent', type: 'hidden', name: 'main_parent', value: @page.id_page
        input '#has_url', type: 'hidden', name: 'has_url', value: '1'
        # 'JS storing element'
        input '#memory', type: 'hidden'
        div '#sidecolumn.close', ->
          # 'Main informations'
          div '.info', ->
            if @article.id_article
              dl '.small.compact', ->
                dt ->
                  label @ion_lang.ionize_label_created
                dd ->

                  text @article.created._toMysql()
                  span '.lite', '19:04:22'
              dl '.small.compact', ->
                dt ->
                  label @ion_lang.ionize_label_updated
                dd ->
                  text '2011.08.25'
                  span '.lite', '16:40:45'

                # 'Link ?'
                # div id:'linkContainer'

                # 'Modules PlaceHolder'

          div '#options', ->
            # 'Options'
            h3 '.toggler.toggler-options', -> @ion_lang.ionize_title_attributes
            div '.element.element-options', ->
              # 'Indexed content'
              dl '.small', ->
                dt ->
                  label for: 'indexed', title: @ion_lang.ionize_help_indexed, -> @ion_lang.ionize_label_indexed
                dd ->
                  input '#indexed.inputcheckbox', name: 'indexed', type: 'checkbox', checked: 'checked', value: '1'
              # 'Categories'
              dl '.small', ->
                dt ->
                  label for: 'template', -> @ion_lang.ionize_label_categories
                dd ->
                  div '#categories', ->
                    select '.select.w140', name: 'categories[]', multiple: 'multiple', ->
                      option value: '0', '-- None --' 
                      
                      for category in @categories
                        selected = ''
                        
                        #
                        # Assigning "selected" options only if article does already exist
                        #
                        if @article.id_article
                          selected = 'selected' if category.id_category in @article_categories

                        option value: category.id_category, selected:selected,  -> category.name
                  
                  # 'Category create button'
                  a onclick: 'javascript:ION.formWindow(\'category\', \'categoryForm\', \'New category\', \'category/get_form/article/9\', {width:360, height:230})', 'Create a category'
              # 'Existing Article'

              if @article.id_article
                # 'Parent pages list'
                dl '.small.dropPageInArticle', ->
                  dt ->
                    label for: 'template', title: @ion_lang.ionize_help_article_context, -> @ion_lang.ionize_label_parents
                  dd ->
                    div '#parents', ->
                      ul '#parent_list.parent_list', ->
                        li '.parent_page', rel: '4.9', ->
                          a class: 'icon right unlink'
                          a class: 'page', ->
                            span class:'link-img page left mr5 main-parent'
                            text 'Examples'
                      comment '<input type="text" id="new_parent" class="inputtext w140 italic empty nofocus droppable" alt="drop a page here..."></input>'
              comment 'Flag \n\n\t\t\t\t<dl class="small">\n\n\t\t\t\t\t<dt>\n\n\t\t\t\t\t\t<label for="flag0" title="An internal marked, just to be organized.">Flag</label>\n\n\t\t\t\t\t</dt>\n\n\t\t\t\t\t\t<dd>\n\n\t\t\t\t\t\t\t<label class="flag flag0"><input id="flag0" name="flag" class="inputradio" type="radio"  checked="checked"  value="0" /></label>\n\n\t\t\t\t\t\t\t<label class="flag flag1"><input name="flag" class="inputradio" type="radio"  value="1" /></label>\n\n\t\t\t\t\t\t\t<label class="flag flag2"><input name="flag" class="inputradio" type="radio"  value="2" /></label>\n\n\t\t\t\t\t\t\t<label class="flag flag3"><input name="flag" class="inputradio" type="radio"  value="3" /></label>\n\n\t\t\t\t\t\t\t<label class="flag flag4"><input name="flag" class="inputradio" type="radio"  value="4" /></label>\n\n\t\t\t\t\t\t\t<label class="flag flag5"><input name="flag" class="inputradio" type="radio"  value="5" /></label>\n\n\t\t\t\t\t\t</dd>\n\n\t\t\t\t\t</dt>\n\n\t\t\t\t</dl>'
            comment 'Advanced options \n\n\t\t\t<h3 class="toggler">Advanced options</h3>\n\n\t\t\t\n\n\t\t\t<div class="element">\n\n\n\n\n\n\t\t\t\t<!-- Tags \n\n\t\t\t\t<dl class="small">\n\n\t\t\t\t\t<dt>\n\n\t\t\t\t\t\t<label for="template">Tags</label>\n\n\t\t\t\t\t</dt>\n\n\t\t\t\t\t<dd>\n\n\t\t\t\t\t\t<textarea id="tags" name="tags" class="inputtext w140 h40" type="text" onkeyup="formManager.toLowerCase(this, \'tags\');"></textarea>\n\n\t\t\t\t\t</dd>\n\n\t\t\t\t</dl>\n\n\t\t\t\t\n\n\t\t\t\t<!-- Existing Tags \n\n\t\t\t\t<dl class="small last">\n\n\t\t\t\t\t<dt>\n\n\t\t\t\t\t\t<label for="template">Existing tags</label>\n\n\t\t\t\t\t</dt>\n\n\t\t\t\t\t<dd></dd>\n\n\t\t\t\t</dl>\n\n\t\t\t\t\n\n\n\n\t\t\t</div>'
            # 'Dates'
            h3 '.toggler.toggler-options', -> @ion_lang.ionize_title_dates
            div '.element.element-options', ->
              dl '.small', ->
                dt ->
                  label for: 'logical_date', -> @ion_lang.ionize_label_date
                dd ->
                  logical_date = ''
                  logical_date = @article.logical_date._toMysql() if @article.logical_date isnt ''
                  input '#logical_date.inputtext.w120 date', name: 'logical_date', type: 'text', value: logical_date
              dl '.small', ->
                dt ->
                  label for: 'publish_on', -> @ion_lang.ionize_label_publish_on
                dd ->
                  publish_on = ''
                  publish_on = @article.publish_on._toMysql() if @article.publish_on isnt ''
                  input '#publish_on.inputtext.w120 date', name: 'publish_on', type: 'text', value: publish_on
              dl '.small.last', ->
                dt ->
                  label for: 'publish_off', -> @ion_lang.ionize_label_publish_off
                dd ->
                  publish_off = ''
                  publish_off = @article.publish_off._toMysql() if @article.publish_off isnt ''
                  input '#publish_off.inputtext.w120 date', name: 'publish_off', type: 'text', value: publish_off
            # 'Comments'
            h3 class:'toggler', -> @ion_lang.ionize_title_comments
            div '.element', ->
              dl '.small', ->
                dt ->
                  label for: 'comment_allow', -> @ion_lang.ionize_label_comment_allow
                dd ->
                  input '#comment_allow.inputcheckbox', name: 'comment_allow', type: 'checkbox'
              dl '.small', ->
                dt ->
                  label for: 'comment_autovalid', -> @ion_lang.ionize_label_comment_autovalid
                dd ->
                  input '#comment_autovalid.inputcheckbox', name: 'comment_autovalid', type: 'checkbox'
              dl '.small.last', ->
                dt ->
                  label for: 'comment_expire', -> @ion_lang.ionize_label_comment_expire
                dd ->
                  input '#comment_expire.inputtext.w120 date', name: 'comment_expire', type: 'text', value: ''
            # 'end comments'

            if @article.id_article
              # 'Copy Content'
              h3 '.toggler.toggler-options', -> @ion_lang.ionize_title_content
              div '.element.element-options', ->
                dl '.small', ->
                  dt ->
                    label for: 'lang_copy_from', title: @ion_lang.ionize_help_copy_content, -> @ion_lang.ionize_label_copy_content
                  dd ->
                    div '.w100.left', ->
                      select '#lang_copy_from.w100.select', name: 'lang_copy_from', ->
                        option value: 'en', 'English'
                      br()
                      select '#lang_copy_to.w100.select mt5', name: 'lang_copy_to', ->
                        option value: 'en', 'English'
                    div '.w30.h50 left ml5', style: 'background:url(http://192.168.1.162/themes/admin/images/icon_24_from_to.png) no-repeat 50% 50%;'
                # 'Submit button'
                dl '.small', ->
                  dt '&#160;'
                  dd ->
                    input '#copy_lang.submit', type: 'submit', value: @ion_lang.ionize_button_copy_content

              # 'Modules PlaceHolder'
          # '/options'
        # '/sidecolumn'

        div '#maincolumn', ->
          fieldset ->
            if @article.id_article
              # 'Existing article'
              h2 '#main-title.main.article', @article.name
            else
              # New article
              h2 '#main-title.main.article', @ion_lang.ionize_title_new_article

            div style: 'margin: -15px 0pt 20px 72px;', ->
              p ->
                span '.lite', 'ID :'
                text @page.id_page + '/' + (@article.id_article or '') + ' |'
                span '.lite', -> @ion_lang.ionize_label_article_context_edition+" : "
                text @page.name
            # 'New article'
            # 'extend fields goes here...'
          fieldset '#blocks.mt20', ->
            # 'Tabs'
            if @article.id_article
              inactiveClass = ""
            else
              inactiveClass = ".inactive"
            div '#articleTab.mainTabs', ->
              ul '.tab-menu', ->
                for lang in Static_langs_records
                  li ".tab_article #{".dl" if lang.def is 1}", rel: lang.lang, ->
                    a lang.name
                # li "#fileTab.right#{inactiveClass}", ->
                #   a 'Files'
                # li "#musicTab.right#{inactiveClass}", ->
                #   a 'Music'
                # li "#videoTab.right#{inactiveClass}", ->
                #   a 'Videos'
                li "#pictureTab.right#{inactiveClass}", ->
                  a 'Images'
              div class:'clear'
                
            div '#articleTabContent', ->
              for lang in Static_langs
                
                # 'Text block'
                div ".tabcontent.#{lang}", ->
                  # 'Copy data'
                  p '.clear.h15', ->
                    a class: 'right icon copy copyLang', rel: lang, title: @ion_lang.ionize_label_copy_to_other_languages
                  # 'title'
                  dl '.first', ->
                    dt ->
                      label for: "title_#{lang}", -> @ion_lang.ionize_label_title
                    dd ->
                      input "#title_#{lang}.inputtext.title", name: "title_#{lang}", type: 'text', value: @article_by_lang[ lang ].title or ''
                  
                  # 'Online'
                  if Static_langs.length  > 1
                    dl ->
                      dt ->
                        label for:"online_#{lang}", title:@ion_lang.ionize_help_article_content_online, -> @ion_lang.ionize_label_article_content_online
                      dd ->
                        input "#online_#{lang}.inputcheckbox", checked:("checked" if @article_by_lang[ lang ].online is 1), name:"online_#{lang}", type:"checkbox", value:"1"                  
                  else
                    input "#online_#{lang}", name: "online_#{lang}", type: 'hidden', value: '1'

                  # 'Text'
                  h3 ".toggler.toggler-#{lang}", ->@ion_lang.ionize_label_text
                  div ".element.element-#{lang}", ->
                    div ->                      
                      textarea "#content_#{lang}.tinyTextarea.w600.h260", name: "content_#{lang}", rel: lang, "#{@article_by_lang[ lang ].content or ''}"
                      p '.clear.h15', ->
                        button "#wysiwyg_#{lang}.light-button.left", type: 'button', onclick: "tinymce.execCommand(\'mceToggleEditor\',false,\'content_#{lang}\');return false;", 'toggle editor'

                  # 'Toggler : More : SEO, Online..'
                  h3 ".toggler.toggler-#{lang}", 'SEO'
                  div ".element.element-#{lang}", ->
                    # 'sub title'
                    dl ->
                      dt ->
                        label for: "subtitle_#{lang}", 'Subtitle'
                      dd ->
                        textarea "#subtitle_#{lang}.textarea.subtitleTiny h30", name: "subtitle_#{lang}", type: 'text', ->
                          text @article_by_lang[ lang ].subtitle or ''
                        #a class:"icon edit subtitle"
                    # 'URL'
                    dl '.mt15', ->
                      dt ->
                        label for: "url_#{lang}", 'URL'
                      dd ->
                        input "#url_#{lang}.inputtext", name: "url_#{lang}", type: 'text', value: @article_by_lang[ lang ].url or ''
                    # 'Meta Title : Browser window title'
                    dl '.mb20', ->
                      dt ->
                        label for: "meta_title_#{lang}", title: 'Title of the browser window', 'Window title'
                      dd ->
                        input "#meta_title_#{lang}.inputtext", name: "meta_title_#{lang}", type: 'text', value: ''
                  # '/element'
                  # 'extend fields goes here...'
                  # 'Summary'
                  h3 ".toggler.toggler-#{lang}", 'Summary'
                  div ".element.element-#{lang}", ->
                    div ->
                      textarea "#summary_#{lang}.smallTinyTextarea.w600 h100", name: "summary_#{lang}", rel: lang
                      p '.clear.h15 mb15', ->
                        button "#wysiwyg_summary_#{lang}.light-button.left", type: 'button', onclick: "tinymce.execCommand(\'mceToggleEditor\',false,\'summary_#{lang}\');return false;", 'toggle editor'


              # # 'Files'
              # div '.tabcontent', ->
              #   p '.h20', ->
              #     button '.right.light-button files', onclick: 'javascript:mediaManager.loadMediaList(\'file\');return false;', 'Reload media list'
              #     button '.left.light-button delete', onclick: 'javascript:mediaManager.detachMediaByType(\'file\');return false;', 'Unlink all files'
              #     #form '#fileup', name: 'fileupform', ->
              #     #  input '#fileupload', type:"file", name:"myfiles", 'multiple'
              #   ul '#fileContainer.sortable-container', ''
              # # 'Music'
              # div '.tabcontent', ->
              #   p '.h20', ->
              #     button '.right.light-button music', onclick: 'javascript:mediaManager.loadMediaList(\'music\');return false;', 'Reload media list'
              #     button '.left.light-button delete', onclick: 'javascript:mediaManager.detachMediaByType(\'music\');return false;', 'Unlink all music'
              #   ul '#musicContainer.sortable-container', ''
              # # 'Videos'
              # div '.tabcontent', ->
              #   p '.h20', ->
              #     button '.right.light-button video', onclick: 'javascript:mediaManager.loadMediaList(\'video\');return false;', 'Reload media list'
              #     button '.left.light-button delete', onclick: 'javascript:mediaManager.detachMediaByType(\'video\');return false;', 'Unlink all videos'
              #   dl '.first', ->
              #     dt ->
              #       label for: 'add_video', 'Add Video URL'
              #     dd ->
              #       input '#addVideo.inputtext.w300 left mr5', name: 'addVideo', type: 'text', value: ''
              #       button '#btnAddVideo.left.light-button plus', 'Add'
              #   ul '#videoContainer.sortable-container', ''
              # 'Pictures'
              div '.tabcontent', ->
                p '.h20', ->
                  # '<a class="fmButton right"><img src="http://192.168.1.162/themes/admin/images/icon_16_plus.png" /> Add Media</a>'
                  button '.right.light-button pictures', onclick: 'javascript:mediaManager.loadMediaList(\'picture\');return false;', 'Reload media list'
                  button '.left.light-button delete', onclick: 'javascript:mediaManager.detachMediaByType(\'picture\');return false;', 'Unlink all pictures'
                  button '.left.light-button refresh', onclick: 'javascript:mediaManager.initThumbsForParent();return false;', 'Init all thumbs'
                  form '#fileup.left', name: 'fileupform', ->
                    input '#fileupload.inputtext.w120 italic droppable empty nofocus', type: 'text', name:'myfiles', alt: 'drop images here...'
                    label title: 'Drag an article from the left tree by selecting its name.'
     
                div '#pictureContainer.sortable-container', ''
                p '.h20', ->                  
                  

      # 'File Manager Form
      # Mandatory for the filemanager'
      #form '#fileManagerForm', name: 'fileManagerForm', ->
      #  input type: 'hidden', name: 'hiddenFile'

      script ->
        """
        id_article = #{@article.id_article}
        langs = #{JSON.stringify( Static_langs)}        
        """

      script ->
        """
        pixlr.settings.target = '#{@pixlr_target}'
        pixlr.settings.method = 'get'
        pixlr.settings.locktarget = true
        pixlr.settings.locktype = true
        pixlr.settings.redirect = false
        """

      coffeescript ->
        #- console.log "in coffee script"

        j$ = jQuery.noConflict() 

        initFileUpload = ->
          j$("#fileupload").fileupload('destroy')
          
          j$('#fileupload').fileupload                        
            dataType: 'json'
            url: '/en/admin/media/add_file/article/'+id_article
            dropZone : j$('#fileupload')
            # Done doesn't seems to be called after upload
            done: (e, data) ->
              #j$.each data.result, (index, file) -> 
                #alert file.name + " done"               
              #  j$('<p/>').text(file.name).appendTo(document.body) 
              #
              # Refresh media list
              #
              mediaManager.loadMediaList('picture')         
            drop: (e,data) ->    
                #console.log data
                #j$.each data.files, (index, file) ->            
                #  alert file.fileName + " dropped "
                
                # Removing & restarting fileupload object to avoid weird behavior on next uploads
                # (else it's sending again previous dropped files)
                j$("#fileupload").fileupload('destroy')
                initFileUpload()        

        # Using ui.select jQuery widget for selects
        j$('document').ready ->                     
          initFileUpload()          

        j$(document).bind 'drop dragover', (e) ->
          e.preventDefault()
   

        # Options Accordion
        ION.initAccordion ".toggler-options", "div.element-options", true, "articleAccordion"
        ION.initAccordion ".toggler-en", "div.element-en", true, "articleAccordion-en"

        # Init help tips on label
        # see init-content.js
        ION.initLabelHelpLinks "#articleForm"

        # Panel toolbox
        # Initializing the panel toolbox is required
        ION.initToolbox "article_toolbox"

        # Article element in each of its parent context
        ION.initDroppable()

        # Calendars init
        ION.initDatepicker "%Y.%m.%d"
        
        # Add links on each parent page -- Buggy
        # TODO:check with Partikule what it is for ?
        #$$("#parent_list li.parent_page").each (item, idx) ->
        #    ION.addParentPageEvents item
        
        # Auto-generate Main title
        $$(".tabcontent .title").each (input, idx) ->
            input.addEvent "keyup", (e) ->
              $("main-title").set "text", @value
    
        # Auto-generate URL for new articles
        for lang in langs         
          ION.initCorrectUrl "title_#{lang}", "url_#{lang}" if $("id_article").value is '' or $("url_#{lang}").value is ''

        # Copy content from a language to another
        if $("copy_lang")
          $("copy_lang").addEvent "click", (e) ->
            e.stop()
            url = admin_url + "lang/copy_lang_content"
            data =
              case: "article"
              id_article: $("id_article").value
              rel: $("rel").value
              from: $("lang_copy_from").value
              to: $("lang_copy_to").value

            ION.sendData url, data

        # Article ordering :
        # - Show / hide article list depending on Ordering select
        # - Update the article select list after parent change
        if $("id_page")
          $("ordering_select").addEvent "change", (e) ->
            e.stop()
            el = e.target
            if el.value is "after"
              $("ordering_after").setStyle "display", "block"
            else
              $("ordering_after").setStyle "display", "none"


        # Copy Lang data to other languages dynamically
        ION.initCopyLang ".copyLang", Array("title", "subtitle", "url", "content", "meta_title")
        nbCategories = ($("categories").getElements("option")).length
        $$("#categories select").setStyles height: (nbCategories * 15) + "px"  if nbCategories > 5

        # Show current tabs
        articleTab = new TabSwapper(
          tabsContainer: "articleTab"
          sectionsContainer: "articleTabContent"
          selectedClass: "selected"
          deselectedClass: ""
          tabs: "li"
          clickers: "li a"
          sections: "div.tabcontent"
          cookieName: "articleTab"
        )

        new TabSwapper(
          tabsContainer: "permanentUrlTab"
          sectionsContainer: "permanentUrlTabContent"
          selectedClass: "selected"
          deselectedClass: ""
          tabs: "li"
          clickers: "li a"
          sections: "div.tabcontent"
          cookieName: "permanentUrlTab"
        )

        # TinyEditors
        # Must be called after tabs init.
        ION.initTinyEditors ".tab_article", "#articleTabContent .tinyTextarea"
        ION.initTinyEditors ".tab_article", "#articleTabContent .smallTinyTextarea", "small",  height: 80

        # Indexed XHR update
        # Categories XHR update
        $("indexed").addEvent "click", (e) ->
          value = (if (@checked) then "1" else "0")
          ION.JSON "article/update_field",
            field: "indexed"
            value: value
            id_article: $("id_article").value

        # Categories
        categoriesSelect = $("categories").getFirst("select")
        categoriesSelect.addEvent "change", (e) ->
          ids = new Array()
          sel = this
          i = 0

          while i < sel.options.length
            ids.push sel.options[i].value  if sel.options[i].selected
            i++
          ION.JSON "article\/\/update_categories",
            categories: ids
            id_article: $("id_article").value


        # # Link to page or article or what else...
        # if $("linkContainer")
        #   ION.HTML admin_url + "article/get_link",
        #     id_page: "4"
        #     id_article: "9"
        #   ,
        #     update: "linkContainer"


        # Get Content Elements Tabs & Elements
        $("desktop").store "tabSwapper", articleTab
        
        #
        # TODO: Uncomment this once elements are ready in nodize
        #
        #ION.getContentElements "article", id_article

        

        # # Add Video button
        # $("btnAddVideo").addEvent "click", ->
        #   unless $("addVideo").value is ""
        #     ION.JSON "media/add_external_media",
        #       type: "video"
        #       parent: "article"
        #       id_parent: @article.id_article
        #       path: $("addVideo").value
        #   false
        
        # Media Manager & tabs events
        #
        # TODO: Buggy, check what it is for
        #
        mediaManager.initParent "article", id_article
       
        #mediaManager.loadMediaList "file"
        #mediaManager.loadMediaList "music"
        mediaManager.loadMediaList "picture"        
        #mediaManager.loadMediaList "video"

