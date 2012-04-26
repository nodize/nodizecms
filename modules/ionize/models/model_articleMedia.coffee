# Article media model
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
module.exports = (sequelize, DataTypes) ->
  sequelize.define( "article_media", {
    id_article  : DataTypes.INTEGER
    id_media    : DataTypes.INTEGER
    ordering    : DataTypes.INTEGER
    url         : DataTypes.STRING
  })