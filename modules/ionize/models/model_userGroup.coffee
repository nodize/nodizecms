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
	sequelize.define "user_groups", 
		id_group    : DataTypes.INTEGER
		slug        : DataTypes.STRING
		group_name  : DataTypes.STRING
		level       : DataTypes.INTEGER
		description : DataTypes.TEXT
	,
    classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'user_groups'

        migrations = [
          version : 1
          code : ->
            "First version"
#        ,
#          version : 2
#          code : ->
#            migrator.addColumn( 'newField', DataTypes.STRING )
#            migrator.removeColumn( 'field' )
        ]

        migrator = sequelize.getMigrator( tableName )
        migrator.doMigrations( tableName, migrations )