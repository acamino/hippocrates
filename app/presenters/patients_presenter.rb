# frozen_string_literal: true

require 'forwardable'

class PatientsPresenter < SimpleDelegator
  extend Forwardable

  def_delegators :@patients, :total_pages, :current_page, :limit_value

  def initialize(patients)
    @patients = patients
  end

  def each
    @patients.each do |patient|
      yield PatientPresenter.new(patient)
    end
  end
end
