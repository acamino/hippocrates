Hippocrates.Utils = (function () {
  var openModal = function(selector) {
    $(selector).modal({ backdrop: "static" });
  };

  return {
    openModal: openModal
  };
})();

$(document).on('click', '.clickable-row', function(e) {
  if ($(e.target).closest('a, button, input').length) return;
  window.location = $(this).data('href');
});
