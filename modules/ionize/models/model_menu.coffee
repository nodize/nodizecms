# Menu model
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
	sequelize.define( "menu", {
		id_menu     : DataTypes.INTEGER
		name        : DataTypes.STRING
		title 		  : DataTypes.STRING
		ordering 	  : DataTypes.INTEGER
	})