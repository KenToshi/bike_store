function retrieveDataDetailView(orderID){
		$.ajax({
		url: localhost+"/orders/"+orderID+"/retrieve_cart.json",
		type: "GET",
		success: function(returnData){
			
			for(var i = 0 ; i < returnData.length; i++)
			{
				arrayForCheckingCart.push(returnData[i].product_id);
				var qty = returnData[i].qty ;
				var price = parseInt(returnData[i].price);
				var count = qty * price ;
				console.log(returnData[i].product_name)
				var html= ''
				html+= '<tr class="cart-'+returnData[i].product_id+'">'
				html+= '<td class="orderItemID" hidden>'+returnData[i].id+"</td>"
				html+= '<td class="cart-item-productName-'+returnData[i].product_id+'">'
				html+=  returnData[i].product_name
				html+= '</td>'
				html+= '<td class="cart-item-price-'+returnData[i].product_id+'">'
				html+=	returnData[i].price
				html+= '</td>'
				html+= '<td class="cart-item-qty-'+returnData[i].product_id+'">'
				html+=	returnData[i].qty
				html+= '</td>'
				html+= '<td class="cart-item-current-qty-'+returnData[i].product_id+'">'
				html+=	returnData[i].current_stock
				html+= '</td>'
				html+= '<td class="cart-item-total-price-'+returnData[i].product_id+'">'
				html+=	count
				html+= '</td>'
	            html+= '<td>'
	            //html+= '<input type="button" value="Delete" data-toggle="modal" class="btn btn-danger" data-target="#deleteConfirm" onclick="deleteItemFromCart('+returnData[i].product_id+'); deleteOrderItem(this);">'
	            html+= '<input type="button" value="Delete" data-toggle="modal" class="btn btn-danger" data-target="#deleteConfirm" onclick="deleteOrderItem(this,'+returnData[i].product_id+');">'
	            html+= '</td>'
	            html+= '</tr>'
	            $(".cart-item").append(html);
			}
			console.log(arrayForCheckingCart.length);
			calculateGrandTotal();
		},
		error: function(statusText, jqXHR, returnText){
			alert(statusText.responseText.message);
		}
	})
	
}

function editOrder(element){
	orderID = $(element).parent().parent().find(".OrderID").html();
	window.location = localhost+"/orders/"+orderID+"/edit";
}

function deleteOrder(element){
	orderID = $(element).parent().parent().find(".OrderID").html();
	$.ajax({
		url: localhost+"/orders/"+orderID+".json",
		type: "POST",
		data:{
			_method: "DELETE"
		},
		success: function(returnData){
			alert(returnData.message);
			window.location.reload(true);
		},
		error: function(statusText, jqXHR, returnText){
			alert(statusText.responseText.message);
		}
	
	});
}



function upToCustomerSection(){
	$('html,body').animate({
        scrollTop: $(".customer-section").offset().top},
        'slow');
}

function upToItemSection(){
	$('html,body').animate({
        scrollTop: $(".item-section").offset().top},
        'slow');
}

var orderItemTotalPrice = 0;
function calculateTotalPrice(){
	// alert('taik');
	// console.log($("#orderItemPrice").val());
	// console.log($("#orderItemQty").val());
	var price = parseInt($("#orderItemPrice").val());
	var count = parseInt($("#orderItemQty").val());
	// console.log(price);
	// console.log(count);
	var calculate = price * count;
	orderItemTotalPrice = calculate
	$("#orderItemTotalPrice").val(orderItemTotalPrice);
}

function calculateGrandTotal(){
	console.log(arrayForCheckingCart.length);
	var totalItem = arrayForCheckingCart.length;
	console.log('barang yang harus dihitung: '+totalItem)
	var calc = 0;
	for( var i=0 ; i < totalItem ; i++)
	{
		console.log(arrayForCheckingCart)
		var a = arrayForCheckingCart[i];
		console.log('angka dari a: '+a);
		console.log($(".cart-item-total-price-"+a+"").html());
		calc += parseInt($(".cart-item-total-price-"+a+"").html());
	}
	console.log(calc);
	$(".grand-total").html(calc);
}

