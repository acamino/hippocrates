Hippocrates.Certificates = {
  init: function() {
    var self = this;

    $(".show-certificate").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $("#certificate").on("change", function() {
      var certificateType = $(this).val();
      self.toggleTimeControls(certificateType);
      self.updateUrl(certificateType);
    });

    $("#certificate_start_time, #certificate_end_time").datetimepicker({
      format: 'LT',
    }).on("dp.change", function() {
      var certificateType = $("#certificate").val();
      self.updateUrl(certificateType);
    });
  },

  openModal: function() {
    $("#certificates").modal({ backdrop: "static" });
  },

  updateUrl: function(certificateType) {
    var url = this.buildUrl(certificateType);
    $("#certificates").find(".btn-primary").attr("href", url);
  },

  buildUrl: function(certificateType) {
    var baseUrl = "/certificates/download";
    var consultationId = this.getConsultationId();

    return baseUrl + "?consultation_id=" + consultationId + "&" + this.buildParams(certificateType);
  },

  buildParams: function(certificateType) {
    var params = [];
    params.push("certificate_type=" + certificateType);

    if (this.hasTimeControls(certificateType)) {
      params.push("start_time=" + this.getStartTime());
      params.push("end_time=" + this.getEndTime());
    }

    return params.join("&");
  },

  getConsultationId: function() {
    return $("#consultation_id").val();
  },

  getStartTime: function() {
    return $("#certificate_start_time").val();
  },

  getEndTime: function() {
    return $("#certificate_end_time").val();
  },

  isAttendance: function (certificateType) {
    return certificateType === "attendance";
  },

  hasTimeControls: function(certificateType) {
    return this.isAttendance(certificateType);
  },

  toggleTimeControls: function(certificateType) {
    $(".time-controls").toggle(this.hasTimeControls(certificateType));
  }
}
