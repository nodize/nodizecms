# Toolbox for article page in backend
#
# Nodize CMS
# https://github.com/hypee/nodize
#
# Original page design :
# IonizeCMS (http://www.ionizecms.com), 
# (c) Partikule (http://www.partikule.net)
#
# CoffeeKup conversion & adaptation :
# Hypee (http://hypee.com)
#
# Licensed under the MIT license:
# http://www.opensource.org/licenses/MIT
#
@include = ->
	#
	# Toolboxes for article
	#
	@view backend_articleToolbox: ->
		html ->
			div '#tArticleFormSubmit.toolbox.divider nobr', ->
				input '#articleFormSubmit.submit', type: 'button', value: @ion_lang.ionize_button_save_article
			div '#tArticleDeleteButton.toolbox.divider nobr', ->
				input '#articleDeleteButton.button.no', type: 'button', value: @ion_lang.ionize_button_delete
			div '.toolbox.divider', ->
				input '#sidecolumnSwitcher.toolbar-button', type: 'button', value: @ion_lang.ionize_show_options
			# div '#tArticleDuplicateButton.toolbox.divider', ->
			# 	span '#articleDuplicateButton.iconWrapper', ->
			# 		img src: '/backend/images/icon_16_copy_article.gif', width: '16', height: '16', alt: '#ionize_button_duplicate_article', title: @ion_lang.ionize_button_duplicate_article
			# div '#tArticleAddContentElement.toolbox.divider', ->
			# 	input '#addContentElement.toolbar-button.element', type: 'button', value: @ion_lang.ionize_label_add_content_element
			div '#tArticleMediaButton.toolbox', ->
				input '#addMedia.fmButton.toolbar-button pictures', type: 'button', value: @ion_lang.ionize_label_attach_media

		coffeescript ->
			# Form save action
	 		# see init.js for more information about this method
			ION.setFormSubmit "articleForm", "articleFormSubmit", "article_save"

			# Delete & Duplicate button buttons
			id = $("id_article").value
			unless id
			  $("tArticleDeleteButton").hide()
			  # $("tArticleDuplicateButton").hide()
			  # $("tArticleAddContentElement").hide()
			  $("tArticleMediaButton").hide()
			else
				# Delete button
				url = admin_url + "article\/\/delete/"
				ION.initRequestEvent $("articleDeleteButton"), url + id,
				redirect: true
				,
				confirm: true
				message: Lang.get("ionize_confirm_element_delete")

				# Duplicate button
				# $("articleDuplicateButton").addEvent "click", (e) ->
				#   url = $("name").value
				#   rel = ($("rel").value).split(".")
				#   data = id_page: rel[0]
				#   ION.formWindow "DuplicateArticle", "newArticleForm", "ionize_title_duplicate_article", "article/duplicate/" + id + "/" + url,
				#     width: 520
				#     height: 280
				#   , data

				$("addMedia").addEvent "click", (e) ->
					e.stop()
					mediaManager.initParent "article", $("id_article").value
					mediaManager.toggleFileManager()

				# Add Content Element button
				# $("addContentElement").addEvent "click", (e) ->
				#     ION.dataWindow "contentElement", "ionize_title_add_content_element", "element/add_element",
				# 	      width: 500
				# 	      height: 350
				#     ,
				# 	      parent: "article"
				# 	      id_parent: id
			# Options show / hide button
			ION.initSideColumn()
			# Save with CTRL+s
			ION.addFormSaveEvent "articleFormSubmit"