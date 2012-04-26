@include = ->
  #
  # Displaying LOGIN FORM
  #
  @view backend_login: ->
    doctype 5
    html xmlns: 'http://www.w3.org/1999/xhtml', ->
      head ->
        meta 'http-equiv': 'Content-Type', content: 'text/html; charset=UTF-8'
        title()
        meta 'http-equiv': 'imagetoolbar', content: 'no'
        link rel: 'shortcut icon', href: '/backend/images/favicon.ico', type: 'image/x-icon'
        script type: 'text/javascript', src: '/backend/javascript/mootools-core-1.3.2-full-nocompat.js'
        script type: 'text/javascript', src: '/backend/javascript/mootools-more-1.3.2.1-yc.js'
        link rel: 'stylesheet', href: '/backend/css/login.css', type: 'text/css'
        link rel: 'stylesheet', href: '/backend/css/form.css', type: 'text/css'
      body ->
        # 'Content'
        div '#content.content', onKeyPress: 'javascript:doSubmit(event);', ->
          div '#loginWindow.clearfix', ->
            div '#version', '0.1.0 - Nodize CMS - MIT licence'
            form '#login.login', action: "/#{@lang}/admin/login", method: 'post', 'accept-charset': 'utf-8', ->
              div ->
                label for: 'username', -> @ion_lang.ionize_login_name
                input '#username.inputtext', type: 'text', name: 'username', value: ''
              div ->
                label for: 'password', -> @ion_lang.ionize_login_password
                input '#password.inputtext', type: 'password', name: 'password', value: ''
              div '.action', ->
                comment '<input type="checkbox" name="remember_me" value="1"  /> Souvenez-vous'
                button '.submit', type: 'submit', name: 'send', -> @ion_lang.ionize_login
        # 'Content : end'

      coffeescript ->
        doSubmit = (e) ->
          code = undefined
          e = window.event  unless e
          
          if e.keyCode
            code = e.keyCode
          else code = e.which  if e.which
          character = String.fromCharCode(code)
          
          if code is 13
            ojbNom = document.getElementById("username")
            objPass = document.getElementById("password")
            if ojbNom.value isnt "" and objPass.value isnt ""
              formObj = document.getElementById("login")
              formObj.submit()
        #
        # Reload top window if #desktop object exists
        # Prevents from having a login window in a panel
        #
        MUI = undefined
        if $("desktop")
          $("desktop").setStyle "display", "none"
          window.top.location.reload true
