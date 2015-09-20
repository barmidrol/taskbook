# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	ch_url = $(location).attr('href') + '/change_username'
	$.fn.editable.defaults.ajaxOptions = {type: "PUT"}

	$('#username').editable
	  type: 'text'
	  pk: 1
	  url: ch_url
	  title: 'Enter username'
