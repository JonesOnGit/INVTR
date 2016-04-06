 function initMap() {
   var input = document.getElementById('invite_address');
   var types = document.getElementById('type-selector');
   if (input) {
    var autocomplete = new google.maps.places.Autocomplete(input);
    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();
    });
   };
 }
