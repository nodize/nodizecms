# Category model
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Original database model :
# IonizeCMS (http://www.ionizecms.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
module.exports = (sequelize, DataTypes) ->
  sequelize.define( "category", {
    id_category :  { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true }
    name        : DataTypes.STRING
    ordering    : DataTypes.INTEGER
  })