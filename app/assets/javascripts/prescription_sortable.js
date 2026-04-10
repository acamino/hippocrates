Hippocrates.PrescriptionSortable = {
  init: function() {
    var self = this;
    var tbody = document.querySelector('.prescriptions tbody');

    if (!tbody) return;

    Sortable.create(tbody, {
      handle: '.prescription-drag-handle',
      animation: 150,
      ghostClass: 'prescription-ghost',
      chosenClass: 'prescription-chosen',
      dragClass: 'prescription-drag',
      onEnd: function() {
        self.compactRows();
        self.updatePositions();
      }
    });

    self.compactRows();
    self.updatePositions();
    self.initDelete();
    self.initLock();
    self.initVisibility();
  },

  rowHasContent: function($row) {
    return $row.find('.inscription').val().trim().length > 0 ||
           $row.find('.subscription').val().trim().length > 0;
  },

  compactRows: function() {
    var self = this;
    var $tbody = $('.prescriptions tbody');
    var $rows = $tbody.find('.prescription-row');

    var contentRows = [];
    var emptyRows = [];

    $rows.each(function() {
      if (self.rowHasContent($(this))) {
        contentRows.push(this);
      } else {
        emptyRows.push(this);
      }
    });

    contentRows.concat(emptyRows).forEach(function(row) {
      $tbody.append(row);
    });

    $rows.each(function() {
      self.toggleRowControls($(this));
    });
  },

  updatePositions: function() {
    $('.prescriptions tbody .prescription-row').each(function(index) {
      $(this).find('input[id$="_position"]').val(index);
    });
  },

  initDelete: function() {
    var self = this;

    $('.prescriptions tbody').on('click', '.prescription-delete-btn', function(e) {
      e.preventDefault();
      var $row = $(this).closest('.prescription-row');

      $row.find('.prescription-destroy-checkbox').prop('checked', true);
      $row.addClass('prescription-deleted');
      $row.find('.prescription-delete-btn').hide();
      $row.find('.prescription-undo-btn').show();
    });

    $('.prescriptions tbody').on('click', '.prescription-undo-btn', function(e) {
      e.preventDefault();
      var $row = $(this).closest('.prescription-row');

      $row.find('.prescription-destroy-checkbox').prop('checked', false);
      $row.removeClass('prescription-deleted');
      $row.find('.prescription-undo-btn').hide();
      $row.find('.prescription-delete-btn').show();
    });
  },

  initLock: function() {
    $('.prescriptions tbody').on('click', '.prescription-lock-btn', function(e) {
      e.preventDefault();
      var $row = $(this).closest('.prescription-row');
      var $checkbox = $row.find('.locked');
      var $icon = $(this).find('i');

      if ($checkbox.is(':checked')) {
        $checkbox.prop('checked', false);
        $(this).removeClass('prescription-locked');
      } else {
        $checkbox.prop('checked', true);
        $(this).addClass('prescription-locked');
      }
    });
  },

  initVisibility: function() {
    var self = this;

    $('.prescriptions tbody').on('input', '.inscription, .subscription', function() {
      self.toggleRowControls($(this).closest('.prescription-row'));
    });

    $('.prescriptions tbody .prescription-row').each(function() {
      self.toggleRowControls($(this));
    });
  },

  toggleRowControls: function($row) {
    var hasContent = this.rowHasContent($row);

    $row.find('.prescription-lock-btn').toggle(hasContent);
    $row.find('.prescription-delete-btn').toggle(hasContent && !$row.hasClass('prescription-deleted'));
    $row.find('.prescription-undo-btn').toggle(hasContent && $row.hasClass('prescription-deleted'));
    $row.find('.prescription-drag-handle .drag-dots').toggle(hasContent);
  }
};
