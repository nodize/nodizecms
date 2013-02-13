#
# Nodize - authorization helpers
#
# Nodize CMS
# https://github.com/nodize/nodizecms
#
# Copyright 2012, Hypee
# http://hypee.com
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
  
  #*****
  #* Displaying current user name if logged in
  #**  
  @helpers['ion_username'] = (args...) ->    
    username = @req.session.user or ""    
    

  #*****
  #* Displaying current usergroup name if logged in
  #**  
  @helpers['ion_usergroup_name'] = (args...) ->
    usergroup = @req.session.usergroup_name or ""
    
  #*****
  #* Displaying current usergroup level if logged in
  #**  
  @helpers['ion_usergroup_level'] = (args...) ->
    userlevel = @req.session.usergroup_level or ""
  


