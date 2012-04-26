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
  sequelize.define( "user_groups", {
    id_group    : DataTypes.INTEGER
    slug        : DataTypes.STRING
    group_name  : DataTypes.STRING
    level       : DataTypes.INTEGER
    description : DataTypes.TEXT
  })