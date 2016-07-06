Hippocrates.Certificates = {
  init: function() {
    var self = this;

    $(".show-certificate").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $("#certificate").on("change", function() {
      var certificateType = $(this).val();
      self.toggleControls(certificateType);
      self.updateUrl(certificateType);
    });

    $("#certificate_start_time, #certificate_end_time").datetimepicker({
      format: 'LT',
    }).on("dp.change", function() {
      var certificateType = $("#certificate").val();
      self.updateUrl(certificateType);
    });

    $("#certificate_rest_time").on("change", function() {
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

    if (this.isAttendance(certificateType)) {
      params.push("start_time=" + this.getStartTime());
      params.push("end_time=" + this.getEndTime());
    }

    if (this.isRest(certificateType)) {
      params.push("rest_time=" + this.getRestTime());
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

  getRestTime: function () {
    return $("#certificate_rest_time").val();
  },

  isAttendance: function (certificateType) {
    return certificateType === "attendance";
  },

  isRest: function (certificateType) {
    return certificateType === "rest";
  },

  toggleTimeControls: function(certificateType) {
    $(".time-controls").toggle(this.isAttendance(certificateType));
  },

  toggleRestControls: function (certificateType) {
    $(".rest-controls").toggle(this.isRest(certificateType));
  },

  toggleControls: function (certificateType) {
    this.toggleTimeControls(certificateType);
    this.toggleRestControls(certificateType);
  }
}
