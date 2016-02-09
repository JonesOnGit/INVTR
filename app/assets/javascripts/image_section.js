
function readURL(input) {
     if (input.files && input.files[0]) {
         var reader = new FileReader();

         reader.onload = function (e) {
          console.log(e.target.result);
             $('image-section')
                 .attr('src', e.target.result)
                 .width(150)
                 .height(200);
         };
         console.log(input.files[0]);
         reader.readAsDataURL(input.files[0]);
     }
 }

 $(function() {
 	$("#invite_avatar").hide();

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
 });