function deleteItemFromCart(element){
	console.log($(".cart-item-price-"+element+"").html());
	$(".cart-"+element+"").remove();
	for( var i = 0 ; i < arrayForCheckingCart.length ; i++ )
	{
		if(arrayForCheckingCart[i] == element)
		{
			arrayForCheckingCart.splice(i,1)
		}
	}
	console.log(arrayForCheckingCart);
	calculateGrandTotal();
}
function changeDeleteId(orderItemRow){
	delId = $(orderItemRow).parent().parent().find(".OrderItemID").html();
}

function getEvent(e){
	if(e.keyCode == 13){
		findCustomerData();
		alert('test');
	}
}

function findCustomerData(){
	var customerID = $('#orderCustomerID').val();
	$.ajax({
		url: localhost+"/customers/"+customerID+".json",
		type: "GET",
		success: function(returnData){
			$("#orderCustomerName").val(returnData.customer_name);
			$("#orderCustomerAddress").val(returnData.customer_address);
			$("#orderCustomerPhone").val(returnData.customer_phone);
			
			$("#orderCustomerName").attr("disabled", true);
			$("#orderCustomerAddress").attr("disabled", true);
			$("#orderCustomerPhone").attr("disabled", true);
			
		},
		error: function(statusText, jqXHR, returnText){
			$("#orderCustomerName").val("");
			$("#orderCustomerAddress").val("");
			$("#orderCustomerPhone").val("");
			
			$("#orderCustomerName").attr("disabled", false);
			$("#orderCustomerAddress").attr("disabled", false);
			$("#orderCustomerPhone").attr("disabled", false);
		}
	});
}

function getCustomerDataByOrderID(){
	var orderID = $('#orderItemOrderID').val();
	
}

function checkCustomerData(){
	var customerID = $('#orderCustomerID').val();
	var answer = null;
	$.ajax({
		url: localhost+"/customers/"+customerID+".json",
		type: "GET",
		async: false, 
		success: function(returnData){
			answer =  true;
		},
		error: function(statusText, jqXHR, returnText){
			answer =  false;
		}
	});
	return answer;
}

function orderSetCustomerData(){

	var customerID = $('#orderCustomerID').val();
	var customerName = $('#orderCustomerName').val();
	var customerAddress = $('#orderCustomerAddress').val();  
	var customerPhone = $('#orderCustomerPhone').val();
	var orderID = $('#orderItemOrderID').val();
	
	var existence = false;
	
	if(customerID) existence = checkCustomerData();
	var ok = false;
	
	if(orderID != 0){ // kalo udah ada order ID ga perlu dijalanin
		alert(orderID)
		ok = false;
	}
	else if(existence){ // kalo udah ada kita langsung proses
		ok = true;
	}
	else{ // kalo belum ada, kita masukin DB dulu
		$.ajax({
			url: localhost+"/customers.json", //ke PHP nya
			type: 'POST',
			async: false, 
			data: {
				mode: 'POST',//ini mode buat di php nya ton buat else if nya tapi gak gw buatin phpnya yak
				//authenticity_token : authenticity_token,
				"customer[customer_name]" : customerName,
				"customer[customer_address]" : customerAddress,
				"customer[customer_phone]" : customerPhone
			},
			success: function (returnData) {
				ok = true;
				customerID = returnData.customer.id;
				$('#orderCustomerID').append("<option value='"+customerID+"'>"+customerID+" - "+customerName+"</option>")
				$('#orderCustomerID').val(customerID);
			},error: function (statusText, jqXHR, returnText) {
				var errorMessage = JSON.parse(statusText.responseText).errors;
				
				$.each(errorMessage, function(key, value) {
					$('#order_' + key + '_header').attr("hidden", false);
					$('#order_' + key + '_alert').html(value);
				    console.log(key, value);
				});
				
				ok = false;
				console.log(errorMessage);
			}
		});
	}
	
	if(ok){
		
        
		$.ajax({
			url: localhost+"/orders.json",
			type: 'POST',
			data: {
				mode: 'POST',
				"customer[id]": customerID,
				"customer[customer_name]" : customerName,
				"customer[customer_address]" : customerAddress,
				"customer[customer_phone]" : customerPhone
			},
			success: function(returnData){
				console.log(returnData);				 
			    $('#orderCustomerID').attr("disabled", true);
				$('#orderCustomerName').attr("disabled", true);
				$('#orderCustomerAddress').attr("disabled", true);
				$('#orderCustomerPhone').attr("disabled", true);

				$('#submitCustomerOrder').remove();
				 
				 window.location.replace('../'+returnData.id+'/edit');
				 //alert("TEST");
			},
			error: function(statusText,jqXHR,returnText){
				console.log(JSON.parse(statusText.responseText).errors);
				// var errorMessage = JSON.parse(returnText.responseText).errors;
				// console.log(errorMessage);
			}
		})
	}

}

