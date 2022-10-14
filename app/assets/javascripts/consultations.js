Hippocrates.Consultations = (function() {
  var shared = {};

  var buttons = {
    NEXT: "#next",
    PREV: "#prev"
  };

  var init = function() {
    shared.patientId = $("#patient_id").val();
    shared.consultationId = $("#consultation_id").val();

    keyboardJS.bind('ctrl + c', function(e) {
      openClinicalHistoryModal();
    });

    $(".destroy").on("change", function () {
      $(this).closest("tr").toggleClass("destroyable");
    });

    $("#consultation_reason").on("keyup", function () {
      var reason = $(this).val();
      $("#consultation_ongoing_issue").val(reason);
    });

    $("#show").on("click", function(e) {
      e.preventDefault();

      openClinicalHistoryModal();
    });

    $("#prev").on("click", function(e) {
      getConsultation(buttons.PREV);
      return false;
    });

    $("#next").on("click", function(e) {
      getConsultation(buttons.NEXT);
      return false;
    });

    $("body").keydown(function(e) {
      if (($(".modal").data("bs.modal") || {}).isShown) {
        var LEFT_ARROW = 37, RIGHT_ARROW = 39;
        if(e.keyCode === LEFT_ARROW) {
          getConsultation(buttons.PREV);
        }
        else if(e.keyCode === RIGHT_ARROW) {
          getConsultation(buttons.NEXT);
        }
      }
    });
  }

  var openClinicalHistoryModal = function() {
    Hippocrates.Utils.openModal("#consultation");
    getConsultation();
  };

  var getConsultation = function(selector) {
    if (isActionDisabled(selector)) {
      return;
    }

    var path = buildPath(getConsultationId(selector));
    $.get(path, function(data) {
      toggleNavButton(buttons.PREV, data.meta.previous);
      toggleNavButton(buttons.NEXT, data.meta.next);

      var paginationOptions = { current: data.meta.current.position, total: data.meta.total };
      var consultation = $.extend(data.consultation, paginationOptions);
      renderConsultation(consultation);
    });
  };

  var isActionDisabled = function(selector) {
    return $(selector).is(":disabled");
  }

  var toggleNavButton = function(selector, page) {
    if (page) {
      $(selector).data("consultation-id", page.id);
      $(selector).removeAttr('disabled');
    } else {
      $(selector).attr('disabled', 'disabled');
    }
  };

  var getConsultationId = function(selector) {
    if (_.isUndefined(selector)) {
      return shared.consultationId;
    } else {
      return $(selector).data("consultation-id");
    }
  };

  var renderConsultation = function(consultation) {
    if (consultation) {
      var consultationHeader = Hippocrates.Templates.render("#consultation-header", consultation);
      var consultationBody = Hippocrates.Templates.render("#consultation-body", consultation);

      $("#consultation").find(".modal-title").html(consultationHeader);
      $("#consultation").find(".modal-body").html(consultationBody);
    }
  };

  var buildPath = function(consultationId) {
    return [
      "/api", "patients", shared.patientId, "consultations", consultationId
    ].join("/");
  };

  return {
    init: init
  };
})();
