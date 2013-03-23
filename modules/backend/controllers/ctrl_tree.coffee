# Tree controller
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  
  #
  # CONTENT TREE (Menus, pages, articles)
  #
  @get "/:lang/admin/tree" : (req, res) =>
    Menu.findAll({order:'ordering'})
      .on 'success', (menus) ->
        res.render "backend_tree",
          hardcode  : @helpers
          lang      : req.params.lang      
          ion_lang  : ion_lang[ req.params.lang ]
          menus     : menus
          layout    : no

      .on 'failure', (err) ->
        console.log 'database error ', err
  
  #
  # PAGES TREE
  #
    # Retrieval of one leaf of the page/article tree
  @post "/:lang/admin/tree/get" : (req, res) =>
    current_lang = if req.params.lang then req.params.lang else Static_lang_default
    # Retrieving POST datas
    values = req.body

    pageResultArray = []
    pageDone = false
    articleResultArray = []
    articleDone = false

    #****************************************
    #* PAGES
    #****
    DB.query("SELECT *, page.online as online
          FROM page, page_lang
          WHERE
            page_lang.id_page = page.id_page AND
            page_lang.lang = '#{current_lang}' AND
            id_parent = #{values.id_parent} AND
            id_menu = #{values.id_menu}
          ORDER BY page.ordering", Page)

      .on 'success', (results) =>
        for page in results
          pageArray = {
            'id'        : page.id
            'id_page'   : page.id_page
            'id_parent' : page.id_parent
            'id_menu'   : page.id_menu
            'id_subnav' : page.id_subnav
            'name'      : page.name
            'ordering'  : page.ordering
            'level'     : page.level
            'online'    : page.online
            'home'      : page.home
            'author'    : page.author
            'appears'   : page.appears
            'title'     : page.title
            'url'       : page.url
          }
          pageResultArray.push( pageArray )

        pageDone = true

        if pageDone and articleDone
          articleDone = false
          pageDone = false
          res.send( {"pages":pageResultArray, "articles":[] } )

      .on 'failure', (err) ->
        console.log( "error" + err )

    #****************************************
    #* ARTICLES
    #****
    DB.query("SELECT 
                article.*, article_lang.title, 
                page_article.*, 
                article_type.type_flag
              FROM
                page, article_lang, article, page_article
              LEFT JOIN
                article_type ON page_article.id_type = article_type.id_type
              WHERE
                page_article.id_page = page.id_page AND
                page_article.id_article = article.id_article AND
                article_lang.id_article = article.id_article AND
                article_lang.lang = '#{current_lang}' AND

                page_article.id_page = #{values.id_parent} AND
                page.id_menu = #{values.id_menu}
              ORDER BY
                page_article.ordering", Article)

      .on 'success', (results) =>
        for article in results
          articleArray = 
            id_article  : article.id_article
            id_page     : article.id_page
            online      : article.online
            name        : article.name
            indexed     : article.indexed
            id_category : article.id_category
            flag        : article.type_flag
            type_flag   : article.type_flag
            has_url     : article.has_url
            title       : article.title
            view        : article.view
            ordering    : article.ordering
            main_parent : article.main_parent
            link_type   : ""
            link_id     : ""
            link        : ""

          
          articleResultArray.push( articleArray )         

        articleDone = true

        if pageDone and articleDone
          articleDone = false
          pageDone = false          
          res.send( {"pages":pageResultArray, "articles":articleResultArray } )

      .on 'failure', (err) ->
        console.log( "error" + err )


    

      

