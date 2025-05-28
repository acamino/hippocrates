Hippocrates.DataConsent = (function() {
  var init = function() {
    // Intercept form submission for consultations
    $('form').on('submit', function(e) {
      var isConsultationForm = $(this).attr('action') && $(this).attr('action').includes('/consultations');

      if (isConsultationForm) {
        var hasDataConsentWarning = $('#data-consent-warning').length > 0;

        if (hasDataConsentWarning) {
          e.preventDefault();
          showConsentError();
          return false;
        }
      }
    });

    // Also intercept the save button click (for keyboard shortcut compatibility)
    $('.hippocrates--save').on('click', function(e) {
      var form = $(this).closest('form');
      var isConsultationForm = form.attr('action') && form.attr('action').includes('/consultations');

      if (isConsultationForm) {
        var hasDataConsentWarning = $('#data-consent-warning').length > 0;

        if (hasDataConsentWarning) {
          e.preventDefault();
          showConsentError();
          return false;
        }
      }
    });
  };

  var showConsentError = function() {
    // Show alert with message
    alert('No se puede guardar la consulta sin el consentimiento de manejo de datos del paciente.\n\nPor favor, edite los datos del paciente para otorgar el consentimiento.');

    // Highlight the warning
    $('#data-consent-warning').addClass('pulse-warning');
    setTimeout(function() {
      $('#data-consent-warning').removeClass('pulse-warning');
    }, 2000);
  };

  return {
    init: init
  };
})();
