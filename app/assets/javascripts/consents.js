Hippocrates.Consents = {
  init: function() {
    var self = this;

    $(".show-consent").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $("#consent").on("change", function() {
      self.updateUrlAndToggleControls();
    });

    self.updateUrlAndToggleControls();
  },

  openModal: function() {
    $("#consents").modal({ backdrop: "static" });
  },

  updateUrl: function(certificateType) {
    if (_.isUndefined(certificateType)) {
      certificateType = $("#certificate").val();
    }
    var url = this.buildUrl(certificateType);

    $("#certificates").find(".btn-primary").attr("href", url);
  },

  updateUrlAndToggleControls: function () {
    var certificateType = $("#certificate").val();

    this.updateUrl(certificateType);
  },

  buildUrl: function(certificateType) {
    var baseUrl = "/consultations/documents/download";
    var consultationId = this.getConsultationId();

    return baseUrl + "?consultation_id=" + consultationId + "&" + this.buildParams(certificateType);
  },

  buildParams: function(certificateType) {
    var params = [];
    params.push("certificate_type=" + certificateType);
    params.push('path=consents');

    return params.join("&");
  },

  getConsultationId: function() {
    return $("#consultation_id").val();
  }
}
