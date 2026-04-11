Hippocrates.PatientEditable = {
  sources: {
    gender: [
      { value: 'male', text: 'MASCULINO' },
      { value: 'female', text: 'FEMENINO' }
    ],
    civil_status: [
      { value: 'single', text: 'SOLTERO/A' },
      { value: 'married', text: 'CASADO/A' },
      { value: 'civil_union', text: 'UNIÓN LIBRE' },
      { value: 'divorced', text: 'DIVORCIADO/A' },
      { value: 'widowed', text: 'VIUDO/A' }
    ],
    source: [
      { value: 'instagram', text: 'INSTAGRAM' },
      { value: 'facebook', text: 'FACEBOOK' },
      { value: 'tiktok', text: 'TIKTOK' },
      { value: 'television', text: 'TELEVISIÓN' },
      { value: 'radio', text: 'RADIO' },
      { value: 'newspaper', text: 'PERIÓDICO' },
      { value: 'patient_reference', text: 'OTRO PACIENTE' },
      { value: 'health_professional', text: 'PROFESIONAL DE SALUD' }
    ]
  },

  containers: ['#patient-editable', '#anamnesis-editable'],

  init: function() {
    var self = this;

    self.containers.forEach(function(selector) {
      var $container = $(selector);
      if (!$container.length) return;

      $container.on('click', '.editable-field', function(e) {
        e.preventDefault();
        var $el = $(this);
        if ($el.hasClass('editing')) return;
        self.startEdit($el);
      });

      $container.on('change', '.anamnesis-toggle', function() {
        var $toggle = $(this);
        var name = $toggle.data('name');
        var value = $toggle.is(':checked');
        var url = $container.data('url');

        $.ajax({
          url: url,
          method: 'PATCH',
          data: { name: name, value: value }
        });
      });
    });
  },

  startEdit: function($el) {
    var self = this;
    var name = $el.data('name');
    var type = $el.data('type');
    var currentText = $.trim($el.text());
    var currentValue = $el.data('value') || currentText;

    $el.addClass('editing');

    var $input;
    if (type === 'select') {
      $input = $('<select class="form-control input-sm editable-input-field">');
      var options = self.sources[name] || [];
      options.forEach(function(opt) {
        var $opt = $('<option>').val(opt.value).text(opt.text);
        if (opt.value === currentValue || opt.text === currentText) {
          $opt.prop('selected', true);
        }
        $input.append($opt);
      });
    } else {
      $input = $('<input type="text" class="form-control input-sm editable-input-field">');
      $input.val(currentText === '-' ? '' : currentText);
    }

    $el.empty().append($input);
    $input.focus().select();

    if (type === 'select') {
      $input.on('change', function() {
        self.save($el, $input, name, type);
      });
    }

    if (type === 'date') {
      $input.datepicker({
        format: 'yyyy/mm/dd',
        language: 'es',
        calendarWeeks: true,
        autoclose: true
      }).on('changeDate', function() {
        self.save($el, $input, name, type);
      });
      $input.datepicker('show');
    }

    $input.on('keydown', function(e) {
      if (e.which === 13) {
        e.preventDefault();
        self.save($el, $input, name, type);
      } else if (e.which === 27) {
        e.preventDefault();
        self.cancel($el, currentText, currentValue);
      }
    });

    if (type === 'text') {
      $input.on('blur', function() {
        setTimeout(function() {
          if ($el.hasClass('editing')) {
            self.save($el, $input, name, type);
          }
        }, 150);
      });
    }
  },

  save: function($el, $input, name, type) {
    var self = this;
    var $container = $el.closest('[data-pk]');
    var url = $container.data('url');

    var value = $input.val();
    var displayText;

    if (type === 'select') {
      displayText = $input.find('option:selected').text();
    } else {
      displayText = value || '-';
    }

    $el.removeClass('editing');
    $el.empty().text(displayText);
    $el.data('value', value);

    $.ajax({
      url: url,
      method: 'PATCH',
      data: { name: name, value: value },
      success: function() {
        self.flash($el, '#dff0d8');

        if (name === 'birthdate' && value) {
          var age = self.calculateAge(new Date(value));
          $('.patient-age').val(age);
        }
      },
      error: function() {
        self.flash($el, '#f2dede');
      }
    });
  },

  cancel: function($el, originalText, originalValue) {
    $el.removeClass('editing');
    $el.empty().text(originalText);
    $el.data('value', originalValue);
  },

  calculateAge: function(birthday) {
    var today = new Date();
    var age = today.getFullYear() - birthday.getFullYear();
    var m = today.getMonth() - birthday.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthday.getDate())) age--;
    return age;
  },

  flash: function($el, color) {
    $el.css('background-color', color);
    setTimeout(function() {
      $el.css('background-color', '');
    }, 600);
  }
};
