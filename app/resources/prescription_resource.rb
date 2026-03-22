# frozen_string_literal: true

class PrescriptionResource
  include Alba::Resource

  attributes :inscription, :subscription
end
