Nodizecms
=========

A Node.js CMS written in CoffeeScript, with a user friendly backend

![Screenshot](https://github.com/nodize/nodizecms/raw/master/docs/screenshots/media_manager.jpg)

Status
------

NodizeCMS is still under heavy development, there's a ton of unimplemented features and even more bugs.

It's not ready for production yet, but you still can start to play with it and have plenty of fun !

Application stack
-----------------
nodejs >0.6.x

express

zappajs

sequelize

mysql

redis (optional)

Installation 
------------

Installation has been tested under Linux, MacOS and Windows.

Git, MySQL, Node.js and NPM have to be installed

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
```

Create a MySQL database and modify the file "/themes/pageone/settings/database.json"
```
mysqladmin create pageone
```

Start the server
```
coffee app.coffee
```

When your database is empty, a default "admin" user will be created with a random password at server startup :
```
._   _           _ _         
| \ | |         | (_)        
|  \| | ___   __| |_ _______ 
| . ` |/ _ \ / _` | |_  / _ \
| |\  | (_) | (_| | |/ /  __/
\_| \_/\___/ \__,_|_/___\___|

listening on port 3000
SuperAdmin group created
Default user created, login = admin, password = 45A90 <----------- YOUR PASSWORD
Default lang created
Default menu created
```

Now you can access to the admistration module, open you browser on "http://127.0.0.1:3000/admin" (replace 127.0.0.1 by your server IP/URL if it's not running on the localhost).

If you're still there and that everything went fine, you should have a nice but empty backend.

Let's load some data :
(replace "pageone" by your database name)
```
mysql pageone < themes/pageone/sql/pages.sql
```
or (if you have some access rights defined in MySQL) :
```
mysql pageone -u root -p < themes/pageone/sql/pages.sql
```

Now refresh your browser ! Do you see pages & articles ? Great ! 

Open a new browser window and enter this URL : "http://127.0.0.1:3000", if you are lucky, you're just looking at a dynamic webpage powered by Node.js & NodizeCMS !

License
-------
(The MIT License)

Copyright (c) 2012 Hypee

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
