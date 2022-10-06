Hippocrates.PaymentChanges = {
  init: function() {
    var self = this;
    $(".show-payment-change").on("click", function(e) {
      $('#payment_change_type').val($(this).data('type'));
      e.preventDefault();
      self.openModal();
    });

    if ($("#updated-payment").length) {
      new Cleave('#updated-payment', {
        numeral: true,
        numeralThousandsGroupStyle: 'thousand'
      });
    }

    $("#save-payment").on("click", function(e) {
      self.savePayment();
      return false;
    });

    self.initControls();
  },

  openModal: function() {
    this.initControls();
    $("#change-payment").modal({ backdrop: "static" });
  },

  renderTemplate: function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  savePayment: function() {
    var self = this;

    var path = "/api/consultations/" + self.consultationId() + "/payment_changes";
    var updatedPayment = $("#updated-payment").val();
    var reason = $("#updated-payment-reason").val();

    var data = {
      change_payment: {
        previous_payment: this.previousPayment(),
        updated_payment: updatedPayment,
        reason: reason,
        type: self.changePaymentType()
      }
    };

    $.post(path, data)
      .done(function(result) {
        var payment = self.formatPayment(updatedPayment);
        self.refreshControls(payment);
        $("#change-payment").modal('hide');
      })
      .fail(function(result) {
        $("#change-payment__errors").show();
        var errors = self.renderTemplate("#tmpl-payment-change-errors", { errors: result.responseJSON.errors });
        $("#change-payment__errors--body").html(errors);
      });
  },

  isPaid: function() {
    return $('#payment_change_type').val() == 'paid';
  },

  changePaymentType: function() {
    return $('#payment_change_type').val();
  },

  consultationId: function() {
    return $("#consultation_id").val();
  },

  previousPayment: function() {
    return this.isPaid() ? $("#consultation_payment").val() : $("#consultation_pending_payment").val();
  },

  initControls: function() {
    $("#change-payment__errors").hide()
    $("#updated-payment").val(this.previousPayment());
    $("#updated-payment-reason").val('');
    var hint = this.isPaid() ? 'Valor de la Consulta' : 'Valor <b>Pendiente</b> de la Consulta';
    $("#updated-payment-hint").html(hint);
  },

  refreshControls: function(updatedPayment) {
    var selector = this.isPaid() ? "#consultation_payment" : "#consultation_pending_payment";
    $(selector).val(updatedPayment);
    $("#updated-payment").html(updatedPayment);
  },

  formatPayment: function(payment) {
    return parseFloat(payment).toFixed(2);
  }
}
