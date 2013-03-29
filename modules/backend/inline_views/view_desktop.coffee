@include = ->
  @view backend_desktop: ->
    doctype 5
    html xmlns: 'http://www.w3.org/1999/xhtml', ->
      head ->
        meta 'http-equiv': 'Content-Type', content: 'text/html; charset=UTF-8'
        title 'Administration'
        meta 'http-equiv': 'imagetoolbar', content: 'no'
        link rel: 'shortcut icon', href: @assetsPath + '/images/favicon.ico', type: 'image/x-icon'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/mochaui/Themes/ionize/css/core.css'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/mochaui/Themes/ionize/css/menu.css'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/mochaui/Themes/ionize/css/desktop.css'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/mochaui/Themes/ionize/css/window.css'
        link rel: 'stylesheet', href: @assetsPath + '/css/form.css', type: 'text/css'
        link rel: 'stylesheet', href: @assetsPath + '/css/content.css', type: 'text/css'
        link rel: 'stylesheet', href: @assetsPath + '/css/tree.css', type: 'text/css'

        # INTERNET EXPLORER SPECIFIC STYLE SHEETS & HACKS
        ie 'IE 8', ->
          link rel: 'stylesheet', href: @assetsPath + '/css/ie8.css', type: 'text/css'
        ie 'IE 7', ->
          link rel: 'stylesheet', href: @assetsPath + '/css/ie7.css', type: 'text/css'
        ie 'IE 9', ->
          link rel: 'stylesheet', href: @assetsPath + '/css/ie9.css', type: 'text/css'

        ie 'lt IE 9', ->
          script type: 'text/javascript', src: @assetsPath + '/javascript/excanvas_r43_compressed.js'

        # 'Mootools 1.3.1'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-core-1.3.2-full-nocompat.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-more-1.3.2.1-yc.js'

        # 'Drag Clone'
        script type: 'text/javascript', src: @assetsPath + '/javascript/drag.clone.js'
        # 'Date Picker'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-datepicker/datepicker.js'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/mootools-datepicker/datepicker_dashboard/datepicker_dashboard.css'
        # 'Tab Swapper'
        script type: 'text/javascript', src: @assetsPath + '/javascript/TabSwapper.js'
        # 'Sortable Table'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/SortableTable/SortableTable.css'
        script type: 'text/javascript', src: @assetsPath + '/javascript/SortableTable/SortableTable.js'
        # 'CwCrop'
        script type: 'text/javascript', src: @assetsPath + '/javascript/cwcrop/ysr-crop.js'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/cwcrop/ysr-crop.css'
        # 'swfObject'
        script type: 'text/javascript', src: @assetsPath + '/javascript/swfobject.js'
        # 'CodeMirror'
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/codemirror/css/codemirror.css'
        script type: 'text/javascript', src: @assetsPath + '/javascript/codemirror/js/codemirror.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/codemirror/codemirror.views.js'
        # 'Base URL & languages translations available for javascript'

        # jQuery

        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/jquery/css/themes/flick/jquery-ui-1.8.17.custom.css'



        script type: 'text/javascript', src: @assetsPath + '/javascript/jquery/jquery.min.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/jquery/jquery-ui-1.8.17.custom.min.js'

        # jQuery custom selects
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath + '/javascript/jquery/css/ui.selectmenu.css'
        script type: 'text/javascript', src: @assetsPath + '/javascript/jquery/ui.selectmenu.js'

        # jQuery upload plugins
        script type: 'text/javascript', src: @assetsPath + '/javascript/jquery/jquery.iframe-transport.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/jquery/jquery.fileupload.js'

        # jQuery knob plugin
        script type: 'text/javascript', src: @assetsPath + '/javascript/jquery-knob/jquery.knob.js'


        # Pixlr API (http://pixlr.com/develop/api)
        script src: @assetsPath + '/javascript/pixlr/pixlr.js'

        # Zappa.js
        script src: '/socket.io/socket.io.js'
        script src: '/zappa/zappa.js'
        #script src: '/socket.js'
        script src: '/backendEvents.js'
        #script src: '/backend_dashboard.js'

        # "Bootstrap framework"
        link rel: "stylesheet", href: "/backend/bootstrap/css/bootstrap-nodize.css"
        #link rel: "stylesheet", href: "backend/bootstrap/css/bootstrap-responsive.min.css"
        # "Blue theme"
        link "#link_theme", rel: "stylesheet", href: "/backend/css/blue.css"
        # "main bootstrap js"
        script src: "/backend/bootstrap/js/bootstrap.min.js"


        #
        # Defining admin language & base URL
        # & building translations for Javascript localization
        #
        text """
             <script type='text/javascript'>
             var admin_url = '/#{@lang}/admin/';
             var theme_url = '#{@assetsPath}/';

             Lang = new Hash(
             {
             """
        for translation of @ion_lang
          text '"' + translation + '":"' + @ion_lang[ translation ].replace('\"', '\\\"') + '",' if translation isnt '#'
        text """
             "current": "en"
             }
             )
             </script>
             """

        coffeescript ->
          j$ = jQuery.noConflict()

          # Global base_url value.
          # Used by mocha-init and should be used by any javascript class or method which needs to access to resources
          @base_url = '/'
          @site_theme_url = '/'
          @date_format = '%Y.%m.%d'

          #
          # Show help tips.
          # Used by mocha init-content
          #
          @show_help_tips = '1'

          # Gets all the Ionize lang items and put them into a Lang hash object
          # Not used anymore, keep for later reference

          @LangX = new Hash({
                            'connect_login_failed': 'The login information you provided could not be authentificated. Either the username or the password you entered are wrong. Please try again.'
                            'current': 'en',
                            'first': 'en',
                            'default': 'en',
                            'languages': new Array('en')})

        # 'Mocha UI'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Core/core.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Core/create.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Core/require.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Core/canvas.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Core/content.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Core/persist.js'
        # 'Normal load'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Controls/taskbar/taskbar.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Controls/toolbar/toolbar.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Controls/window/window.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Controls/window/modal.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/Controls/spinner/spinner.js'

        # Activating Notimoo plugin
        #script type: 'text/javascript', src: @assetsPath+'/javascript/mochaui/Plugins/notimoo/Notimoo.js'
        #link rel: 'stylesheet', media: 'all', type: 'text/css', href: @assetsPath+'/javascript/mochaui/Plugins/notimoo/Notimoo.css'

        # 'UI initialization'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mochaui/init.js'
        # 'Ionize'
        # 'In a production environment, these files should be grouped and compressed'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_core.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_window.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_request.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_content.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_droppable.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_forms.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_mediamanager.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_itemsmanager.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_tinymce.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_tree_xhr.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/ionize/ionize_list_filter.js'
        # 'Mootools Filemanager'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-filemanager/Source/FileManager.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-filemanager/Language/Language.en.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-filemanager/Source/Uploader/Fx.ProgressBar.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-filemanager/Source/Uploader/Swiff.Uploader.js'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-filemanager/Source/Uploader.js'
        # 'Flash test. No Flash means the NoFlash MTFM Uploader needs to be loaded'
        # 'If the player < 9, no Flash upload'
        script type: 'text/javascript', ->
          """
          var upload_mode = 'multiple'; // single
          if(swfobject.ua.pv[0] < 9 || upload_mode=='single')
          {
          Asset.javascript('#{@assetsPath}/javascript/mootools-filemanager/Source/NoFlash.Uploader.js');
          }
          """

        # '<script type="text/javascript" src="/javascript/mootools-filemanager/Source/NoFlash.Uploader.js"></script>'
        script type: 'text/javascript', src: @assetsPath + '/javascript/mootools-filemanager/Source/Gallery.js'
        link rel: 'stylesheet', media: 'all', type: 'text/css', href: @assetsPath + '/javascript/mootools-filemanager/Assets/Css/FileManager_ionize.css'
        comment '[if IE 7]><link rel="stylesheet" href="/javascript/mootools-filemanager/Assets/Css/FileManager_ie7.css" /><![endif]'
        # 'TinyMCE'
        script type: 'text/javascript', src: @assetsPath + '/javascript/tinymce/jscripts/tiny_mce/tiny_mce_src.js'


        script type: 'text/javascript', ->
          """
          var tinyCSS = '#{@assetsPath}/css/tinyMCE.css'
          var getTinyTemplates = false;
          """

        coffeescript ->


          # Global filemanager
          @filemanager = ''

          # Global MediaManager
          @mediaManager = new IonizeMediaManager({
                                                 baseUrl: @base_url
                                                 adminUrl: @admin_url
                                                 pictureContainer: 'pictureContainer'
                                                 musicContainer: 'musicContainer'
                                                 videoContainer: 'videoContainer'
                                                 fileContainer: 'fileContainer'
                                                 fileButton: '.fmButton'
                                                 wait: 'waitPicture'
                                                 mode: 'mootools-filemanager'
                                                 thumbSize: 120
                                                 pictureArray: Array('gif', 'jpe', 'jpeg', 'jpg', 'png')
                                                 musicArray: Array('mp3')
                                                 videoArray: Array('flv', 'mpeg', 'mpg')
                                                 fileArray: Array('pdf')
                                                 })

          # If user's theme has a tinyMCE.css content CSS file, load it.
          # else, load the standard tinyMCE content CSS file
          @tinyButtons1 = 'pdw_toggle,fullscreen,|,codemirror,|,bold,italic,strikethrough,|,formatselect,|,bullist,numlist,|,link,unlink,image, nodize'
          @tinyButtons2 = ' undo,redo,|,pastetext,selectall,removeformat,|,media,charmap,hr,blockquote,|,template,|,justifyleft,justifycenter,justifyright,justifyfull'
          @tinyButtons3 = 'tablecontrols, nodize'
          @tinyBlockFormats = 'p,h2,h3,h4,h5,pre,div'


      body ->
        div id: 'desktop', class: 'desktop'

  @client '/backendEvents.js': ->
    console.log "BackendEvents"
    # Socket.io stuff
    @connect()

    # Display "disconnected" icon, next to "Nodize" logo, on socket.io disconnection
    @on disconnect: ->
      $ = jQuery

      $('#icon_connected').hide()
      $("#icon_disconnected").show()

    # Display "connected" icon, next to "Nodize" logo
    @on connect: ->
      $ = jQuery

      $('#icon_connected').show()
      $("#icon_disconnected").hide()


    @on dashboard_info_update: ->
      $ = jQuery

      # console.log "dash update request", @data

      #$('#dashboard-column-test > li > div.widget-content').html( "Users "+socket.data.usercount )

      $("#dashboard-knob-users")
        .trigger('configure', { "max" : @data.maxuser  } )

      $("#dashboard-knob-users")
        .val( @data.usercount )
        .trigger('change')

      $("#dashboard-knob-memory")
        .trigger('configure', { "max" : @data.maxmemory  } )

      $("#dashboard-knob-memory")
        .val( @data.memory )
        .trigger('change')
