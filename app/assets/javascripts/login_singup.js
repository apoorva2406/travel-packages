$(document).ready(function(){
  //Login
	$("#login_form").submit(function(e) {
    e.preventDefault();
    $('.device_errors_signin').text('');
    $.ajax({
      url: "/users/sign_in",
      type: "POST",
      data: { user: {email: $("#signin_email").val(),password: $("#signin_password").val()} },
      beforeSend: function(msg){
        $("#signing_submit").text('Submit....');
      },
      success: function (response) {
        //window.location.reload("/");  
      },
      error: function(response) {
        if (response.statusText == "OK"){
          window.location.reload("/");
        }
        if (response.status == 401){
          $("#signing_submit").text('Submit');
          $('.device_errors_signin').text(response.responseText);
        }
      }
    });
  }); 

  //Registraion
  $("#registration_form").submit(function(e) {
    e.preventDefault();
    $('.device_errors_signup').text('');
    $.ajax({
      url: "/users",
      type: "post",
      data: { user: {name: $("#signup_name").val(), mobile_no: $("#signup_mobile").val(), email: $("#signup_email").val(), password: $("#signup_password").val(), password_confirmation: $("#signup_c_password").val(), role: $('input[name=role]:checked').val() }},
      beforeSend: function(msg){
        $("#signup_submit").text("Wait...");
      },
      success: function (response) {
        window.location.reload("/");  
      },
      error: function(response) {
        if (response.statusText == "OK"){
          window.location.reload("/");
        }
        
        if (response.status == 422){
          $("#signup_submit").text("Register & Login");
          $('.device_errors_signup').text(response.responseText);
        }
      }
    });
  }); 
});