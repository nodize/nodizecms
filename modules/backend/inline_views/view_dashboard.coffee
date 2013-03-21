@include = ->

  
  @client '/admin/backend_dashboard.js': ->        
    @connect()

    #
    # Test event, received on new connection
    #  
    @on "testEvent": (event)->
      #console.log "connection in dashboard"
      #console.log event
      #alert "connection"
      now = new Date()
      hour = now.getHours()
      min = now.getMinutes()
      sec = now.getSeconds()

      j$( "#intrxo .widget-content").text( hour+":"+min+":"+sec+" "+event.data.message)

  #
  # Displaying dashboard
  #
  # Javascript & css from http://net.tutsplus.com/tutorials/javascript-ajax/inettuts/ (James Padolsey)
  @view backend_dashboard: ->
    html ->
      head ->
        title "dashboard"        
        link type: 'text/css', rel: 'stylesheet', href: @assetsPath+'/css/dashboard.css' 

      div "#head", ->
        h1 "Dashboard"
     
      div "#columns.dashboard", ->      
        ul "#dashboard-column1.dashboard-column", ->
          li "#intro.widget.color-white", ->
            div ".widget-head", ->
              h3 "widget title"
            div ".widget-content", ->
              p "The content..."
              p "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
              tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
              quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
              consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
              cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
              proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
              tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
              "            

          ###li ".widget.color-blue", ->
            div ".widget-head", ->
              h3 "widget title"
            div ".widget-content", ->
              p "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
              tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
              quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
              consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
              cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
              proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          ###

        # ul "#dashboard-column3.dashboard-column", ->
        #   li ".widget.color-green", ->
        #     div ".widget-head", ->
        #       h3 "widget title"
        #     div ".widget-content", ->
        #       p "The content..."
          

        ul "#dashboard-column-test.dashboard-column", ->
          li ".widget.color-yellow", ->
            div ".widget-head", ->
              h3 "Users & Memory used"
            div ".widget-content", ->
              
              input ".knob",
                id:"dashboard-knob-users"
                value:"35"
                "data-width":"80"
                "data-fgColor":"#ffec03"
                "data-skin":"tron"
                "data-thickness":".2"
                "data-displayPrevious":true
                "data-readOnly" : true
                "data-max" : 5
                "data-title" : 'users'
              

              input ".knob",
                id:"dashboard-knob-memory"
                value:"35"
                "data-width":"80"
                "data-fgColor":"#ffec03"
                "data-skin":"tron"
                "data-thickness":".2"
                "data-displayPrevious":true
                "data-readOnly" : true
                "data-max" : 100
                "data-title" : 'memory'



      
      

      coffeescript ->
        #
        # Knob activation
        #
        $ = jQuery

        $ ->
          $(".knob").knob draw: ->
  
            # "tron" case
            if @$.data("skin") is "tron"              
              a = @angle(@cv) # Angle
              sa = @startAngle # Previous start angle
              sat = @startAngle # Start angle
              ea = undefined
              # Previous end angle
              eat = sat + a # End angle
              r = true

              @g.lineWidth = @lineWidth
              
              @o.cursor and (sat = eat - 0.3) and (eat = eat + 0.3)
              
              if @o.displayPrevious
                ea = @startAngle + @angle(@value)
                @o.cursor and (sa = ea - 0.3) and (ea = ea + 0.3)
                @g.beginPath()
                @g.strokeStyle = @previousColor
                @g.arc @xy, @xy, @radius - @lineWidth, sa, ea, false
                @g.stroke()
              
              @g.beginPath()
              @g.strokeStyle = (if r then @o.fgColor else @fgColor)
              @g.arc @xy, @xy, @radius - @lineWidth, sat, eat, false
              @g.stroke()
              @g.lineWidth = 2
              @g.beginPath()
              @g.strokeStyle = @o.fgColor
              @g.arc @xy, @xy, @radius - @lineWidth + 1 + @lineWidth * 2 / 3, 0, 2 * Math.PI, false
              @g.stroke()

              @g.fillStyle = "#FFF"
              @g.textBaseline = "mb"
              @g.fillText(@$.data("title"), 30, 90)

              false

        #
        # Using JQuery to load the javascript code that is in charge to manage events (socket.io)
        #        
        window.j$ = jQuery.noConflict()
        
        jQuery.noConflict().ajax
          url: "/admin/backend_dashboard.js"
          dataType : "script"          

        iNettuts =
          jQuery: jQuery.noConflict()
          settings:
            columns: ".dashboard-column"
            widgetSelector: ".widget"
            handleSelector: ".widget-head"
            contentSelector: ".widget-content"
            widgetDefault:
              movable: true
              removable: true
              collapsible: true
              editable: true
              colorClasses: [ "color-yellow", "color-red", "color-blue", "color-white", "color-orange", "color-green" ]

            widgetIndividual:
              intro:
                movable: false
                removable: false
                collapsible: false
                editable: false

              gallery:
                colorClasses: [ "color-yellow", "color-red", "color-white" ]

          init: ->
            @attachStylesheet "/backend/javascript/dashboard/inettuts.js.css"
            @addWidgetControls()
            @makeSortable()

          getWidgetSettings: (id) ->
            $ = @jQuery
            settings = @settings
            (if (id and settings.widgetIndividual[id]) then $.extend({}, settings.widgetDefault, settings.widgetIndividual[id]) else settings.widgetDefault)

          addWidgetControls: ->
            iNettuts = this
            $ = @jQuery
            settings = @settings

            #
            # Loop through each widget:  
            #
            $(settings.widgetSelector, $(settings.columns)).each ->

              #
              # Merge individual settings with default widget settings
              #
              thisWidgetSettings = iNettuts.getWidgetSettings(@id)

              #
              # (if "removable" option is TRUE): 
              #
              if thisWidgetSettings.removable
                #
                #  Add CLOSE (REMOVE) button & functionality
                #
                $("<a href=\"#\" class=\"remove\">CLOSE</a>").mousedown((e) ->
                  e.stopPropagation()
                ).click(->
                  #if confirm("This widget will be removed, ok?")
                  $(this).parents(settings.widgetSelector).animate
                    opacity: 0
                  , ->
                    $(this).wrap("<div/>").parent().slideUp ->
                      $(this).remove()
                  false
                ).appendTo $(settings.handleSelector, this)

              #
              # (if "editable" option is TRUE):  
              #
              if thisWidgetSettings.editable
                #
                # Create new anchor element with class of 'edit':   
                #
                $("<a href=\"#\" class=\"edit\">EDIT</a>").mousedown((e) ->
                  #
                  # Stop event bubbling  
                  #
                  e.stopPropagation()
                ).toggle(->
                  #
                  # // Toggle: (1st state):
                  #

                  #
                  # Change background image so the button now reads 'close edit':  
                  #
                  $(this).css(
                    backgroundPosition: "-66px 0"
                    width: "55px"
                  )
                    #
                    # Traverse to widget (list item):  
                    #
                    .parents(settings.widgetSelector)
                      #
                      # Find the edit-box, show it, then focus <input/>: 
                      #
                      .find(".edit-box")
                        .show()
                        .find("input")
                        .focus()
                  false
                , ->
                  #
                  # Toggle: (2nd state):
                  #

                  #
                  # Reset background and width (will default to CSS specified in StyleSheet):
                  #
                  $(this).css(
                    backgroundPosition: ""
                    width: "")
                    #
                    # Traverse to widget (list item):
                    #
                    .parents(settings.widgetSelector)
                    #
                    # Find the edit-box and hide it:
                    #
                    .find(".edit-box").hide()
                  #
                  # Return false, prevent default action:
                  #
                  false
                #
                # Append this button to the widget handle:
                #
                ).appendTo $(settings.handleSelector, this)
                
                #
                # Add the actual editing section (edit-box):  
                #
                $("<div class=\"edit-box\" style=\"display:none;\"/>").append("<ul><li class=\"item\"><label>Title</label><input size=12 value=\"" + $("h3", this).text() + "\"/></li>").append((->
                  colorList = "<li class=\"item\"><label>Color:</label><ul class=\"colors\">"
                  $(thisWidgetSettings.colorClasses).each ->
                    colorList += "<li class=\"" + this + "\"/>"

                  colorList + "</ul>"
                )()).append("</ul>").insertAfter $(settings.handleSelector, this)

              #
              # (if "collapsible" option is TRUE): 
              #
              if thisWidgetSettings.collapsible
                #
                # Add COLLAPSE button and functionality 
                #
                $("<a href=\"#\" class=\"collapse\">COLLAPSE</a>").mousedown((e) ->
                  e.stopPropagation()
                ).toggle(->
                  $(this).css(backgroundPosition: "-38px 0").parents(settings.widgetSelector).find(settings.contentSelector).hide()
                  false
                , ->
                  $(this).css(backgroundPosition: "").parents(settings.widgetSelector).find(settings.contentSelector).show()
                  false
                ).prependTo $(settings.handleSelector, this)

            $(".edit-box").each ->
              $("input", this).keyup ->
                $(this).parents(settings.widgetSelector).find("h3").text (if $(this).val().length > 20 then $(this).val().substr(0, 20) + "..." else $(this).val())

              $("ul.colors li", this).click ->
                colorStylePattern = /\bcolor-[\w]{1,}\b/
                thisWidgetColorClass = $(this).parents(settings.widgetSelector).attr("class").match(colorStylePattern)
                $(this).parents(settings.widgetSelector).removeClass(thisWidgetColorClass[0]).addClass $(this).attr("class").match(colorStylePattern)[0]  if thisWidgetColorClass
                false

          attachStylesheet: (href) ->
            $ = @jQuery
            $("<link href=\"" + href + "\" rel=\"stylesheet\" type=\"text/css\" />").appendTo "head"

          makeSortable: ->
            iNettuts = this
            $ = @jQuery
            settings = @settings
            $sortableItems = (->
              notSortable = ""
              $(settings.widgetSelector, $(settings.columns)).each (i) ->
                unless iNettuts.getWidgetSettings(@id).movable
                  @id = "widget-no-id-" + i  unless @id
                  notSortable += "#" + @id + ","

              $ "> li:not(" + notSortable + ")", settings.columns
            )()
            $sortableItems.find(settings.handleSelector).css(cursor: "move")
              #
              # Mousedown function
              #              
              .mousedown((e) ->
                $sortableItems.css width: ""
                #
                # Traverse to parent (the widget):
                #
                $(this).parent().css
                  #
                  # Explicitely set width as computed width:
                  # 
                  width: $(this).parent().width() + "px"
                  #width:100
                  #"background-color":"#F00" 
                  #z-index":9999
                  )
                  
              #
              # Mouseup function
              #
              .mouseup ->
                #
                # Check if widget is currently in the process of dragging  
                #
                unless $(this).parent().hasClass("dragging")
                  $(this).parent().css width: ""
                #
                #  If it IS currently being dragged then we want to 
                # temporarily disable dragging, while widget is 
                # reverting to original position. 
                #
                else
                  $(settings.columns).sortable "disable"

            #
            # Select the columns and initiate 'sortable': 
            #
            $(settings.columns).sortable
              #
              # Specify those items which will be sortable: 
              #
              items: $sortableItems

              #
              # Connect each column with every other column:  
              #
              connectWith: $(settings.columns)

              #
              # Set the handle to the top bar:
              #
              handle: settings.handleSelector

              #
              # Define class of placeholder (styled in inettuts.js.css) 
              #
              placeholder: "widget-placeholder"

              #
              # Make sure placeholder size is retained:  
              #
              forcePlaceholderSize: true

              #
              # Animated revent lasts how long? 
              #
              revert: 300

              #
              # Delay before action: 
              #
              delay: 100

              #
              # Opacity of 'helper' (the thing that's dragged):
              #
              opacity: 0.8

              #
              # Set constraint of dragging to the document's edge: 
              #
              containment: "document"              

              #
              # Function to be called when dragging starts: 
              #              
              start: (e, ui) ->
                $(ui.helper).addClass "dragging"
                #
                # You can change the css of the widget being moved
                #
                #$(ui.helper).css width: 150
                $(ui.helper).css "-webkit-transform": "rotate(-5deg)", "-moz-transform": "rotate(-4deg)"


              #
              #  Function to be called when dragging stops:  
              #
              stop: (e, ui) ->
                #
                # Reset width of units and remove dragging class:  
                #
                $(ui.item).css(width: "").removeClass "dragging"
                $(ui.item).css "-webkit-transform": "rotate(0deg)", "-moz-transform": "rotate(0deg)"

                #
                # Re-enable sorting (we disabled it on mouseup of the handle):
                #
                $(settings.columns).sortable "enable"

        iNettuts.init()