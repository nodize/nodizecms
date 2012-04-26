# Article lang model
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
  sequelize.define( "article_lang",
  {
    id_article        : DataTypes.INTEGER
    lang              : DataTypes.STRING
    url               : DataTypes.TEXT
    title             : DataTypes.STRING
    subtitle          : DataTypes.STRING
    meta_title        : DataTypes.STRING
    summary           : DataTypes.TEXT
    content           : DataTypes.TEXT
    meta_keywords     : DataTypes.STRING
    meta_description  : DataTypes.TEXT
    online            : DataTypes.STRING   
  },
  {
    instanceMethods: {

      #
      # Define default values on article creation
      #
      createBlank : ->
        @title = ""
        @content = ""
        @subtitle = ""
        @id_article = null        
    }
  }
  )