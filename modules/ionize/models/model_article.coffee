# Article model
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Original database model :
# IonizeCMS (http://www.ionizecms.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
module.exports = (sequelize, DataTypes)->
  sequelize.define "article",
    id_article        :  { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true }
    name              : DataTypes.STRING
    created           : DataTypes.DATE
    updated           : DataTypes.DATE
    publish_on        : DataTypes.DATE
    publish_off       : DataTypes.DATE
    logical_date      : DataTypes.DATE   
  ,
    instanceMethods: 

      #
      # Define default values on article creation
      #
      createBlank : ->
        @id_article = null
        @created = new Date()
        @updated = new Date()
        @publish_on = ''
        @publish_off = ''
        @logical_date = ''
        @content = ''



  
    classMethods:

      #
      # Migration management
      #
      migrate : ->

        tableName = 'article'

        migrations = [
          version : 1
          code : ->
            "First version"
#        ,
#          version : 2
#          code : ->
#            migrator.addColumn( 'newField', DataTypes.STRING )
        ]

        migrator = sequelize.getMigrator( tableName )
        migrator.doMigrations( tableName, migrations )

      #
      # Move article to another page
      #
      # @param data.id_article
      # @param data.id_page
      # @param data.id_page_origin
      # @param data.copy 
      move : (data, callback) ->
        #
        # Find record
        #        
        getExistingRecord = ->
          Page_article.find({where:{id_article : data.id_article, id_page:data.id_page_origin}})
            .on 'success', (record) ->                            
              if record
                record.id_page = data.id_page
                #
                # Saving the record & callback
                #
                record.save()
                  .on 'success', (record) ->
                    Article.find({where:{id_article:record.id_article}})
                      .on 'success', (article) ->
                        Page_article.find({where:{id_page:data.id_page, id_article:article.id_article}})
                          .on 'success', (page_article) ->
                            callback(null, article, page_article )    
                          .on 'failure', (err) ->
                            callback(err, null, null)
                        
                      .on 'failure', (err) ->
                        callback(err, null, null)

                  .on 'failure', (err) ->
                    callback(err, null, null)                
              else
                callback( "Record not found", null, null )    

            .on 'failure', (err) ->
              callback( err, null, null )
        
        getExistingRecord()


      #
      # Creating a link in an article
      #
      # @param data.link_rel = destination
      # @param data.receiver_rel = Page_article we are adding the link to
      # @param data.link_type = "page" | "article" | "external"  
      addLink : (data, callback) ->        
        
        #
        # Extracting info needed to update Page_article table
        #
        receiver = data.receiver_rel.split(".")
        receiver.id_page = receiver[0]
        receiver.id_article = receiver[1]
        
        #
        # Retrieve the page we link to
        #
        findDestinationPage = =>
          if data.link_type is 'page'
            @find({where:{id_page:data.link_rel}})
              .on 'success', (page) =>
                createLink( page )
              
              .on 'failure', (err) ->
                callback( err, null )
          # External link
          else 
            createLink( null )

        createLink = (pageLink) =>
          Page_article.find({where:{id_page:receiver.id_page, id_article:receiver.id_article}})
            .on 'success', (page_article) =>
              page_article.link_type = data.link_type
              
              #
              # If the link is an internal page
              #
              if page_article and data.link_type is "page"                
                page_article.link = pageLink.name
                page_article.link_id = pageLink.id_page
              #
              # if the link is external
              #
              else if data.link_type is "external"
                page_article.link = data.url                

              page_article.save()
                .on 'success', (page) =>
                  callback( null, page_article )
                .on 'failure', (err) ->
                  callback( err, null )
                      
          .on 'failure', (err) ->
            callback( err, null )

        #
        # Start process
        #        
        findDestinationPage()

      #
      # Removing a link for an article
      #
      # @param data.rel = page
      removeLink : (data, callback) ->                
        console.log data

        findPageArticle = =>
          Page_article.find({where:{id:data.id_page}})
            .on 'success', (page_article) =>
              deleteLink( page_article )
            
            .on 'failure', (err) ->
              callback( err, null )

        deleteLink = (page_article) =>
          page_article.link_type = null
          page_article.link = null
          page_article.link_id = null

          page_article.save()
            .on 'success', (page_article) =>
              callback( null, page_article )
            .on 'failure', (err) ->
              callback( err, null )
                      
          
        #
        # Start process
        #
        findPageArticle()
    

      #
      # Link article to another page (and keep existing link)
      #
      # @param data.id_article
      # @param data.id_page
      # @param data.id_page_origin
      # @param data.copy 
      link : (data, callback) ->
        page_article = Page_article.build()
        page_article.id_article = data.id_article
        page_article.id_page = data.id_page

        page_article.save()
          .on 'success', (record) ->
            Article.find({where:{id_article:record.id_article}})
              .on 'success', (article) ->
                Page_article.find({where:{id_page:data.id_page, id_article:article.id_article}})
                  .on 'success', (page_article) ->
                    callback(null, article, page_article )    
                  .on 'failure', (err) ->
                    callback(err, null, null)                
              .on 'failure', (err) ->
                callback(err, null, null)

          .on 'failure', (err) ->
            callback(err, null, null)    


      #
      # Unlink article from a page
      #      
      unlink : (data, callback) ->            
        Page_article.find({where:{id_article : data.id_article, id_page:data.id_page}})
          .on 'success', (record) ->                            
            if record
              record.id_page = data.id_page
              #
              # Saving the record & callback
              #
              record.destroy()
                .on 'success', (record) ->
                  callback(null, data.id_page, data.id_article )    
                .on 'failure', (err) ->
                  callback(err, null, null)                
            else
              callback( "Record not found", null, null )    

          .on 'failure', (err) ->
            callback( err, null, null )

      #
      # Retrieves an article
      #
      get : (data, callback) ->
        #
        # Retrieve article
        #
        findArticle = (data) ->
          Article.find({where:{id_article:data.id_article}})
            .on 'success', (article) ->
              findArticleLang( article )
            .on 'failure', (err) ->
              console.log 'database error ', err
              callback( err, null )


        #
        # Retrieve langs
        #
        findArticleLang = (article) ->
          # Search article & render page
          Article_lang.findAll( {where: {id_article:data.id_article, lang:data.lang} } )
            .on 'success', (article_langs) ->
              if article_langs.length > 0
                callback( null, article_langs[0] )



        if data.id_article
          findArticle(data)
        else
          err = "Article id not provided " + data.id_article
          callback( err, null )


          
        

        

        
