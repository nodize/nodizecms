# Media model
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
  sequelize.define "media", 
    id_media    :  { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true }
    type        : DataTypes.STRING
    file_name   : DataTypes.STRING
    path        : DataTypes.STRING
    base_path   : DataTypes.STRING
    copyright   : DataTypes.STRING
    container   : DataTypes.STRING
    date        : DataTypes.DATE
    link        : DataTypes.STRING
  ,
    classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'media'

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