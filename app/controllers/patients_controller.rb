class PatientsController < ApplicationController
  def index
    # XXX: Sort the patients alphabetically
    # XXX: Add pagination
    @patients = Patient.all
  end

  def new
    @patient = Patient.new
  end
end
