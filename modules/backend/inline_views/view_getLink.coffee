@include = ->

  #
  # Pages & Articles, display links
  #
  @view backend_getLink: ->
    if @link 
      dl '.small.dropArticleAsLink.dropPageAsLink', ->
        dt ->
          label title: @ion_lang.ionize_help_page_link, -> @ion_lang.ionize_label_linkto
          br()
        dd ->
          ul '#linkList.sortable-container.mr20', ->
            li '.sortme', ->
              a class:'left link-img page'
              # 'Unlink icon'
              a class:'icon unlink right'
              # 'Title'
              a '#link_title.pl5.pr10', style: 'overflow:hidden;height:16px;display:block;', title: @page.link, -> @page.link

        
        script ->
          """
          var parent_type = "#{@parent}"; 
          var id_page = "#{@page.id_page}";
          var link_id = "#{@page.link_id}";
          var link_type = "#{@page.link_type}";
          var parent_id = "#{@page.id}";
          """

        coffeescript ->
          $$("#linkList li .unlink").each (item) ->
            console.log "each ", id_page
            ION.initRequestEvent item, parent_type+"\/\/remove_link",
              id_page: id_page
            ,
              update: "linkContainer"


          if link_type is "external"
            $("link_title").addEvent "click", (e) ->
              window.open @get("text")
          else
            $("link_title").addEvent "click", (e) ->
              MUI.Content.update
                element: $(ION.mainpanel)
                url: "admin\/page\/edit\/"+link_id

    else    
      dl '.small.dropArticleAsLink.dropPageAsLink', ->
        tag 'dt', ->
          label for: 'link', title: @ion_lang.ionize_help_page_link, -> @ion_lang.ionize_label_link
          br()
                  
        tag 'dd', ->
          textarea '#link.inputtext.w140.h40.droppable', alt: @ion_lang.ionize_label_drop_link_here
          br()
          a id: 'add_link', -> @ion_lang.ionize_label_add_link
        

      script ->
        """
        var parent = "#{@parent}"; 
        """

      coffeescript ->
        ION.initDroppable()
        
        $("add_link").addEvent "click", ->
          ION.JSON parent + "\/\/add_link",
            receiver_rel: $("rel").value
            link_type: "external"
            url: $("link").value

      
