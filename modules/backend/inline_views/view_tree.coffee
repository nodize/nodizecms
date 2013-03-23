@include = ->
  
  # 
  # Building menus/pages/articles tree
  #
  @view backend_tree: ->
    if @menus
      for menu in @menus
        h3 '.treetitle', rel:menu.id_menu, ->
          span '.action', ->
            a title:'', class:'icon edit right ml5'
            a title:'#ionize_help_add_page_to_menu', class:'icon right ml5 add_page', rel:menu.id_menu
          text menu.title
        div id:"#{menu.name}Tree", class:'.treeContainer'
           
      text '<script type="text/javascript">'
      for menu in @menus
        text "var  #{menu.name}Tree = new ION.TreeXhr('#{menu.name}Tree', #{menu.id_menu});"
      text '</script>'
    
    coffeescript ->
      $$('.treetitle').each (el)->
        ION.initTreeTitle(el)
        
    