function getProductData(){
	var productID = $("#orderItemProductID").val();
	$.ajax({
		url: localhost+"/products/"+productID+".json",
		type: 'GET',
		success: function(returnData){
			var price = returnData.price;
			
			$("#orderItemPrice").val(price);
			$("#orderItemQty").val("");
			$("#orderItemTotalPrice").val("0");
		},
		error: function(status, jqXHR, returnText){
			$("#orderItemPrice").val("");
			$("#orderItemQty").val("");
			$("#orderItemTotalPrice").val("");
		}
	});
}

var arrayForCheckingCart = [];
var locationSameProductID = 0;
var isSame = false;
var productIteration = 1;
var grandTotal = 0;
function addToCart(){
	var orderID = $("#orderItemOrderID").val();
	var productID = $("#orderItemProductID").val();
	var qty = $("#orderItemQty").val();
	var i = 0;
	
	console.log('panjang array sekarang: '+arrayForCheckingCart.length)
	while(i < arrayForCheckingCart.length && qty > 0)
	{
		console.log('iterasi: '+arrayForCheckingCart[i]);
		if(arrayForCheckingCart[i] == productID)
		{
			console.log("ada yang sama");
			locationSameProductID = i+1;
			isSame = true;
			break;
		}
		else
		{
			i++;
		}
	}
	
	if(isSame == false && qty > 0)
	{
		console.log('yang di push ke array: '+productID)
		arrayForCheckingCart.push(productID);
		console.log(arrayForCheckingCart);
		console.log(productID)
	}
	
	$.ajax({
		url:localhost+"/order_items.json",
		type: 'POST',
		data: {
			_method: "POST",
			"order_item[order_id]": orderID,
			"order_item[product_id]": productID,
			"order_item[qty]": qty
		},
		success: function(returnData){
			console.log(returnData);
			
			if(isSame == true)
			{
				console.log('posisi yagn harus diganti: '+productID)
				$(".cart-item-qty-"+productID+"").html(returnData.qty);
				console.log('harga yang seharusnya: '+orderItemTotalPrice);
				$(".cart-item-total-price-"+productID+"").html(orderItemTotalPrice);
				
			}
			else if(isSame == false)
			{
				var html= ''
				html+= '<tr class="cart-'+productID+'">'
				html+= '<td class="orderItemID" hidden>'+returnData.id+"</td>"
				html+= '<td class="cart-item-productName-'+productID+'">'
				html+=  returnData.product_name
				html+= '</td>'
				html+= '<td class="cart-item-price-'+productID+'">'
				html+=	returnData.price
				html+= '</td>'
				html+= '<td class="cart-item-qty-'+productID+'">'
				html+=	returnData.qty
				html+= '</td>'
				html+= '<td class="cart-item-current-qty-'+productID+'">'
				html+=	returnData.current_stock
				html+= '</td>'
				html+= '<td class="cart-item-total-price-'+productID+'">'
				html+=	orderItemTotalPrice
				html+= '</td>'
	            html+= '<td>'
	            html+= '<input type="button" value="Delete" data-toggle="modal" class="btn btn-danger" data-target="#deleteConfirm" onclick="deleteOrderItem(this,'+productID+'); deleteOrderItem(this);">'
	            html+= '</td>'
	            html+= '</tr>'
	            $(".cart-item").append(html);
	            // productIteration++;
	            grandTotal += orderItemTotalPrice;
			}
			calculateGrandTotal()
			isSame = false;
		},
		error: function(statusText, jqXHR, returnText){
			var errorMessage = JSON.parse(statusText.responseText).errors;
			console.log(errorMessage+" "+returnText);
			$.each(errorMessage, function(key, value) {
				$('#order_item_' + key + '_header').attr("hidden", false);
				$('#order_item_' + key + '_alert').html(value);
			    console.log(key, value);
			});
		}
	});
	
}

