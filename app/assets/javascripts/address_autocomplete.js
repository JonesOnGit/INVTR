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