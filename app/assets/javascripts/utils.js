Hippocrates.Utils = (function () {
  var openModal = function(selector) {
    $(selector).modal({ backdrop: "static" });
  };

  return {
    openModal: openModal
  };
})();
