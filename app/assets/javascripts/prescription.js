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

    $(".show-prescription").on("click", function(e) {
      e.preventDefault();
      self.openPrescriptionModal();
    });

    $(".show-empty-prescription").on("click", function(e) {
      e.preventDefault();
      self.openEmptyPrescriptionModal();
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
        inscription: $(item).find('textarea').eq(0).val().toUpperCase(),
        subscription: self.formatSubscription($(item).find('textarea').eq(1).val())
      };
    }), self.isPrescriptionAvailable);
  },

  formatSubscription: function(subscription) {
    var components = subscription.split(":");
    if (components.length === 2) {
      var medicineName = components[0];
      var instructions = components[1];

      return [
        "<strong>",
        medicineName.toUpperCase(),
        "</strong>: ",
        instructions.toUpperCase()
      ].join('');
    }

    return subscription.toUpperCase();
  },

  isPrescriptionAvailable: function(prescription) {
    var hasInscription = prescription.inscription && prescription.inscription.length != 0,
        hasSubscription = prescription.subscription && prescription.subscription.length != 0;

    return hasInscription || hasSubscription;
  },

  getPatientName: function() {
    return $("#patient_last_name").val() + " " + $("#patient_first_name").val();
  },

  getCurrentDate: function() {
    return $("#current_date").val();
  },

  getNextAppointment: function() {
    return $("#consultation_next_appointment").val();
  },

  openPrescriptionModal: function() {
    $("#prescription").modal({ backdrop: "static" });
  },

  openEmptyPrescriptionModal: function() {
    $("#empty-prescription").modal({ backdrop: "static" });
  },
};
