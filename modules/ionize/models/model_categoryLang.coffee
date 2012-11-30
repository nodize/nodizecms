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
  sequelize.define "category_lang",
  
    id_category       : DataTypes.INTEGER
    lang              : DataTypes.STRING
    title             : DataTypes.STRING
    subtitle          : DataTypes.STRING
    description       : DataTypes.TEXT
  ,
    classMethods:
      #
      # Migration management
      #
      migrate : ->

        tableName = 'category_lang'

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