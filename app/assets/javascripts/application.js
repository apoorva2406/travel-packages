// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require best_in_place
//= require jquery_ujs
//= require bootstrap.min
//= require login_singup
//= require bootstrap-hover-dropdown.min
//= require waypoints.min
//= require bootstrap-slider
//= require thumbnail-slider
//= require map_initialize
//= require bootstrap-multiselect
//= require modernizr
//= require jquery-migrate-1.2.1.min
//= require jquery-ui-1.10.4.custom.min
//= require modernizr.custom
//= require jquery.cbpContentSlider.min
//= require classie
//= require script
//= require jquery.mixitup
//= require cbpFWTabs
//= require jquery.easing.1.3
//= require jquery.themepunch.plugins.min
//= require jquery.themepunch.revolution.min
//= require jquery.bxslider



//Property index page map

$(window).load(function(){
  window.index_map;
  window.map_canvas = document.getElementById('map_canvas_slide');
  window.map_options = {
    //center: start_point,
    zoom: 5,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  
})


function mark_pinsIndex(markers) {
  var geocoder = new google.maps.Geocoder();
  var bounds = new google.maps.LatLngBounds();
  var markersArray = [];

  for (i = 0; i < markers.length; i++) {
    geocoder.geocode({
      'address': markers[i]['address']
    }, function (results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var marker = new google.maps.Marker({
        map: index_map,
        position: results[0].geometry.location,
        // icon: '/assets/marker.png',
        draggable: true
      });
      marker.setMap(index_map);
      bounds.extend(results[0].geometry.location);
      //markersArray.push(marker);
      index_map.fitBounds(bounds);
      if(index_map.getZoom()> 15){
        index_map.setZoom(3);
      }
    } else {
     //alert('Internal error:');
    }
  });
  }
}


$(document).ready(function() {
  window.properties_ids;
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});

$(document).ready(function(){
  $(".dropdown").click(function(){
    $('.dropdown-menu').toggle();
  })

  //Checkbox validation
  $('.property_form_sub_btn').click(function() {
    checked = $('input[name="property[properties_type][]"]:checked').length;
    if(!checked) {
      alert("You must check at least one properties type.");
      return false;
    }
  });

  //step_2 price
  $('.step_2_price').keypress(function(event) {
    if(event.which == 8 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46) 
    return true;

    else if((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57))
    event.preventDefault();
  });



  //Home page
 "use strict";

  try {
    var myTimer = 0; clearTimeout(myTimer);
    myTimer = setTimeout(function () { $("#loader-wrapper").slideUp() }, 2000);
  } catch (err) {
  }


  var tpj = jQuery;
  tpj(document).ready(function () {
    "use strict";
    if (tpj.fn.cssOriginal !== undefined)
        tpj.fn.css = tpj.fn.cssOriginal;
    tpj('.fullwidthbanner').revolution(
    {
      delay: 9000,
      startwidth: 1170,
      startheight: 646,
      onHoverStop: "on",
      thumbWidth: 100,
      thumbHeight: 50,
      thumbAmount: 4,
      hideThumbs: 200,
      navigationType: 'none',
      navigationArrows: "verticalcentered",   //nexttobullets, verticalcentered, none
      navigationStyle: "large",
      touchenabled: "on",
      navOffsetHorizontal: 0,
      navOffsetVertical: 20,
      fullWidth: "on",
      shadow: 0
    });
  });

  $('.bxslider').bxSlider({
    auto: true
  });

  $('#search_office_type').multiselect({
    includeSelectAllOption: true,
    numberDisplayed: 1
  });

  $("#search_near_me").click(function(){
    $("#near_me").val(true);
  })

  // Property index 
  $('#cbp-contentslider').cbpContentSlider();
  $('#Grid').mixItUp()
})

//search location
var options = {
  componentRestrictions: {country: "in"}
};

function initializeHome(){
  var input = (document.getElementById('search_desire'));
  var autocomplete = new google.maps.places.Autocomplete(input,options);
}