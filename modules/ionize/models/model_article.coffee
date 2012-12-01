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
          
        

        

        
