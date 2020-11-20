if(typeof Hippocrates === "undefined") {
  var Hippocrates = {};
  Hippocrates.Autocomplete = {};
  Hippocrates.Certificates = {};
  Hippocrates.ClinicalHistory = {};
  Hippocrates.Consultations = {};
  Hippocrates.Hint = {};
  Hippocrates.Prescription = {};
  Hippocrates.Settings = {};
}

$(document).on('turbolinks:load', function() {
    Hippocrates.Autocomplete.init();
    Hippocrates.Certificates.init();
    Hippocrates.ClinicalHistory.init();
    Hippocrates.Consultations.init();
    Hippocrates.Hint.init();
    Hippocrates.Prescription.init();
    Hippocrates.Settings.init();

    var date = new Date();
    date.setDate(date.getDate() - 1);

    $("#consultation_next_appointment").datepicker({
        startDate: date,
        todayHighlight: true,
        format: "yyyy-mm-dd",
        language: "es",
        calendarWeeks: true,
        autoclose: true
    });

    $("#consultation_created_at").datepicker({
        // startDate: date,
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
