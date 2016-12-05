var options = {
  componentRestrictions: {country: "in"}
};

function initMap(map_id, input_id) {
  var map = new google.maps.Map(document.getElementById(map_id), {
    center: {lat: -33.8688, lng: 151.2195},
    zoom: 6
  });

  //search location
  var input = (document.getElementById(input_id));
  var autocomplete = new google.maps.places.Autocomplete(input, options);
  autocomplete.bindTo('bounds', map);

  // Locate corrent locaiton
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      //set form attributes
      setCoordinateInitial(pos,map,input_id);
      map.setCenter(pos);
    }, function() {
      $.ajax({
        url: 'https://ipinfo.io',
        dataType: 'jsonp',
        async: false,
        success: function(response) {
          var lat_lng = response.loc.split(',');
          var pos = {
            lat: parseFloat(lat_lng[0]),
            lng:  parseFloat(lat_lng[1])
          };
          
          //set form attributes
          setCoordinateInitial(pos,map,input_id);
          map.setCenter(pos);
        }
      });
    });
  } 

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("Autocomplete's returned place contains no geometry");
      return;
    }
    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
    }

   	map.setZoom(6);
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);
  });
}

function editMap(map_id, input_id,lat,lng) {
  var map = new google.maps.Map(document.getElementById(map_id), {
    center: {lat: parseFloat(lat), lng: parseFloat(lng)},
    zoom: 6
  });

  //search location
  var input = (document.getElementById(input_id));
  var autocomplete = new google.maps.places.Autocomplete(input);
  autocomplete.bindTo('bounds', map);

  var pos = {
    lat: parseFloat(lat),
    lng:  parseFloat(lng)
  };

  window.marker = new google.maps.Marker({
    position: pos,
    map: map
  });

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("Autocomplete's returned place contains no geometry");
      return;
    }
    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
    }

    map.setZoom(6);
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);
  });
}

function setCoordinateInitial(pos,map,input_id){
  window.marker = new google.maps.Marker({
    position: pos,
    map: map
  });

  var geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(pos.lat, pos.lng);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
      if(status == google.maps.GeocoderStatus.OK) {
        document.getElementById(input_id).value = results[0]['formatted_address'];
      };
  });
}