# Article category model
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
  sequelize.define( "category_lang",
  {
    id_category       : DataTypes.INTEGER
    lang              : DataTypes.STRING
    title             : DataTypes.STRING
    subtitle          : DataTypes.STRING
    description       : DataTypes.TEXT
  }
  )