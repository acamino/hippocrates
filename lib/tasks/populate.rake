require 'open-uri'

namespace :db do
  desc 'Load the legacy data into the databse'
  task populate: :environment do
    [Medicine, Prescription, Diagnosis, Consultation, Anamnesis, Patient].each(&:delete_all)

    medicines_url = ENV['MEDICINES_SOURCE_URL']
    medicines_buffer = open(medicines_url).read

    raw_medicines = JSON.parse(medicines_buffer)

    medicines = raw_medicines.map do |raw_medicine|
      Medicine.new(raw_medicine)
    end

    Medicine.import medicines, validate: false

    patients_url = ENV['PATIENTS_SOURCE_URL']
    patients_buffer = open(patients_url).read

    raw_patients = JSON.parse(patients_buffer)

    patients = []
    raw_patients.each do |raw_patient|
      patient = Patient.new(raw_patient['attributes'])

      consultations = raw_patient['consultations']
      consultations.each do |consultation|
        patient.consultations.build(consultation)
      end
      patients << patient
    end

    Patient.import patients, recursive: true, validate: false

    anamneses_url = ENV['ANAMNESES_SOURCE_URL']
    anamneses_buffer = open(anamneses_url).read

    raw_anamneses = JSON.parse(anamneses_buffer)

    medical_history_to_patient_id = Patient.pluck(:medical_history, :id).to_h

    anamneses = []
    raw_anamneses.each do |raw_anamnesis|
      patient_id = medical_history_to_patient_id[raw_anamnesis['medical_history']]
      anamnesis = Anamnesis.new(raw_anamnesis['attributes'].merge(patient_id: patient_id))

      anamneses << anamnesis
    end

    Anamnesis.import anamneses
  end
end
