Hippocrates.ChangePrice = {
  init: function() {
    var self = this;

    $("#show-change-price").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    if ($("#changed_price").length) {
      new Cleave('#changed_price', {
        numeral: true,
        numeralThousandsGroupStyle: 'thousand'
      });
    }

    $("#save-price").on("click", function(e) {
      self.savePrice();
      return false;
    });

    self.initControls();
  },

  openModal: function() {
    this.initControls();
    $("#change-price").modal({ backdrop: "static" });
  },

  renderTemplate: function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  savePrice: function() {
    var self = this;

    var changedPrice = $("#changed_price").val();
    var reason = $("#change_price_reason").val();
    var consultationId = $("#consultation_id").val();

    var path = "/api/consultations/" + consultationId + "/price_changes";
    var data = {
      change_price: {
        updated_price: changedPrice,
        reason: reason
      }
    };

    $.post(path, data)
      .done(function(result) {
        self.refreshPrice(changedPrice);
        $("#change-price").modal('hide');
      })
      .fail(function(result) {
        $("#change-price__errors").show();
        var errors = self.renderTemplate("#tmpl-price-change-errors", { errors: result.responseJSON.errors });
        $("#change-price__errors--body").html(errors);
      });
  },

  initControls: function() {
    var currentPrice = $("#consultation_price").val()

    $("#change-price__errors").hide()
    $("#changed_price").val(currentPrice);
    $("#change_price_reason").val('');
  },

  refreshPrice: function(changedPrice) {
    var formattedPrice = parseFloat(changedPrice).toFixed(2);
    $("#consultation_price").val(formattedPrice);
    $("#changed_price").val(formattedPrice);
  }
}
