Hippocrates.Charges = {
  init: function() {
    var self = this;

    $(".show-payment-changes").on("click", function(e) {
      e.preventDefault();

      var consultationId = $(this).attr("id");
      var type = $(this).data('type');

      self.getPaymentChanges(consultationId, type);
      self.setModalTitle(type);
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

  getPaymentChanges: function(consultationId, type) {
    var self = this;

    var path = "/api/consultations/" + consultationId + "/payment_changes?type=" + type;
    $.get(path, function(data) {
      var content = self.renderTemplate("#tmpl-payment-changes", { paymentChanges: data });
      $("#payment-changes--content").html(content);
    });
  },

  setModalTitle: function(type) {
    var modalTitle = type == 'paid' ? 'Valores Pagados' : 'Valores Pendientes'
    $("#payment-changes-title").html(modalTitle);
  }
}
