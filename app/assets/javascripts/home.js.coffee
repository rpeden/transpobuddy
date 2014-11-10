# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

root = exports ? this

transpo = window.Transpo = {}

map = {}

$ ->
	$('#stops').click ->
		address = $('#address').attr 'value'
		geocodeAddress(address)

	$('#address').keypress (e) ->
		code = if e.keyCode then e.keyCode else e.which
		address = $('#address').attr 'value'
		if code.toString() == '13'
			geocodeAddress(address)


geocodeAddress = (address) -> 
	geocoder = new google.maps.Geocoder()
	geocoder.geocode
		'address' : address + 'Ottawa, Ontario'
		(result, status) ->
			if status == google.maps.GeocoderStatus.OK
				Map.latitude = result[0].geometry.location.lat()
				Map.longitude = result[0].geometry.location.lng()
				Map.createmap()
			else
				alert("Geocoder failed. Reason: " + status)


transpo.moveMap = ->
	newCenter = new google.maps.LatLng(45.4214, -75.6919)
	Map.map.setCenter(newCenter)
	return


window.initMap = ->
	mapOptions =
	center: new google.maps.LatLng(-34.397, 150.644)
	zoom: 8
	mapTypeId: google.maps.MapTypeId.ROADMAP

	mapElement = $("#map_canvas")[0]

	map = new google.maps.Map(mapElement,mapOptions)
	return