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
      # Move article
      #
      # @param data.id_article
      # @param data.id_page
      # @param data.id_page_origin
      # @param data.copy 
      moveArticle : (data, callback) ->
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
        

        
