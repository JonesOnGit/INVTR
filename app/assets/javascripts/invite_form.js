var invited = [];


String.prototype.toProperCase = function(){
    return this.toLowerCase().replace(/(^[a-z]| [a-z]|-[a-z])/g, 
         function($1){
            return $1.toUpperCase();
        }
    );
};

function auth() {
  var config = {
    'client_id': '832245431959-4qt4jj9euf22pd3d6tdsqknrdd32nuem.apps.googleusercontent.com',
    'scope': 'https://www.google.com/m8/feeds'
  };
  gapi.auth.authorize(config, function() {
    var token = gapi.auth.getToken();
    token['g-oauth-window'] = null;
    fetchGoogleContacts(token);
  });
}

var contacts = "";
var owner = "";
var ownerName = "";
function fetchGoogleContacts(token) {
  $.ajax({
    url: 'https://www.google.com/m8/feeds/contacts/default/full?alt=json&max-results=1000',
    dataType: 'jsonp',
    data: token
  }).done(function(data) {
    owner = data["feed"]["author"][0]["email"]["$t"];
    ownerName = data["feed"]["author"][0]["name"]["$t"];
    populateContacts(data);
  });
}

function populateContacts(data) {
  var arr = new Array();
  var nameArr = new Array();
  var nameObj = {};
  var errCount = 0;
  var errArr = [];
  var d = data["feed"]["entry"];
  contacts = d;
  $.each(d, function(i, obj) {

    try {
      var email = obj["gd$email"][0]["address"].toLowerCase();
      var name = obj["title"]["$t"];

      arr.push(email);
      if (name != "") {
        nameArr.push(name.toProperCase());
        nameObj[name] = email;
      }
      
    } catch(err) {
      if ($.inArray(err.message, errArr) == -1)  {
        errArr.push(err.message)
      } 
      errCount += 1;
    }
  });
  arr.sort();
  nameArr.sort()
  var count = 0;
  for (var i in arr) {
    count++
    if (count > -1) {
      if (typeof name != 'undefined' && typeof nameObj[nameArr[i]] != 'undefined') {
        var imageUrl = nameObj[nameObj[nameArr[i]]];

        var uri = '/assets/blank-avatar.gif';
  
        var elem = "#" + i

        $("#myModal2-table-body").append("<tr>");

        $("#myModal2-table-body").append("<td>");

        if ($.inArray(nameObj[nameArr[i]], invited) > -1) {
          $("#myModal2-table-body").append("<input class='emailCheckbox' type=checkbox name='" + nameObj[nameArr[i]] + "'' id='" + nameObj[nameArr[i]] + "' value='" + nameArr[i] + "' checked/><label class='emailCheckboxLabel' for='" + nameObj[nameArr[i]] + "'></label>");
          $("#myModal2-table-body").append("</td>");
          $("#myModal2-table-body").append("<td>");

          $("#myModal2-table-body").append("  <b>" + nameArr[i] + "<b>  ");
          $("#myModal2-table-body").append("<br/>");

          $("#myModal2-table-body").append(nameObj[nameArr[i]]);
          
          $("#myModal2-table-body").append("</td>");
          $("#myModal2-table-body").append("</tr>");
        } else {
          $("#myModal2-table-body").append("<br class='half-line'/><input class='emailCheckbox' type=checkbox name='" + nameObj[nameArr[i]] + "'' id='" + nameObj[nameArr[i]] + "' value='" + nameArr[i] + "'/><label class='emailCheckboxLabel' for='" + nameObj[nameArr[i]] + "'></label>");
          $("#myModal2-table-body").append("</td>");
          $("#myModal2-table-body").append("<td class='lower'>");

          $("#myModal2-table-body").append("<b style='margin-top: 100em;'>" + nameArr[i] + "<b> ");
          $("#myModal2-table-body").append("<br/>");

          $("#myModal2-table-body").append(nameObj[nameArr[i]]);
          
          $("#myModal2-table-body").append("</td>");
          $("#myModal2-table-body").append("</tr>");
        }


      }
    }


  
  }
}

