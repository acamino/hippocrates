# frozen_string_literal: true

class ConsultationResource
  include Alba::Resource

  attributes :id, :date, :next_appointment, :ongoing_issue, :reason,
             :hasDiagnoses, :hasPrescriptions, :hasNextAppointment

  one :patient, resource: ConsultationPatientResource
  many :diagnoses, resource: DiagnosisResource
  many :prescriptions, resource: PrescriptionResource

  def date(consultation)
    presenter(consultation).date
  end

  def next_appointment(consultation)
    presenter(consultation).next_appointment_date if presenter(consultation).next_appointment?
  end

  def hasDiagnoses(consultation)
    presenter(consultation).diagnoses?
  end

  def hasPrescriptions(consultation)
    presenter(consultation).prescriptions?
  end

  def hasNextAppointment(consultation)
    presenter(consultation).next_appointment?
  end

  private

  def presenter(consultation)
    @presenter ||= ConsultationPresenter.new(consultation)
  end
end
