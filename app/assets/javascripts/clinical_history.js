Hippocrates.ClinicalHistory = {
  init: function() {
    var self = this;
    $(".check-all").change(function () {
      $("input:checkbox").prop('checked', $(this).prop("checked"));
      self.updateUrl();
    });

    $(".check-consultation").change(function () {
      var checked = $(this).prop("checked");

      if (!checked) {
        $(".check-all").prop('checked', checked);
      }

      self.updateUrl();
    });

    $('.select-consultation').click(function(e) {
      var path = $(this).data('path');
      window.location.href = path;
    });

    $(".delete-consultations").click(function() {
      var consultations = self.getSelectedConsultations();
      var patientId = $("#patient_id").val();

      $.ajax({
        url: "/api/patients/" + patientId + "/consultations",
        type: "DELETE",
        data: { consultations: consultations },
        dataType: "script",
        success: function(data) {
          location.reload();
        }
      });
    });
  },

  updateUrl: function () {
    var consultations = this.getSelectedConsultations();
    var url = this.buildUrl(consultations);

    $(".download-medical-history").attr("href", url);
  },

  buildUrl: function (consultations) {
    var baseUrl = "/consultations/documents/download?certificate_type=history"

    if (_.isEmpty(consultations)) {
      return baseUrl;
    }

    return baseUrl + "&consultations=" + consultations;
  },

  getSelectedConsultations: function () {
    var consultations = $('.check-consultation');
    var selectedConsultations = _.filter(consultations, this.isSelected);

    return _.map(selectedConsultations, this.getConsultationId).join("_");
  },

  isSelected: function (consultation) {
    return $(consultation).prop('checked');
  },

  getConsultationId: function (consultation) {
    return $(consultation).attr('id');
  }
};
