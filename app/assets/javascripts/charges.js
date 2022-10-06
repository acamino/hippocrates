Hippocrates.Charges = {
  init: function() {
    var self = this;

    $(".show-payment-changes").on("click", function(e) {
      var consultationId = $(this).attr("id");
      self.getPaymentChanges(consultationId);

      e.preventDefault();
      self.openModal();
    });
  },

  openModal: function() {
    $("#payment-changes").modal({ backdrop: "static" });
  },

  renderTemplate: function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  getPaymentChanges: function(consultationId) {
    var self = this;

    var path = "/api/consultations/" + consultationId + "/payment_changes";
    $.get(path, function(data) {
      var content = self.renderTemplate("#tmpl-payment-changes", { paymentChanges: data });
      $("#payment-changes--content").html(content);
    });
  }
}
