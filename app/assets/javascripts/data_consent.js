Hippocrates.DataConsent = (function() {
  var init = function() {
    $('#data-consent-checkbox').on('change', function() {
      var consent = $(this).is(':checked');
      var patientId = $('#data-consent-container').data('patient-id');

      $.ajax({
        url: '/api/patients/' + patientId + '/consent',
        method: 'PATCH',
        data: { consent: consent },
        success: function() {
          updateConsentUI(consent);
        },
        error: function() {
          $('#data-consent-checkbox').prop('checked', !consent);
          alert('Error al actualizar el consentimiento.');
        }
      });
    });

    $('form').on('submit', function(e) {
      var isConsultationForm = $(this).attr('action') &&
                               $(this).attr('action').includes('/consultations');

      if (isConsultationForm && !$('#data-consent-checkbox').is(':checked')) {
        e.preventDefault();

        $('html, body').animate({
          scrollTop: $('#data-consent-container').offset().top - 120
        }, 300, function() {
          $('#data-consent-status').addClass('pulse-warning');
          setTimeout(function() {
            $('#data-consent-status').removeClass('pulse-warning');
          }, 3000);
        });

        return false;
      }
    });
  };

  var updateConsentUI = function(consent) {
    var $status = $('#data-consent-status');

    if (consent) {
      $status.removeClass('alert-danger')
             .addClass('alert-success')
             .html(
               '<i class="fa fa-check-circle"></i> ' +
               '<strong>Consentimiento otorgado:</strong> ' +
               'El paciente ha autorizado el manejo de sus datos personales.'
             );
    } else {
      $status.removeClass('alert-success')
             .addClass('alert-danger')
             .html(
               '<i class="fa fa-exclamation-triangle"></i> ' +
               '<strong>Consentimiento requerido:</strong> ' +
               'El paciente debe autorizar el manejo de datos antes de guardar la consulta.'
             );
    }
  };

  return {
    init: init
  };
})();
