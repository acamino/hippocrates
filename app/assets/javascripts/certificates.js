Hippocrates.Certificates = {
  init: function() {
    var self = this;

    $(".show-certificate").on("click", function(e) {
      e.preventDefault();
      Hippocrates.Utils.openModal("#certificates");
    });

    $("#certificate").on("change", function() {
      self.updateUrlAndToggleControls();
    });

    $("#certificate_start_time, #certificate_end_time").datetimepicker({
      format: 'LT',
    }).on("dp.change", function() {
      self.updateUrl();
    });

    var observableControls = [
      "#certificate_rest_time",
      "#certificate_surgical_treatment",
      "#certificate_surgery_tentative_date",
      "#certificate_surgery_cost"
    ].join(", ")
    $(observableControls).on("change", function() {
      self.updateUrl();
    });

    self.updateUrlAndToggleControls();
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
    this.toggleControls(certificateType);
  },

  buildUrl: function(certificateType) {
    var baseUrl = "/consultations/documents/download";
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

    if (this.isProforma(certificateType)) {
      params.push("surgical_treatment=" + this.getSurgicalTreatment());
      params.push("surgery_tentative_date=" + this.getSurgeryTentativeDate());
      params.push("surgery_cost=" + this.getSurgeryCost());
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

  getSurgicalTreatment: function () {
    return $("#certificate_surgical_treatment").val();
  },

  getSurgeryTentativeDate: function () {
    return $("#certificate_surgery_tentative_date").val();
  },

  getSurgeryCost: function () {
    return $("#certificate_surgery_cost").val();
  },

  isAttendance: function (certificateType) {
    return certificateType === "attendance";
  },

  isRest: function (certificateType) {
    return certificateType === "rest";
  },

  isProforma: function (certificateType) {
    return certificateType === "proforma";
  },

  toggleTimeControls: function(certificateType) {
    var hasTimeControls = this.isAttendance(certificateType);
    $(".time-controls").toggle(hasTimeControls);
  },

  toggleRestControls: function (certificateType) {
    $(".rest-controls").toggle(this.isRest(certificateType));
  },

  toggleProformaControls: function (certificateType) {
    $(".proforma-controls").toggle(this.isProforma(certificateType));
  },

  toggleControls: function (certificateType) {
    this.toggleTimeControls(certificateType);
    this.toggleRestControls(certificateType);
    this.toggleProformaControls(certificateType);
  }
}
