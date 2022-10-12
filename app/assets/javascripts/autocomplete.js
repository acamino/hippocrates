Hippocrates.Autocomplete = {
  init: function() {
    var paths = {
      PATIENTS: '/api/patients',
      MEDICINES: '/api/medicines',
      DISEASES: '/api/diseases',
      USERS: '/api/users'
    };

    this.register(this.hasDiagnoses(), paths.DISEASES, { selector: '.disease', formatResult: this.formatDiseaseResult, onSelect: this.onSelectDiseases });
    this.register(this.hasPrescriptions(), paths.MEDICINES, { selector: '.inscription', formatResult: this.formatMedicineResult, onSelect: this.onSelectMedicines });
    this.register(this.patientsSearchEnabled(), paths.PATIENTS, { formatResult: this.formatPatientResult });
    this.register(this.medicinesSearchEnabled(), paths.MEDICINES, { formatResult: this.formatMedicineResult });
    this.register(this.diseasesSearchEnabled(), paths.DISEASES, { formatResult: this.formatDiseaseResult });
    this.register(this.usersSearchEnabled(), paths.USERS);
  },

  register: function(isEnabled, serviceUrl, opts = {}) {
    if (!isEnabled) {
      return;
    }

    var defaults = {
      selector: "#query",
      onSelect: function (object) {
        window.location.href = object.path;
      }
    };

    var options = $.extend({}, defaults, opts)

    $(options.selector).autocomplete({
      minChars: 2,
      serviceUrl: serviceUrl,
      formatResult: options.formatResult,
      onSelect: options.onSelect
    });
  },

  onSelectMedicines: function (medicine) {
    var locked = $(this).closest("tr").find(".locked").is(':checked');
    if (!locked) {
      $(this).closest("tr").find("textarea.subscription").val(medicine.data);
    }
  },

  onSelectDiseases: function (suggestion) {
    $(this).closest("tr").find("input.code").val(suggestion.data);
  },

  formatDiseaseResult: function(suggestion, currentValue) {
    if (!currentValue) { return suggestion.value; }

    var pattern = '(' + currentValue.replace(/[|\\{}()[\]^$+*?.]/g, "\\$&") + ')';

    var disease  = {
      name: Hippocrates.Autocomplete.sanitizeText(pattern, suggestion.value),
      code: Hippocrates.Autocomplete.sanitizeText(pattern, suggestion.data)
    };

    return Hippocrates.Templates.render("#tmpl-autocomplete-disease-suggestion", disease);
  },

  formatMedicineResult: function(suggestion, currentValue) {
    if (!currentValue) { return suggestion.value; }

    var pattern = '(' + currentValue.replace(/[|\\{}()[\]^$+*?.]/g, "\\$&") + ')';

    var medicine  = {
      name: Hippocrates.Autocomplete.sanitizeText(pattern, suggestion.value),
      instructions: Hippocrates.Autocomplete.sanitizeText(pattern, suggestion.data)
    };

    return Hippocrates.Templates.render("#tmpl-autocomplete-medicine-suggestion", medicine);
  },

  formatPatientResult: function(suggestion, currentValue) {
    if (!currentValue) { return suggestion.value; }

    var pattern = '(' + currentValue.replace(/[|\\{}()[\]^$+*?.]/g, "\\$&") + ')';

    var patient = {
        name: Hippocrates.Autocomplete.sanitizeText(pattern, suggestion.value),
        identityCardNumber: Hippocrates.Autocomplete.sanitizeText(pattern, suggestion.identityCardNumber),
        age: suggestion.age,
        isMale: suggestion.isMale
    };

    return Hippocrates.Templates.render("#tmpl-autocomplete-patient-suggestion", patient);
  },

  sanitizeText: function(pattern, text) {
    return text.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>')
               .replace(/&/g, '&amp;')
               .replace(/</g, '&lt;')
               .replace(/>/g, '&gt;')
               .replace(/"/g, '&quot;')
               .replace(/&lt;(\/?strong)&gt;/g, '<$1>');
  },

  patientsSearchEnabled: function() {
    return this.hasQuery() && _.any([this.isPatientsPath(),this.isRootPath()]);
  },

  medicinesSearchEnabled: function() {
    return this.hasQuery() && this.isMedicinesPath();
  },

  diseasesSearchEnabled: function() {
    return this.hasQuery() && this.isDiseasesPath();
  },

  usersSearchEnabled: function() {
    return this.hasQuery() && this.isUsersPath();
  },

  pathname: function() {
    return window.location.pathname;
  },

  hasQuery: function() {
    return $('#query').length > 0;
  },

  hasPrescriptions: function() {
    return $('.prescriptions').length > 0;
  },

  hasDiagnoses: function() {
    return $('.diagnoses').length > 0;
  },


  isRootPath: function() {
    return this.pathname() == '/'
  },

  isPatientsPath: function() {
    return this.pathname() == '/patients'
  },

  isMedicinesPath: function() {
    return this.pathname() == '/medicines'
  },

  isDiseasesPath: function() {
    return this.pathname() == '/diseases'
  },

  isUsersPath: function() {
    return this.pathname() == '/admin/users'
  }
};
