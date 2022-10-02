if(typeof Hippocrates === "undefined") {
  var Hippocrates = {};
  Hippocrates.Autocomplete = {};
  Hippocrates.Certificates = {};
  Hippocrates.ClinicalHistory = {};
  Hippocrates.Consultations = {};
  Hippocrates.Consents = {};
  Hippocrates.ChangePrice = {};
  Hippocrates.Charges = {};
  Hippocrates.Hint = {};
  Hippocrates.Prescription = {};
  Hippocrates.Settings = {};
}

$(document).on('turbolinks:load', function() {
    Hippocrates.Autocomplete.init();
    Hippocrates.Certificates.init();
    Hippocrates.Consents.init();
    Hippocrates.ChangePrice.init();
    Hippocrates.Charges.init();
    Hippocrates.ClinicalHistory.init();
    Hippocrates.Consultations.init();
    Hippocrates.Hint.init();
    Hippocrates.Prescription.init();
    Hippocrates.Settings.init();

    var date = new Date();
    date.setDate(date.getDate() - 1);

    keyboardJS.bind('ctrl + g', function(e) {
      $('.hippocrates--save').click();
    });

    $("#consultation_next_appointment").datepicker({
        startDate: date,
        todayHighlight: true,
        format: "yyyy-mm-dd",
        language: "es",
        calendarWeeks: true,
        autoclose: true
    });

    $("#consultation_created_at").datepicker({
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

    $("#date_range").daterangepicker({
        autoApply: true,
        locale: {
            daysOfWeek: [
                'Do',
                'Lu',
                'Ma',
                'Mi',
                'Ju',
                'Vi',
                'Sa'
            ],
            monthNames: [
                'Enero',
                'Febrero',
                'Marzo',
                'Abril',
                'Mayo',
                'Junio',
                'Julio',
                'Agosto',
                'Septiembre',
                'Octubre',
                'Noviembre',
                'Diciembre'
            ],
            firstDay: 1,
            format: 'YYYY-MM-DD'
        }
    });

    if ($("#changed_price").length) {
      new Cleave('#consultation_price', {
        numeral: true,
        numeralThousandsGroupStyle: 'thousand'
      });
    }

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
