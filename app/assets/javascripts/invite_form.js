 $(function() {

    $("#submit_button").hide();

    $("#datepicker").click(function() {
      $("#datepicker").fdatepicker('show')
    });

    $("#end_datepicker").click(function() {
      $("#end_datepicker").fdatepicker('show')
    });

     //Authorization popup window code

     function addCookie(cname, value) {
      document.cookie= cname + "=" + value;

     }

     function delete_cookie( name ) {
       document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
     }

     $("#choose_contacts_button").click(function() {
       // form id
       var id = "new_invite";
       var errors_list = [];

       $("#" + id + " :input").map(function(){
           if( !$(this).val() ) {
             errors_list.push($(this).attr("data-error-message"));
           }
       });

       if(errors_list.length > 0){
           $("#reveal-errors").text(errors_list.join(", "));
           $('#validation-errors').foundation('reveal', 'open');

       } else {
         // action to be performed if form is completely filled
         $('#myModal').foundation('reveal', 'open');
       }
     })

     var lastStartHour = "";
     $('#invite_start_hour').on('input',function(e){
         if ($("#invite_start_hour").val() == "") {
           $("invite_start_hour").val("")
           lastStartHour = "";

         } else {
           try {
             var value = $("#invite_start_hour").val().replace(/\D/g, '' )

             var startInt = parseInt(value);
             if (startInt <= 13) {
               lastStartHour = value;
               $("#invite_start_hour").val(lastStartHour);
             } else {
               $("#invite_start_hour").val(lastStartHour);
             }
           } catch(err) {
             $("#invite_start_hour").val(lastStartHour);
           }
         }
      });

     var lastStartHour = "";
     $('#invite_end_hour').on('input',function(e){
         if ($("#invite_end_hour").val() == "") {
           $("invite_end_hour").val("")
           lastStartHour = "";

         } else {
           try {
             var value = $("#invite_end_hour").val().replace(/\D/g, '' )

             var startInt = parseInt(value);
             if (startInt <= 13) {
               lastStartHour = value;
               $("#invite_end_hour").val(lastStartHour);
             } else {
               $("#invite_end_hour").val(lastStartHour);
             }
           } catch(err) {
             $("#invite_end_hour").val(lastStartHour);
           }
         }
      });
     $("#send-emails-button").click(function() {
       var emails = $("#emails").val();
       var myEmail = $("#my-email").val();
       var incomplete = [];
       if (emails == "") {
         incomplete.push("emails");
       }

       if (myEmail == "") {
         incomplete.push("my email");
      }

       if (incomplete.length > 0) {
         $("#error-message").text("*Fill in both fields to proceed.")
       } else {
         var emailsString = $("#emails").val();
         var invites = emailsString.match(/,/g) || [];
         var len = invites.length + 1
         if (len == 1) {
           $("#submit_button").text("SEND TO 1 INVITE");
         } else {
           $("#submit_button").text("SEND TO " + len + " INVITES");
         }
         $("#submit_button").show()
         $("#submit_button").addClass("form_submit");
         var emails = emailsString.replace(/,/g, '');
         document.cookie = "invited=" + emails;
         document.cookie = "oauth_provider=none"
         document.cookie = "ownerEmail=" + $("#my-email").val();
         $('#myModal').foundation('reveal', 'close');
       }
     });




     $('body').delegate('#continue-button', 'click', function() {
         $('#myModal').foundation('reveal', 'close');
         var invitedString = invited.toString().replace(/,/g, " ");
         var newCookie = 'invited=' + invitedString + ';'
         var ownerCookie = "ownerEmail=" + owner;
         var ownerNameCookie = "ownerName=" + ownerName;
         document.cookie = newCookie;
         document.cookie = ownerCookie;
         document.cookie = ownerEmail;
     });

     $('body').delegate('.form_submit', 'click', function() {
       $('#myModal').foundation('reveal', 'close');
       $('form').submit();

     });


     var count = 0;

     var checked = 0;
     $('body').delegate('.emailCheckbox', 'click', function() {
         // add to cookie



         if(this.checked == true) {
           checked += 1;
           if (invited.indexOf(this.name) == -1) {
             invited.push(this.name)
           }

         } else {
           checked += -1;
           if (invited.indexOf(this.name) != -1) {
             invited.pop(this.name)
           }

         }
         

         if (checked == 1) {
           $("#submit_button").text("Send to 1 invite");
         } else if (checked == 0) {

           $("#submit_button").text("Send");
         } else {

           // $("#continue-button").text("Send to " + checked + " invites");
         }     
         $("#submit_button").text("Send to " + checked + " invites");


         if (checked == 0) {
           $("#submit_button").hide();

         } else {
               $("#submit_button").addClass("form_submit");
         $("#submit_button").removeAttr("data-reveal-id");
         $("#submit_button").show();
         }

     });
$('#check-email').foundation('reveal','open');
$("#close-button").click(function() {
  $('#check-email').foundation('reveal','close');

})
 });