function confirmOrder(){

	var orderID = $("#orderItemOrderID").val();
	$.ajax({
		url: localhost+"/orders/verify_order.json",
		type: 'POST',
		data:{
			"order[id]": orderID,
			"status": true
		},
		success: function(returnData){
			alert("Success: "+returnData.message);
				$(".payment-section").css("display","block")
		},
		error: function(statusText, jqXHR, returnText){
			console.log(JSON.parse(statusText.responseText).message+" "+returnText);
			alert("Error: "+JSON.parse(statusText.responseText).message);
		}

	});
}

function deleteOrderItem(orderItemRow, element){
	delId = $(orderItemRow).parent().parent().find(".orderItemID").html();
	var orderItemID = delId
	$.ajax({
		url: localhost+"/order_items/"+orderItemID+".json",
		type: "POST",
		data: {
			_method: "DELETE",
		},
		success: function(returnData){
			console.log($(".cart-item-price-"+element+"").html());
			$(".cart-"+element+"").remove();
			for( var i = 0 ; i < arrayForCheckingCart.length ; i++ )
			{
				if(arrayForCheckingCart[i] == element)
				{
					arrayForCheckingCart.splice(i,1)
				}
			}
			console.log(arrayForCheckingCart);
		},
		error: function(statusText, jqXHR, returnText){
			alert("Verified orders cannot be modified");
		}
		
	});
}

function generateInvoice(orderID){
	var params = [
    'height='+screen.height,
    'width='+screen.width,
    'fullscreen=yes'
	].join(',');
	
	window.open(localhost+"/orders/"+orderID+"/invoice.pdf", "Invoice #"+orderID, params );
}

function generateLetterOfTravel(orderID){
	var params = [
    'height='+screen.height,
    'width='+screen.width,
    'fullscreen=yes'
	].join(',');
	
	window.open(localhost+"/orders/"+orderID+"/letter_of_travel.pdf", "Invoice #"+orderID, params );
}

function confirmPayment(){
	var orderID = $("#orderItemOrderID").val();
	var shippingAddress = $("#orderDetailsShippingAddress").val();
	var shippingMethod = $("#orderDetailShippingMethod").val();
	var shippingDate = $("#orderDetailShippingDate").val();

	$.ajax({
		url: localhost+"/orders/confirm_payment.json",
		type: "POST",
		data: {
			_method: "POST",
			"order[id]": orderID,
			"order[shipping_address]": shippingAddress,
			"order[shipping_method]": shippingMethod,
			"order[shipping_date]": shippingDate
		},
		success: function(returnData){
			alert(returnData.message)
				window.location.reload(true);
		},
		error: function(statusText, jqxHR, returnText){
			console.log(JSON.parse(statusText.responseText).errors)
		}
	})
}

