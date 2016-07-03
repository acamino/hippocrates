Hippocrates.Prescription = {
  config: {
    prescriptionTmpl: "#prescription-tmpl",
    printablePrescription: "#printable-prescription",
    printLink: "#print"
  },

  init: function() {
    self = this;

    $(self.config.printLink).on("click", function(e) {
      e.preventDefault();
      self.print();
    });
  },

  print: function() {
    self = this;

    var prescription = self.renderTemplate(
      self.config.prescriptionTmpl, self.getPrescriptions());

    $(self.config.printablePrescription).html(prescription);
    $(self.config.printablePrescription).print();
  },

  renderTemplate: function (target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  getPrescriptions: function() {
    self = this;

    var prescriptions = _.filter(
      _.map($('.prescriptions tbody tr'), function(item) {
      return {
        inscription: $(item).find('td:first-child input').val(),
        subscription: self.formatSubscription($(item).find('td:last-child input').val())
      };
    }), self.isPrescriptionAvailable);

    return {
      currentDate: self.getCurrentDate(),
      patientName: self.getPatientName(),
      hasPrescriptions: prescriptions.length != 0,
      prescriptions: prescriptions,
      nextAppointment: self.getNextAppointment()
    }
  },

  formatSubscription: function(subscription) {
    var components = subscription.split(":");
    if (components.length === 2) {
      var medicineName = components[0];
      var instructions = components[1];

      return "<strong>" + medicineName + "</strong>: " + instructions;
    }

    return subscription;
  },

  isPrescriptionAvailable: function(prescription) {
    return prescription.inscription && prescription.inscription.length != 0;
  },

  getPatientName: function() {
    return $("#patient_last_name").val() + " " + $("#patient_first_name").val();
  },

  getCurrentDate: function() {
    return $("#current_date").val();
  },

  getNextAppointment: function() {
    return $("#consultation_next_appointment").val();
  }
};
