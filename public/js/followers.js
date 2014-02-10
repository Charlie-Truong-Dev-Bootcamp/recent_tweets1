$(document).ready(function() {

  if ($("#loader").length > 0){
    var name = $("#loader").data("username")
    $.post("/get_followers",{username: name},function(response){
      $("#loader").remove();
      $(".container").append(response);
    });
  }
});
