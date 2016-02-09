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


 $.oauthpopup = function(options)
 {
     options.windowName = options.windowName ||  'ConnectWithOAuth'; // should not include space for IE
     options.windowOptions = options.windowOptions || 'location=0,status=0,width=800,height=400';
     options.callback = options.callback || function(){ window.location.reload(); };
     var that = this;
     console.log(options.path);
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