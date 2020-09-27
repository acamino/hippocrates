Hippocrates.Autocomplete = {
  init: function() {
    $.get("/api/diseases").done(function(suggestions) {
      $(".disease").autocomplete({
        lookup: suggestions,
        onSelect: function (suggestion) {
          $(this).closest("tr").find("input.code").val(suggestion.data);
        }
      });
    });

    $.get("/api/medicines").done(function(medicines) {
      $(".inscription").autocomplete({
        lookup: medicines,
        onSelect: function (medicine) {
          var locked = $(this).closest("tr").find(".locked").is(':checked');
          if (!locked) {
            $(this).closest("tr").find("textarea.subscription").val(medicine.data);
          }
        }
      });
    });
  }
};
