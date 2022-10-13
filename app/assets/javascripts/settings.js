Hippocrates.Settings = (function() {
  var setup = function() {
    $.fn.editable.defaults.mode = "inline";
    $.fn.editable.defaults.ajaxOptions = { type: "PATCH" };
  };

  var toOption = function(option) {
    return { value: option, text: option };
  };

  var textInputClass = 'form-control input-sm user-input';

  var init = function() {
    setup();

    $('#sequence').editable({});

    $('#diagnoses, #prescriptions').editable({
      source: _(_.range(1, 11)).map(toOption)
    });

    $('#emergency-number, #website').editable({
      inputclass: textInputClass
    });
  };

  return {
    init: init
  }
})();
