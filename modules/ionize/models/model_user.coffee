# User model
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
  sequelize.define( "users", {
    id_user     : { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true }
    id_group    : DataTypes.INTEGER
    join_date   : DataTypes.DATE
    last_visit  : DataTypes.DATE
    username    : DataTypes.STRING
    screen_name : DataTypes.STRING
    password    : DataTypes.STRING
    email       : DataTypes.STRING
    salt        : DataTypes.STRING    
  })