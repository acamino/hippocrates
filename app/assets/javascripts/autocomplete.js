Hippocrates.Autocomplete = {
  init: function() {
    if ($('.diagnoses').length > 0) {
      $.get("/api/diseases").done(function(suggestions) {
        $(".disease").autocomplete({
          lookup: suggestions,
          onSelect: function (suggestion) {
            $(this).closest("tr").find("input.code").val(suggestion.data);
          }
        });
      });
    }

    if ($('.prescriptions').length > 0) {
      $.get("/api/medicines").done(function(medicines) {
        $(".inscription").autocomplete({
          lookup: medicines,
          onSelect: function (medicine) {
            var locked = $(this).closest("tr").find(".locked").is(':checked');
            if (!locked) {
              $(this).closest("tr").find("input.subscription").val(medicine.data);
            }
          }
        });
      });
    }

    if (this.patientSearchEnabled()) {
      $("#query").autocomplete({
        minChars: 3,
        serviceUrl: "api/patients",
        onSelect: function (patient) {
          window.location.href = patient.path;
        }
      });
    }
  },

  patientSearchEnabled: function() {
    var hasQuery = $('#query').length > 0
    return hasQuery && (this.isPatientsPath() || this.isRootPath());
  },

  isPatientsPath: function() {
    return this.pathname() == '/patients'
  },

  isRootPath: function() {
    return this.pathname() == '/'
  },

  pathname: function() {
    return window.location.pathname;
  }
};
