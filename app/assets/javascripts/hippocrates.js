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

    var calculateAge = function(birthday, today) {
        var diffMilliseconds = today - birthday.getTime();
        var millisecondsFromEpoc = new Date(diffMilliseconds);

        return Math.abs(millisecondsFromEpoc.getUTCFullYear() - 1970);
    }
});
