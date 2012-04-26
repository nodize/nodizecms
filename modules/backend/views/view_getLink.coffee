@include = ->

  #
	# Article, display links
	#
	@view backend_getLink: ->
    dl '.small.dropArticleAsLink dropPageAsLink', ->
      dt ->
    		label for: 'link', title: 'Internal or External HTTP link. Replace the default page link', 'Link'
    		br()
    	dd ->
    		textarea '#link.inputtext.w140 h40 droppable', alt: 'drop a link here...'
    		br()
    		a id: 'add_link', 'Add link'

    coffeescript ->
        ION.initDroppable()

        $("add_link").addEvent "click", ->
          ION.JSON "article/add_link",
            receiver_rel: $("rel").value
            link_type: "external"
            url: $("link").value

