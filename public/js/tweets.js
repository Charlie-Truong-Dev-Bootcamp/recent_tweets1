$(document).ready(function() {

  if ($("#loader").length > 0){
    var name = $("#loader").data("username")
    $.post("/pull_new_tweets",{username: name},function(response){
      $("#loader").remove();
      $(".container").append(response);
    });
  }
});
