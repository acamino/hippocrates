if(typeof Hippocrates === "undefined") {
  var Hippocrates = {};
  Hippocrates.Autocomplete = {};
  Hippocrates.Consultations = {};
  Hippocrates.Hint = {}
}

$(document).ready(function() {
    Hippocrates.Autocomplete.init();
    Hippocrates.Consultations.init();
    Hippocrates.Hint.init();

    $("#consultation_next_appointment").datepicker({
        todayHighlight: true,
        format: "yyyy-mm-dd",
        language: "es",
        calendarWeeks: true,
        autoclose: true
    });

    $("#patient_birthdate").datepicker({
        startView: 3,
        format: "yyyy-mm-dd",
        language: "es",
        calendarWeeks: true,
        autoclose: true
    }).on("changeDate", function(e) {
        var birthday = e.date;
        var today = Date.now();
        var patientAge = calculateAge(birthday, today);

        $(".patient-age").val(patientAge);
    });

    $(".panel-heading").on("click", function(e) {
        var panelBody = $(this).siblings();
        panelBody.slideToggle("slow");
    });

    var calculateAge = function(birthday, today) {
        var diffMilliseconds = today - birthday.getTime();
        var millisecondsFromEpoc = new Date(diffMilliseconds);

        return Math.abs(millisecondsFromEpoc.getUTCFullYear() - 1970);
    };

    // XXX: Move this presentation logic to a presenter.
    var patientBirthdate = $("#patient_birthdate").val();
    if (patientBirthdate) {
        var birthday = new Date(patientBirthdate);
        var today = Date.now();
        var patientAge = calculateAge(birthday, today);

        $(".patient-age").val(patientAge);
    }
});
