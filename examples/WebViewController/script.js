$(document).ready(function(){ 

    $("a.js").click(
        function(e){ 
            e.preventDefault();
            alert("You clicked on a link that activates javascript"); 
        }
    );
              
                  
});

function objcMessage()
{
    var name = "empty";
    if( $("#username").val() != "" )
        name =  $("#username").val();
    window.location = "objc://message/" + name;
}

function processImage( img )
{
    $('#testImage').remove();
    $('#body').append( '<img id="testImage" src="' + img + '" />' );
}

var responseHandler = function (status, response) {
    var $form = $('#payment-info-form');
    $('#someHiddenDiv').hide();
    if (status != 201) {
        
        if (response.error && status != 400) {
            var error = response["error"];
            var errormsg = error["messages"];
            var errorcode = JSON.stringify(errormsg[0].code, null, 4);
            var errorMessages = JSON.stringify(errormsg[0].description, null, 4);
            $('#payment-errors').html( 'Error Code:' + errorcode + ', Error Messages:'
                                      + errorMessages);
           
        }
        if (status == 400 || status == 500) {
            $('#payment-errors').html('');
            var errormsg = response.Error.messages;
            var errorMessages = "";
            for(var i in errormsg){
                var ecode = errormsg[i].code;
                var eMessage = errormsg[i].description;
                errorMessages = errorMessages + 'Error Code:' + ecode + ', Error Messages:'
                + eMessage;
            }
            
            $('#payment-errors').html( errorMessages);
        }
        
        $form.find('button').prop('disabled', false);
    } else {
        $('#payment-errors').html('');
        var result = response.token.value;
        $('#response_msg').html('Payeezy response - Token value:' + result);
        $('#response_note')
        .html(
              " Note: Use this token for authorize and purchase transactions. For more details, visit https://developer.payeezy.com/payeezy-api-reference/apis ");
        $form.find('button').prop('disabled', false);
    }
    
};


function processPayment()  {
     
          $('#response_msg').html('');
          $('#response_note').html('');
          $('#payment-errors').html('');
          
          var $form = $(this);
          $form.find('button').prop('disabled', true);
          var apiKey = document.getElementById("apikey").value;
          var js_security_key = document.getElementById("js_security_key").value;
          
          Payeezy.setApiKey(apiKey);
          Payeezy.setJs_Security_Key(js_security_key);
          Payeezy.createToken(responseHandler);
          $('#someHiddenDiv').show();
          return false;
}












