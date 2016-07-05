Hippocrates.Certificates = {
  init: function() {
    var self = this;

    $(".show-certificate").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $("#certificate").on("change", function() {
      var certificateType = $(this).val();
      var url = self.buildUrl(certificateType);

      $("#certificates").find(".btn-primary").attr("href", url);
    });
  },

  openModal: function() {
    $("#certificates").modal({ backdrop: "static" });
  },

  buildUrl: function(certificateType) {
    var baseUrl = "/certificates/download";
    var consultationId = this.getConsultationId();

    return baseUrl + "?consultation_id=" + consultationId + "&" + this.getParams(certificateType);
  },

  getParams: function(certificateType) {
    var params = [];
    params.push("certificate_type=" + certificateType || "simple");

    return params.join("&");
  },

  getConsultationId: function() {
    return $("#consultation_id").val();
  }
}
