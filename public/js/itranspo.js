//default coordinates

//singleton for now since we're only going to need a single map for this app. maybe refactor later to make it more reuseable
//so we can have multiple maps on the go in a non-mobile app
 
  Map = {
    
    //defaults in case geolocation doesn't work
    latitude : 45.423415,
    longitude : -75.698379,
    map : " ",
    markersArray : [],
    
    Boundaries : {
   
      swLat : 0,
      swLng : 0,
      neLat : 0,
      neLng : 0
    
    },  
    
     
    //called from init.js
    init : function(location) {
	
	if(navigator.geolocation){
            Map.latitude = location.coords.latitude;
            Map.longitude = location.coords.longitude;
	}
    
    },
    
    //create the map, add listeners, and nearest transit stops
    createmap : function() {
        
        latlng = new google.maps.LatLng(this.latitude, this.longitude);
	 
        var mapOptions = {
            zoom: 17,
	    center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
	    //make everyone use the zoom buttons; pinch zoom seems to be choppy/unreliable right now
	    	disableDefaultUI: true,
	    	navigationControl: true,
	    	navigationControlOptions : { style: google.maps.NavigationControlStyle.ANDROID },
	    	mapTypeControl: false
	      
        };
        
        map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
	
        google.maps.event.addListener(map, 'tilesloaded', function() {
            // Called on initial map load.
            Map.redoBoundaries();
	    Map.addpoints();
	    //kill it becase we'll use a different listener after initial load
            google.maps.event.clearListeners(map, 'tilesloaded');
        });
        
        google.maps.event.addListener(map, 'idle', function() {
            if (map.zoom < 16) { return;} 
	    	Map.redoBoundaries();
            Map.addpoints();
        });

		google.maps.event.addListener(map, 'zoom_changed', function() {
            if (map.zoom < 16) { 
            	alert("Stops not available at this zoom level. Please zoom in to load more stops.");
				return; 
			}
	    	setTimeout(function() { Map.redoBoundaries(); Map.addpoints(); }, 100);
        });
           
    },
    
    
    addpoints : function() {
     
       $.get("/stops?latMin=" + Map.Boundaries.swLat + "&latMax=" + Map.Boundaries.neLat + "&lngMin="
             + Map.Boundaries.swLng + "&lngMax=" + Map.Boundaries.neLng,
            
            function(response) {
                //TODO: replace this eval with a proper JSON Parse
                //however data only comes from a trusted source
                var result = eval(response);
                         
			for(var key in result){
                    
                    var stopLatLng = new google.maps.LatLng(result[key]["stop_lat"] 
				     - .00001  ,result[key]["stop_lon"] + .0000455);
                    var marker = new google.maps.Marker ({
                    
                            position: stopLatLng,
                            map: map,
                            title: result[key]["stop_name"],
			    			icon: '/img/bus.png'
		      		});
		    
		    		var id = result[key]["stop_id"]; //make a closure around this when adding click listener
		    
		    		google.maps.event.addListener(marker, 'click', Map.handleMarkerClick(id));
		    		    
                    Map.markersArray.unshift(marker);
		    		if(Map.markersArray.length > 50) {
		      			var deleteme = Map.markersArray.pop();
		      			deleteme.setMap(null);
		    		}
                } 
            }
        );
        
       
    },
        
      changeBoundaries : function(newMinLat, newMaxLat, newMinLon, newMaxLon) {
	 
	 this.minLat = newMinLat;
	 this.maxLat = newMaxLat;
	 this.minLon = newMinLon;
	 this.maxLon = newMaxLon;
	 
      },
      
      redoBoundaries : function() {
	 
	 //I think this will only work in the northern hemisphere...
	 
	 this.Boundaries.swLat = map.getBounds().getSouthWest().lat();
	 this.Boundaries.swLng = map.getBounds().getSouthWest().lng();
	 this.Boundaries.neLat = map.getBounds().getNorthEast().lat();
	 this.Boundaries.neLng = map.getBounds().getNorthEast().lng();
	 
      },
      
      printBoundaries : function() {
        
        $("#map_canvas").html(
			 "SWLon: " + this.Boundaries.swLng + "<br />" +
			 "SWLat: " + this.Boundaries.swLat + "<br />" +
			 "NELon: " + this.Boundaries.neLng + "<br />" +
			 "NELat: " + this.Boundaries.neLat + "<br />");
        
      },
      
      handleMarkerClick : function(stop_id) {
	
	return function() {
	  
	    $.get("/stop_times/" + stop_id, /*marker.position.lat() + "/" + marker.position.lng(),*/
				 function(response) {
				    //TODO: replace this eval with a proper JSON Parse
				    var nextbuses = eval(response);
					
					if(nextbuses.length == 0){
						$('#buses').html("No more buses stop here today.");
					} else{  				     				     
					    $("#buses").html("<tr><th colspan=1>Route</th><th>Destination</th><th colspan=1>Time</th></tr>");
					    for (var key in nextbuses){
					      
					       var depTime = nextbuses[key]["departure_time"].replace(/:00$/, "");
					       //Format the time into 12h format
					       if (depTime.match(/^0[1-9]/) || depTime.match(/^1[0-1]/)) {
						    	depTime += "AM";
					       }
					       else if (depTime.match(/^12/)) {
						  		depTime += "PM";	
					       }
					       else if (depTime.match(/^00/)) {
						    	depTime.replace(/^00/, 12);
						    	depTime += "AM";				       
					       }
					       else if (depTime.match(/^1[3-9]/)) {
						    	var newTime = depTime.split(/:/);
						    	newTime[0] -= 12;
						    	depTime = newTime[0] + ':' + newTime[1] + 'PM';
					       }
					       else {
						    	var newTime = depTime.split(/:/);
						    	newTime[0] -= 12;
						    	depTime = newTime[0] + ':' + newTime[1] + 'PM';
						    
					       }
					      //add upcoming buses to table
					      $("#buses").append("<tr><td>" + nextbuses[key]["route_short_name"] + "</td><td>" 
								 + nextbuses[key]["trip_headsign"]
								 + "</td><td>" + depTime + "</td></tr>");
				      }	      
				    }
				    $('#title').html('Buses');
				    $("#map_canvas").addClass('hidden');
				    $("#map_canvas").css({ height : 0}); 
				    $("#stop_times").removeClass('hidden');
				    $('#content').css({ height: 'auto'});
				    //$("#stop_times").css({ height: $('body').height() - 45 });
				    $('#buses').css({ marginLeft: ($('#bus_info').width() - $('#buses').width()) / 2 });
				    $('#leftnav a').html("Back to Map");
				    $('#leftnav a').attr('href', '#');
				    window.history.pushState(null, null, "stop_times");
					$('#leftnav').bind('click', function() {
						$('#stop_times').addClass('hidden');
						$('#stop_times').removeClass('visible');
						$('#content').css({ height: $('body').height() - $('#topbar').height() });
						$('#map_canvas').css({ height: $('#content').height()});
						$('#map_canvas').removeClass('hidden');
						$('#leftnav a').html("Home");
						$('#leftnav a').attr('href', '/');
						$('#leftnav').unbind('click');
						$('#title').html("Stops");
					});
				
				 }
				 );
	  
		}
	}, //end handleMarkerClick function
	
	setLatLng : function(lat, lng) {
	   this.latitude = lat;
	   this.longitude = lng;
	   var newCenter = new google.maps.LatLng(lat, lng)
	   Map.map.setCenter(newCenter)
	}
    
 }  //end of Map object
  


