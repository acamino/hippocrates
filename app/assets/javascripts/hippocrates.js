$(document).ready(function() {
    $('#patient_birthdate').datepicker({
        format: "yyyy-mm-dd",
        language: "es",
        calendarWeeks: true,
        autoclose: true
    }).on('changeDate', function(e) {
        var birthday = e.date;
        var today = Date.now();
        var patientAge = calculateAge(birthday, today);

        $('.patient-age').val(patientAge);
    });

    $('.panel-heading').on('click', function(e) {
        var panelBody = $(this).siblings();
        panelBody.toggle('drop');
    });

    $.get('/api/diseases').done(function(suggestions) {
      $('.disease').autocomplete({
        lookup: suggestions,
        onSelect: function (suggestion) {
          $(this).closest('tr').find('input.code').val(suggestion.data);
        }
      });
    });

    var calculateAge = function(birthday, today) {
        var diffMilliseconds = today - birthday.getTime();
        var millisecondsFromEpoc = new Date(diffMilliseconds);

        return Math.abs(millisecondsFromEpoc.getUTCFullYear() - 1970);
    }

    // XXX: Move this presentation logic to a presenter.
    var patientBirthdate = $('#patient_birthdate').val();
    if (patientBirthdate) {
        var birthday = new Date(patientBirthdate)
        var today = Date.now();
        var patientAge = calculateAge(birthday, today);

        $('.patient-age').val(patientAge);
    }
});
