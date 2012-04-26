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
    updated           : DataTypes.DATE   
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
