# frozen_string_literal: true

class DiagnosisResource
  include Alba::Resource

  attributes :description, :type, :diseaseCode

  def diseaseCode(diagnosis)
    diagnosis.disease_code
  end
end
