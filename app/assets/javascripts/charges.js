Hippocrates.Charges = (function() {
  var that = this;

  that.consultationId = null;
  that.type = null;
  that.isPaid = false;

  var init = function() {
    $(".show-payment-changes").on("click", function(e) {
      e.preventDefault();

      that.consultationId = $(this).attr("id");
      that.type = $(this).data("type");
      that.isPaid = that.type == "paid";

      fetchPayments(renderControls);
    });

    $(".btn-charges").on("click", function(e) {
      var action = $(this).data("action-path");
      $('form').attr('action', action);
    });
  };

  var fetchPayments = function(renderControls) {
    var path = "/api/consultations/" + that.consultationId + "/payment_changes?type=" + that.type;
    $.get(path, function(paymentChanges) {
      renderControls.call(this, paymentChanges);
    });
  }

  var renderControls = function(paymentChanges) {
    renderPaymentsChanges(paymentChanges);
    renderModalTitle();

    Hippocrates.Utils.openModal("#payment-changes");
  };

  var renderPaymentsChanges = function(paymentChanges) {
    var content = Hippocrates.Templates.render("#tmpl-payment-changes", { paymentChanges });
    $("#payment-changes--content").html(content);
  };

  var renderModalTitle = function() {
    var modalTitle = that.isPaid ? 'Valores Pagados' : 'Valores Pendientes'
    $("#payment-changes-title").html(modalTitle);
  };

  return {
    init: init
  }
})();
