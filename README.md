nodizecms
=========

A Node.js CMS written in CoffeeScript, with a user friendly backend

status
------

NodizeCMS is still under heavy development, there's a ton of unimplemented features and even more bugs.

It's not ready for production yet, but you still can start to play with it and have plenty of fun !

application stack
-----------------
nodejs >0.6.x

express

zappajs

sequelize

mysql

installation (not tested yet)
------------

MySQL, Node.js and NPM have to be installed

Make a global install of CoffeeScript
```
npm install -g coffee-script
```

Retrieve NodizeCMS
```
git clone git://github.com/nodize/nodizecms.git
```

Install dependencies
```
cd nodizecms

npm install
cake setup
```

Create a MySQL database and modify the file "/themes/pageone/settings/database.json"
```
mysqladmin create pageone
```

Start the server
```
coffee app.coffee
```