function populateSearch(d, guests) {
  var arr = new Array();
  var nameArr = new Array();
  var nameObj = {};
  var d = contacts;
  count = 0;
  $.each(d, function(i, obj) {

    try {
      var email = obj["gd$email"][0]["address"].toLowerCase();
      var name = obj["title"]["$t"];
      if (guests.indexOf(name) != -1){
        count += 1;
        arr.push(email);
        if (name != "") {
          nameArr.push(name.toProperCase());
          nameObj[name] = email;
        }
      }
      
    } catch(err) {

    }
  });
  nameArr.sort()
  $("#myModal2-table-body").empty();

  var count = 0;
  for (var i in arr) {
    count++
    if (count > -1) {
      if (typeof name != 'undefined' && typeof nameObj[nameArr[i]] != 'undefined') {

        var imageUrl = nameObj[nameObj[nameArr[i]]];

        var uri = '/assets/blank-avatar.gif';
  
        var elem = "#" + i

        $("#myModal2-table-body").append("<tr>");

        $("#myModal2-table-body").append("<td>");

        if ($.inArray(nameObj[nameArr[i]], invited) > -1) {

         $("#myModal2-table-body").append("<input class='emailCheckbox' type=checkbox name='" + nameObj[nameArr[i]] + "'' id='" + nameObj[nameArr[i]] + "' value='" + nameArr[i] + "' checked/><label for='" + nameObj[nameArr[i]] + "'></label>");
       } else {
        $("#myModal2-table-body").append("<input class='emailCheckbox' type=checkbox name='" + nameObj[nameArr[i]] + "'' id='" + nameObj[nameArr[i]] + "' value='" + nameArr[i] + "'/><label for='" + nameObj[nameArr[i]] + "'></label>");
       }
        $("#myModal2-table-body").append("</td>");
        $("#myModal2-table-body").append("<td class='full-width'>");

        $("#myModal2-table-body").append("  <b>" + nameArr[i] + "<b>  ");
        $("#myModal2-table-body").append("<br/>");

        $("#myModal2-table-body").append(nameObj[nameArr[i]]);
      
        $("#myModal2-table-body").append("</td>");
        $("#myModal2-table-body").append("<tr>");

      }
    }


  
  }


}

 function readURL(input) {
         if (input.files && input.files[0]) {
             var reader = new FileReader();

             reader.onload = function (e) {
                 $('image-section')
                     .attr('src', e.target.result)
                     .width(150)
                     .height(200);
             };
             reader.readAsDataURL(input.files[0]);
         }
     }

     function initMap() {

       var input = /** @type {!HTMLInputElement} */(
           document.getElementById('invite_address'));

       var types = document.getElementById('type-selector');
       var autocomplete = new google.maps.places.Autocomplete(input);
      

       autocomplete.addListener('place_changed', function() {
         infowindow.close();
         marker.setVisible(false);
         var place = autocomplete.getPlace();
         alert(place);
       });
     }

 $(function() {
    $("input:file").change(function (){
      var fileName = $(this).val();
      // readURL(this);

      var img = document.createElement("img");
              var reader = new FileReader();
              reader.onloadend = function() {
                   img.src = reader.result;
                   img.id = "test";
              }
              reader.readAsDataURL(this.files[0]);
              $("#image-section").empty();
              $("#image-section").css("background", "white");
              $("#image-section").append(img);
      
    });

    $("#image-section").click(function() {
     $(".file-upload").click();
    })

    $("#submit_button").hide();

    $("#datepicker").click(function() {
      $("#datepicker").fdatepicker('show')
    });

    $("#end_datepicker").click(function() {
      $("#end_datepicker").fdatepicker('show')
    });

     //Authorization popup window code
     $.oauthpopup = function(options)
     {
         options.windowName = options.windowName ||  'ConnectWithOAuth'; // should not include space for IE
         options.windowOptions = options.windowOptions || 'location=0,status=0,width=800,height=400';
         options.callback = options.callback || function(){ window.location.reload(); };
         var that = this;
         that._oauthWindow = window.open(options.path, options.windowName, options.windowOptions);
         that._oauthInterval = window.setInterval(function(){
             if (that._oauthWindow.closed) {
                 window.clearInterval(that._oauthInterval);
                 options.callback();
             }
         }, 1000);
     };
    $(function() {
       $("#googleLogin").click(function() {
         document.cookie = "oauth_provider=google";
       });
    });
     function addCookie(cname, value) {
      document.cookie= cname + "=" + value;

     }

     function delete_cookie( name ) {
       document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
     }

     $("#choose_contacts_button").click(function() {
       // form id
       // var id = "new_invite";
       // var errors_list = [];

       // $("#" + id + " :input").map(function(){
       //     if( !$(this).val() ) {
       //       errors_list.push($(this).attr("data-error-message"));
       //     }
       // });

       // if(errors_list.length > 0){
       //     $("#reveal-errors").text(errors_list.join(", "));
       //     $('#validation-errors').foundation('reveal', 'open');

       // } else {
         // action to be performed if form is completely filled
         $('#myModal').foundation('reveal', 'open');
       // }
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

     $("#invite_avatar").hide();


     

       $('body').delegate('#search-autocomplete', 'keyup', function() {
         var searchInput = $("#search-autocomplete").val();

         // for each contact
         // look in contact.title.$t
         // if the first X characters in contact name = searchInput, add into a 'guests' array.
         // populate table with that array
         guests = [];
         for (var i = 0; i < contacts.length; i++) {
           if (contacts[i]["title"]["$t"].toLowerCase().indexOf(searchInput.toLowerCase()) == 0) {
             guests.push(contacts[i]["title"]["$t"]);
           }
         }
         populateSearch(contacts, guests);
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