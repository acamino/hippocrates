# frozen_string_literal: true

class ActivityPresenter < SimpleDelegator
  MODELS = {
    'Anamnesis'    => 'ANAMNESIS',
    'Consultation' => 'CONSULTA',
    'Patient'      => 'PACIENTE'
  }.freeze

  ACTIONS = {
    'viewed'  => 'ABRIR',
    'created' => 'CREAR',
    'updated' => 'EDITAR',
    'deleted' => 'ELIMINAR'
  }.freeze

  def initialize(activity)
    super
    @action = activity.key.split('.').last
  end

  def patient
    case trackable_type
    when 'Anamnesis', 'Consultation'
      trackable.patient
    when 'Patient'
      trackable
    end
  end

  def model
    MODELS.fetch(trackable_type, trackable_type.upcase)
  end

  def action
    ACTIONS.fetch(@action, @action.upcase)
  end
end
