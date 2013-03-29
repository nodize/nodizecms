path = require("path")
fs = require("fs")
exists = fs.existsSync or path.existsSync
resolve = path.resolve
dirname = path.dirname
extname = path.extname
basename = path.basename
registeredExts = []

zappa_fs = null

###
Express 3.x Layout & Partial support.

The beloved feature from Express 2.x is back as a middleware.

Example:

var express = require('express')
, partials = require('express-partials')
, app = express();
app.use(partials());
// three ways to register a template engine:
partials.register('coffee','coffeecup');
partials.register('coffee',require('coffeecup'));
partials.register('coffee',require('coffeecup').render);
app.get('/',function(req,res,next){
res.render('index.ejs') // renders layout.ejs with index.ejs as `body`.
})

Options:

none
###



###
Allow to register a specific rendering
function for a given extension.
(Similar to Express 2.x register() function.)

The second argument might be:
a template module's name
a module with a `render` method
a synchronous `render` method
###
register = (ext, render) ->
  ext = "." + ext  unless ext[0] is "."
  render = require(render)  if typeof render is "string"
  unless typeof render.render is "undefined"
    register[ext] = render.render
  else
    register[ext] = render

  registeredExts.push( ext ) unless registeredExts.indexOf( ext )>-1



###
Automatically assign a render() function
from a module of the same name if none
has been registered.
###
renderer = (ext) ->
  ext = "." + ext  if ext[0] isnt "."
  (if register[ext]? then register[ext] else register[ext] = require(ext.slice(1)).render)



###
Memory cache for resolved object names.
###
cache = {}

###
Resolve partial object name from the view path.

Examples:

"user.ejs" becomes "user"
"forum thread.ejs" becomes "forumThread"
"forum/thread/post.ejs" becomes "post"
"blog-post.ejs" becomes "blogPost"

@return {String}
@api private
###
resolveObjectName = (view) ->
  cache[view] or (cache[view] = view.split("/").slice(-1)[0].split(".")[0].replace(/^_/, "").replace(/[^a-zA-Z0-9\_\- ]+/g, " ").split(RegExp(" +")).map((word, i) ->
    (if i then word[0].toUpperCase() + word.substr(1) else word)
  ).join(""))


###
Lookup:

- partial `_<name>`
- any `<name>/index`
- non-layout `../<name>/index`
- any `<root>/<name>`
- partial `<root>/_<name>`

@param {View} view
@return {String}
@api private
###
lookup_oneRoot = (root, view, ext) ->

  name = resolveObjectName(view)


  # Try _ prefix ex: ./views/_<name>.jade
  # taking precedence over the direct path
#  view = resolve(root, "_" + name + ext)
#  return view  if exists(view)

  # Try index ex: ./views/user/index.jade
  #view = resolve(root, name, "index" + ext)
  #return view  if exists(view)

  # Try ../<name>/index ex: ../user/index.jade
  # when calling partial('user') within the same dir
  #view = resolve(root, "..", name, "index" + ext)
  #return view  if exists(view)


  # Try root ex: <root>/user.jade
  view = resolve(root, name + ext)
  #console.log "partials |*** found", view if exists(view)
  return view  if exists(view)

  #console.log "partials | not found", view

  null

lookup = (root, view, exts) ->

  #
  # Supporting multiple view folders patch
  #
  if (root instanceof Array)
    for currentRoot in root
      for ext in exts
        _view = lookup_oneRoot( currentRoot, view, ext )
        return _view if _view

    console.log "partials | view '#{view}' not found"
    return null

  #
  # Single view folder
  #
  for ext in exts
    return lookup_oneRoot( root, view, ext )

partial = (view, options) ->
  root = @res.app.get("views") or process.cwd() + "/views"

  ext = []
  ext.push( extname(view) or "." + (@res.app.get("view engine") or "coffee") )
  for extIndex in registeredExts
    ext.push extIndex unless ext.indexOf(extIndex)>-1


  # Search in Zappa's inline views
  if zappa_fs?[ view ]
    viewExt = extname(view) or @res.app.get("view engine") or "coffee"
    result = renderer(viewExt)(zappa_fs[ view ], @)
  else
    file = lookup(root, view, ext)
    if file
      source = fs.readFileSync(file, "utf8")

      result = renderer(extname(file))(source, @)
    else
      result = "Partial view '#{view}' not found"

  return result

#
# Defining context, used to access to Zappa inline views
#
setInlineViews = (_inlineViews) ->
  zappa_fs = _inlineViews




module.exports.partial = partial
module.exports.register = register
module.exports.setInlineViews = setInlineViews