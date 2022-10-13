Hippocrates.Consultations = {
  init: function() {
    var self = this;

    $(".destroy").on("change", function () {
      $(this).closest("tr").toggleClass("destroyable");
    });

    $("#consultation_reason").on("keyup", function () {
      var reason = $(this).val();
      $("#consultation_ongoing_issue").val(reason);
    });

    $("#show").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $("#consultation").on("show.bs.modal", function (e) {
      self.getLastConsultation(this);
    });

    $("#prev").on("click", function(e) {
      self.getPreviousConsultation();
      return false;
    });

    $("#next").on("click", function(e) {
      self.getNextConsultation();
      return false;
    });

    $("body").keydown(function(e) {
      if (($(".modal").data("bs.modal") || {}).isShown) {
        var LEFT_ARROW = 37, RIGHT_ARROW = 39;
        if(e.keyCode === LEFT_ARROW) {
          self.getPreviousConsultation();
        }
        else if(e.keyCode === RIGHT_ARROW) {
          self.getNextConsultation();
        }
      }
    });
  },

  openModal: function() {
    $("#consultation").modal({ backdrop: "static" });
  },

  renderConsultation: function(consultation) {
    if (consultation) {
      var consultationHeader = Hippocrates.Templates.render("#consultation-header", consultation);
      var consultationBody = Hippocrates.Templates.render("#consultation-body", consultation);

      $("#consultation").find(".modal-title").html(consultationHeader);
      $("#consultation").find(".modal-body").html(consultationBody);
    }
  },

  consultationType: { LAST: "last", PREV: "previous", NEXT: "next" },

  getConsultation: function(type) {
    var self = this;
    var data = {};

    if (type !== this.consultationType.LAST) {
      data = { current_consultation: $("#current-consultation").val() };
    }

    var path = "/api" + $(".container > form").attr("action").replace(/\/\d+$/, "") + "/" + type;
    $.post(path, data, function(consultation) {
      self.renderConsultation(consultation);
    });
  },

  getLastConsultation: function() {
    this.getConsultation(this.consultationType.LAST);
  },

  getPreviousConsultation: function() {
    this.getConsultation(this.consultationType.PREV);
  },

  getNextConsultation: function() {
    this.getConsultation(this.consultationType.NEXT);
  }
};
