Hippocrates.Hint = {
  init: function() {
    keyboardJS.bind('ctrl + s', function(e) {
      $(".hint-box").toggleClass("hint-box-show");
    });

    $(".progress, .progress-hint").click(function (){
      $(".progress-hint").slideToggle();
    });

    $(".compress, .expand").on("click", function(e) {
      e.preventDefault();
      $('.panel-body').slideToggle("slow");
      $('.zip').toggle();
    });

    $(".hint-icon, .hint-title").click(function (){
      $(".hint-box").toggleClass("hint-box-show");
    });

    $("#consultation_temperature").on("keyup", function() {
      $("#temperature").html($(this).val() + " °C");
    });

    $("#consultation_blood_pressure").on("keyup", function() {
      $("#blood_pressure").html($(this).val() + " mmHg");
    });

    $("#consultation_weight").on("keyup", function() {
      $("#weight").html($(this).val() + " Kg");
    });
  }
};
