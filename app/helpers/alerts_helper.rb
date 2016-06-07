module AlertsHelper
  def alerts_for(anamnesis)
    Alerts.new(self, anamnesis).html
  end

  class Alerts
    def initialize(view, anamnesis)
      @view                 = view
      @has_allergies        = anamnesis.allergies?
      @has_observations     = anamnesis.observations?
      @has_personal_history = anamnesis.personal_history?
    end

    def html
      return nil unless alerts?
      [
        content_tag(:div, hints.join.html_safe, class: "row progress-hint"),
        content_tag(:div, segments.join.html_safe, class: "progress")
      ].join.html_safe
    end

    private

    attr_accessor :view,
                  :has_allergies, :has_observations, :has_personal_history

    delegate :content_tag, to: :view

    def alerts_count
      visible_alerts.count
    end

    def alerts?
      visible_alerts.count > 0
    end

    def column_width
      base_width = 12
      base_width / alerts_count
    end

    def segment_width
      base_width = 100.0
      base_width / alerts_count
    end

    def alerts
      [
        { label: 'Alergias', color: 'danger', visible: has_allergies },
        { label: 'Observaciones', color: 'warning', visible: has_observations },
        { label: 'Antecedentes Personales', color: 'info', visible: has_personal_history }
      ]
    end

    def visible_alerts
      alerts.select { |a| a[:visible] }
    end

    def hints
      visible_alerts.map { |a| hint_tag(a[:label], a[:color], column_width) }
    end

    def segments
      visible_alerts.map { |a| segment_tag(a[:color], segment_width) }
    end

    def hint_tag(name, color, width)
      content_tag(:div, class: "col-md-#{width} text-center") do
        [
          content_tag(:span, class: "text-#{color}") do
            content_tag(:i, nil, class: 'fa fa-circle')
          end,
          content_tag(:span, name, class: 'text-mute')
        ].join.html_safe
      end
    end

    def segment_tag(color, width)
      content_tag(:div, nil, class: "progress-bar progress-bar-#{color}", style: "width: #{width}%")
    end
  end
end
