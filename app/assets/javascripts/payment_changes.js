Hippocrates.PaymentChanges = {
  init: function() {
    var self = this;

    $("#show-payment-change").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    if ($("#changed_payment").length) {
      new Cleave('#changed_payment', {
        numeral: true,
        numeralThousandsGroupStyle: 'thousand'
      });
    }

    $("#save-payment").on("click", function(e) {
      self.savePrice();
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

  savePrice: function() {
    var self = this;

    var changedPrice = $("#changed_payment").val();
    var reason = $("#change_payment_reason").val();
    var consultationId = $("#consultation_id").val();

    var path = "/api/consultations/" + consultationId + "/payment_changes";
    var data = {
      change_payment: {
        updated_payment: changedPrice,
        reason: reason
      }
    };

    $.post(path, data)
      .done(function(result) {
        self.refreshPrice(changedPrice);
        $("#change-payment").modal('hide');
      })
      .fail(function(result) {
        $("#change-payment__errors").show();
        var errors = self.renderTemplate("#tmpl-payment-change-errors", { errors: result.responseJSON.errors });
        $("#change-payment__errors--body").html(errors);
      });
  },

  initControls: function() {
    var currentPrice = $("#consultation_payment").val()

    $("#change-payment__errors").hide()
    $("#changed_payment").val(currentPrice);
    $("#change_payment_reason").val('');
  },

  refreshPrice: function(changedPrice) {
    var formattedPrice = parseFloat(changedPrice).toFixed(2);
    $("#consultation_payment").val(formattedPrice);
    $("#changed_payment").val(formattedPrice);
  }
}
