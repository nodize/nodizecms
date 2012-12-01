# Article type model
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
  sequelize.define "article_type", 
    id_type     :  { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true }
    type        : DataTypes.STRING
    type_flag   : DataTypes.INTEGER
    description : DataTypes.TEXT
    ordering    : DataTypes.INTEGER
  ,
  	classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'article_type'

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