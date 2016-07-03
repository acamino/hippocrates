Hippocrates.Prescription = {
  config: {
    prescriptionTmpl: "#prescription-tmpl",
    printablePrescription: "#printable-prescription",
    printLink: "#print"
  },

  init: function() {
    var self = this;

    $(self.config.printLink).on("click", function(e) {
      e.preventDefault();
      self.print();
    });
  },

  print: function() {
    var prescription = this.renderTemplate(
      this.config.prescriptionTmpl, this.getPrescription());

    $(this.config.printablePrescription).html(prescription);
    $(this.config.printablePrescription).print();
  },

  renderTemplate: function (target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  getPrescription: function() {
    var prescriptions = this.getPrescriptions();

    return {
      currentDate: this.getCurrentDate(),
      patientName: this.getPatientName(),
      hasPrescriptions: prescriptions.length != 0,
      prescriptions: prescriptions,
      nextAppointment: this.getNextAppointment()
    }
  },

  getPrescriptions: function() {
    var self = this;

    return _.filter(
      _.map($('.prescriptions tbody tr'), function(item) {
      return {
        inscription: $(item).find('td:first-child input').val(),
        subscription: self.formatSubscription($(item).find('td:last-child input').val())
      };
    }), self.isPrescriptionAvailable);
  },

  formatSubscription: function(subscription) {
    var components = subscription.split(":");
    if (components.length === 2) {
      var medicineName = components[0];
      var instructions = components[1];

      return `<strong>${medicineName}</strong> ${instructions}`;
    }

    return subscription;
  },

  isPrescriptionAvailable: function(prescription) {
    return prescription.inscription && prescription.inscription.length != 0;
  },

  getPatientName: function() {
    return `${$("#patient_last_name").val()} ${$("#patient_first_name").val()}`;
  },

  getCurrentDate: function() {
    return $("#current_date").val();
  },

  getNextAppointment: function() {
    return $("#consultation_next_appointment").val();
  }
};
