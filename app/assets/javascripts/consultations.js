Hippocrates.Consultations = {
  self: false,

  init: function() {
    self = this;

    $("#show").on("click", function(e) {
      e.preventDefault();
      self.openModal();
    });

    $(".modal").on("show.bs.modal", function (e) {
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
    $(".modal").modal({ backdrop: "static" });
  },

  renderTemplate: function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);
    return Mustache.render(template, data);
  },

  renderConsultation: function(consultation) {
    if (consultation) {
      var consultationHeader = self.renderTemplate("#consultation-header", consultation);
      var consultationBody = self.renderTemplate("#consultation-body", consultation);

      $(".modal").find(".modal-title").html(consultationHeader);
      $(".modal").find(".modal-body").html(consultationBody);
    }
  },

  consultationType: { LAST: "last", PREV: "previous", NEXT: "next" },

  getConsultation: function(type) {
    var data = {};
    if (type !== self.consultationType.LAST) {
      data = { current_consultation: $("#current-consultation").val() };
    }

    var path = "/api" + $(".container > form").attr("action").replace(/\/\d+$/, '') + "/" + type;
    $.post(path, data, function(consultation) {
      self.renderConsultation(consultation);
    });
  },

  getLastConsultation: function() {
    self.getConsultation(self.consultationType.LAST);
  },

  getPreviousConsultation: function() {
    self.getConsultation(self.consultationType.PREV);
  },

  getNextConsultation: function() {
    self.getConsultation(self.consultationType.NEXT);
  }
};
