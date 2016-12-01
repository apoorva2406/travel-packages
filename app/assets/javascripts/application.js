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


$(document).ready(function() {
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
})
