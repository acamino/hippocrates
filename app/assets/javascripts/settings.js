Hippocrates.Settings = {
  init: function() {
    $.fn.editable.defaults.mode = "inline";
    $.fn.editable.defaults.ajaxOptions = { type: "PATCH" };

    $('#diagnoses, #prescriptions').editable({
      source: _.map(_.range(1, 11), function (option) {
        return { value: option, text: option };
      })
    });

    $('#sequence').editable({});
  }
};
