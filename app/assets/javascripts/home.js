
var delId = "";
function changeDeleteId(userRow){
	delId = $(userRow).parent().parent().find(".UserID").html();
}

function deleteUser(){
	console.log(delId);
	var userID = delId;
	$.ajax({
		url: localhost+"/home/delete/"+userID+".json", //ke PHP nya
		header: {
			"Access-Control-Allow-Origin": localhost
		},
			type: 'POST',
			data: {
				_method: 'DELETE'
			},

			success: function (returnData) {
				alert(returnData.message);
				window.location.reload(true);

			},error: function (statusText, jqXHR, returnText) {
				//alert(statusText.responseText.message);
				alert(JSON.parse(statusText.responseText).message);
			}
	});
}

$(document).ready(function() {
	$("#submitNewUser").on('click',function(){
		//var authenticityToken = $('#authenticity_token').val();
		var userUsername = $('#userUsername').val();
		var userPassword = $('#userPassword').val();  
		var userConfirmPassword = $('#userConfirmPassword').val();
		var userType = $('#userType').val();

		$.ajax({
			url: localhost+"/home/create.json", //ke PHP nya
			type: 'POST',
			data: {
				_method : "POST",
				"user[username]" : userUsername,
				"user[password]" : userPassword,
				"user[password_confirmation]" : userConfirmPassword,
				"user[user_type]" : userType
			},
			success: function (returnData) {
				alert(returnData.message);
				window.location.reload(true);

			},error: function (statusText, jqXHR, returnText) {
				var errorMessage = JSON.parse(statusText.responseText).errors;

				$.each(errorMessage, function(key, value) {
				$('#create_user_' + key + '_header').attr("hidden", false);
				$('#create_user_' + key + '_alert').html(value);
			    console.log(key, value);
				});

				console.log(errorMessage);	
			}
		});
	});
});

function changePassword(){
	var username = $('#username').html();
	var old_password = $('#changePasswordOldPassword').val();
	var new_password = $('#changePasswordNewPassword').val();
	var password_confirmation = $('#changePasswordPasswordConfirmation').val();

	console.log(username+" "+old_password+" "+new_password+" "+password_confirmation);

	$.ajax({
		url: localhost+"/home/verify_change_password.json", //ke PHP nya
		type: 'POST',
		data: {
			_method: 'POST',
			'user[username]': username,
			'user[old_password]': old_password,
			'user[password]': new_password,
			'user[password_confirmation]': password_confirmation
		},

		success: function (returnData) {
			alert(returnData.message);
			window.location.reload(true);

		},error: function (statusText, jqXHR, returnText) {
			var errorMessage = JSON.parse(statusText.responseText).errors;

			$.each(errorMessage, function(key, value) {
			$('#change_password_' + key + '_header').attr("hidden", false);
			$('#change_password_' + key + '_alert').html(value);
		    console.log(key, value);
			});
		}
});
}

function authenticateUser(){
	var username = $('#login-username').val();
	var password = $('#login-password').val();

	$.ajax({
		url: localhost+"/home/authentication.json",
		type: 'POST',
		data: {
			'user[username]': username,
			'user[password]': password
		},
		success: function (returnData){
			window.location = localhost+"/home/index";
		},
		error: function (statusText, jqXHR, returnText){
			var errorMessage = JSON.parse(statusText.responseText).errors;
			$("#login_error_message").html(errorMessage);		
		}
	});
}