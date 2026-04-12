Hippocrates.ClinicalHistory = {
  selectAllMode: false,

  init: function() {
    var self = this;

    self.selectAllMode = false;
    self.showPendingToast();

    $('.btn-copy').copyOnClick({
      confirmShow: false
    });

    $(".check-all").change(function () {
      $("input:checkbox").prop('checked', $(this).prop("checked"));
      self.selectAllMode = false;
      self.updateUrl();
      self.updateBulkActions();
    });

    $(".check-consultation").change(function () {
      var checked = $(this).prop("checked");

      if (!checked) {
        $(".check-all").prop('checked', checked);
        self.selectAllMode = false;
      }

      self.updateUrl();
      self.updateBulkActions();
    });


    $(".btn-copy").mouseenter(function(e) {
      $(this).closest(".row").find(".content").addClass("selected-content")
    });

    $(".btn-copy").mouseleave(function(e) {
      $(this).closest(".row").find(".content").removeClass("selected-content")
    });

    $(".bulk-banner-action").click(function (e) {
      e.preventDefault();
      self.selectAllMode = !self.selectAllMode;
      self.updateUrl();
      self.updateBulkActions();
    });

    $(".delete-consultations").click(function (e) {
      e.preventDefault();
      var patientId = $("#patient_id").val();
      var data = self.selectAllMode
        ? { all: true }
        : { consultations: self.getSelectedConsultations() };

      $.ajax({
        url: "/api/patients/" + patientId + "/consultations",
        type: "DELETE",
        data: data,
        dataType: "json",
        success: function () {
          var deletedCount = self.selectAllMode
            ? parseInt($('.bulk-actions').data('total'), 10) || 0
            : $('.check-consultation:checked').length;
          var message = deletedCount === 1
            ? 'Consulta eliminada correctamente'
            : deletedCount + ' consultas eliminadas correctamente';
          sessionStorage.setItem('hippocratesPendingToast', message);
          location.reload();
        }
      });
    });
  },

  showPendingToast: function () {
    var message = sessionStorage.getItem('hippocratesPendingToast');
    if (!message) return;

    sessionStorage.removeItem('hippocratesPendingToast');

    var $toast = $('<div class="flash-toast alert alert-success">' +
                   '<a class="close" data-dismiss="alert">&times;</a>' +
                   '<div id="flash_notice">' + message + '</div></div>');
    $('body').append($toast);

    setTimeout(function () {
      $toast.fadeOut(300, function () { $(this).remove(); });
    }, 3500);
  },

  updateBulkActions: function () {
    var pageSelected = $('.check-consultation:checked').length;
    var total = parseInt($('.bulk-actions').data('total'), 10) || 0;
    var pageSize = $('.check-consultation').length;
    var $default = $('.default-actions');
    var $bulk = $('.bulk-actions');
    var $count = $('.bulk-count');
    var $bannerRow = $('.bulk-banner-row');
    var $bannerText = $('.bulk-banner-text');
    var $bannerAction = $('.bulk-banner-action');

    if (pageSelected === 0) {
      this.selectAllMode = false;
      $default.show();
      $bulk.hide();
      $bannerRow.hide();
      return;
    }

    $default.hide();
    $bulk.show();

    if (this.selectAllMode) {
      $count.text(total + ' consultas seleccionadas');
      $bannerText.text('Las ' + total + ' consultas están seleccionadas.');
      $bannerAction.text('Limpiar selección');
      $bannerRow.show();
      return;
    }

    var label = pageSelected === 1
      ? '1 consulta seleccionada'
      : pageSelected + ' consultas seleccionadas';
    $count.text(label);

    if (total > pageSize && pageSelected === pageSize) {
      $bannerText.text('Las ' + pageSelected + ' consultas de esta página están seleccionadas.');
      $bannerAction.text('Seleccionar las ' + total + ' consultas');
      $bannerRow.show();
    } else {
      $bannerRow.hide();
    }
  },

  updateUrl: function () {
    var url;
    if (this.selectAllMode) {
      var anchorId = $('.check-consultation').first().attr('id') || '';
      url = "/consultations/documents/download?certificate_type=history" +
            "&all=true&consultations=" + anchorId;
    } else {
      var consultations = this.getSelectedConsultations();
      url = this.buildUrl(consultations);
    }

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
