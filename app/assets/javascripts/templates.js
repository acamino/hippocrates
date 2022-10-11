Hippocrates.Templates = (function () {
  var api = {};

  api.render = function(target, data) {
    var template = $(target).html();
    Mustache.parse(template);

    return Mustache.render(template, data);
  };

  return api;
})();