function confirmDelivery(){
	var orderID = $("#orderItemOrderID").val();
	var shippingAddress = $("#orderDetailsShippingAddress").val();
	var shippingMethod = $("#orderDetailShippingMethod").val();
	var shippingDate = $("#orderDetailShippingDate").val();

	$.ajax({
		url: localhost+"/orders/confirm_delivery.json",
		type: "POST",
		data: {
			_method: "POST",
			"order[id]": orderID,
			"order[shipping_address]": shippingAddress,
			"order[shipping_method]": shippingMethod,
			"order[shipping_date]": shippingDate
		},
		success: function(returnData){
			alert(returnData.message)
			window.location.reload(true);
		},
		error: function(statusText, jqxHR, returnText){
			alert(JSON.parse(statusText.responseText).errors)
		}
	})
}

function saveOrderInformation(){
	var orderID = $("#orderItemOrderID").val();
	var shippingAddress = $("#orderDetailsShippingAddress").val();
	var shippingMethod = $("#orderDetailShippingMethod").val();
	var shippingDate = $("#orderDetailShippingDate").val();

	$.ajax({
		url: localhost+"/orders/"+orderID+".json",
		type: "POST",
		data: {
			_method: "PUT",
			"order[shipping_address]": shippingAddress,
			"order[shipping_method]": shippingMethod,
			"order[shipping_date]": shippingDate
		},
		success: function(returnData){
			window.location = localhost+"/orders"
		},
		error: function(statusText, jqxHR, returnText){			
			console.log(JSON.parse(statusText.responseText));
		}
	})
}

var delId = "";
function changeDeleteId(bikeRow){
	delId = $(bikeRow).parent().parent().find(".CustomerID").html() 	;
}

function deleteListOrder(){
	console.log(delId);
	var bikeID = delId;
	$.ajax({
		url: "", //ke PHP nya
			type: 'GET',
			data: {
				mode: '',//ini mode buat di php nya ton
				bikeID : bikeID
			},

			success: function (returnData) {
				alert("data berhasil di delete!");
				window.location.reload(true);

			},error: function (statusText, jqXHR, returnText) {
				console.log(statusText);
				console.log(jqXHR);
				console.log(returnText);
			}, complete: function (data) {

			}
	});
}
function showCustomer(element){
	$("#reviseData").css("display","block");
	$("#reviseCustomerID").val($(element).parent().parent().find(".customerID").html());
	$("#reviseCustomerName").val($(element).parent().parent().find(".customerName").html());
	$("#reviseOrderDate").val($(element).parent().parent().find(".orderDate").html());
	$("#reviseOrderTime").val($(element).parent().parent().find(".orderTime").html());
	$('reviseStatus').val($(element).parent().parent().find("input:checked").html()); //MASIH BLOM BENER TON
	$("#reviseData").append('<H2>NTAR DI EDIT LAGI TON</H2>');
	
}

$(document).ready(function() {
	$("#buttonReviseOrder").on('click',function(){
		var customerID = $('#reviseCustomerID').val();
		var customerName = $('#reviseCustomerName').val();
		var orderDate = $('#reviseOrderDate').val();    
		var orderTime = $('#reviseOrderTime').val();
		var status = $('').val(); //MASIH BELOM BENER TON
		$.ajax({
			url: "", //ke PHP nya
			type: 'GET',
			data: {
				mode: '',//ini mode buat di php nya ton buat else if nya tapi gak gw buatin phpnya yak
				customerID : customerID,
				customerName : customerName,
				orderDate : orderDate,
				orderTime : orderTime,
				status : status
			},
			success: function (returnData) {
				alert("data berhasil di input!");
				window.location.reload(true);

			},error: function (statusText, jqXHR, returnText) {
				console.log(statusText);
				console.log(jqXHR);
				console.log(returnText);
			}, complete: function (data) {

			}
		});
	});

});