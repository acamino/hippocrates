Hippocrates.Charges = {
  init: function() {
    var self = this;

    $(".show-price-changes").on("click", function(e) {
      var consultationId = $(this).attr("id");
      self.getPriceChanges(consultationId);

      e.preventDefault();
      self.openModal();
    });
  },

  openModal: function() {
    $("#price-changes").modal({ backdrop: "static" });
  },

  renderTemplate: function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  getPriceChanges: function(consultationId) {
    var self = this;

    var path = "/api/consultations/" + consultationId + "/price_changes";
    $.get(path, function(data) {
      var content = self.renderTemplate("#tmpl-price-changes", { priceChanges: data });
      $("#price-changes--content").html(content);
    });
  }
}
