

var invited = [];

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
        $("#myModal2-table-body").append("<td>");

        $("#myModal2-table-body").append("  <b>" + nameArr[i] + "<b>  ");
        $("#myModal2-table-body").append("<br/>");

        $("#myModal2-table-body").append(nameObj[nameArr[i]]);
      
        $("#myModal2-table-body").append("</td>");
        $("#myModal2-table-body").append("<tr>");

      }
    }
  }
}

$(function() {

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
	});       $('body').delegate('#search-autocomplete', 'keyup', function() {
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
});
