Hippocrates.Consents = {
  init: function() {
    var self = this;

    $(".show-consent").on("click", function(e) {
      e.preventDefault();
      Hippocrates.Utils.openModal("#consents");
    });

    $("#consent").on("change", function() {
      self.updateUrlAndToggleControls();
    });

    self.updateUrlAndToggleControls();
  },

  updateUrl: function(certificateType) {
    if (_.isUndefined(certificateType)) {
      certificateType = $("#consent").val();
    }
    var url = this.buildUrl(certificateType);

    $("#consents").find(".btn-primary").attr("href", url);
  },

  updateUrlAndToggleControls: function () {
    var consentType = $("#consent").val();

    this.updateUrl(consentType);
  },

  buildUrl: function(consentType) {
    var baseUrl = "/consultations/documents/download";
    var consultationId = this.getConsultationId();

    return baseUrl + "?consultation_id=" + consultationId + "&" + this.buildParams(consentType);
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
