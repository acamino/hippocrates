# frozen_string_literal: true

require 'forwardable'

class ConsultationsPresenter < SimpleDelegator
  extend Forwardable

  def_delegators :@consultations, :total_pages, :current_page, :limit_value

  def initialize(consultations)
    @consultations = consultations
  end

  def each
    @consultations.each do |consultation|
      yield ConsultationPresenter.new(consultation)
    end
  end
end
