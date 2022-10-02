require 'rails_helper'

describe ActivityPresenter do
  describe '#patient' do
    let(:patient)  { create(:patient) }
    let(:activity) { create(:activity, trackable: model) }

    subject(:presenter_patient) { described_class.new(activity).patient }

    shared_examples 'tracked entity' do
      it 'returns the patient' do
        expect(presenter_patient).to eq(patient)
      end
    end

    context 'when the tracked model is an anamnesis' do
      let(:model) { create(:anamnesis, patient: patient) }

      it_behaves_like 'tracked entity'
    end

    context 'when the tracked model is an consultation' do
      let(:model) { create(:consultation, patient: patient) }

      it_behaves_like 'tracked entity'
    end

    context 'when the tracked model is an anamnesis' do
      let(:model) { patient }

      it_behaves_like 'tracked entity'
    end
  end

  describe '#model' do
    shared_examples 'tracked model' do |entity_type, expected_model|
      context "when the tracked entity is #{entity_type}" do
        let(:model)    { create(entity_type) }
        let(:activity) { create(:activity, trackable: model) }

        subject(:presenter_model) { described_class.new(activity).model }

        it { is_expected.to eq(expected_model) }
      end
    end

    it_behaves_like 'tracked model', :anamnesis,    'ANAMNESIS'
    it_behaves_like 'tracked model', :consultation, 'CONSULTA'
    it_behaves_like 'tracked model', :patient,      'PACIENTE'
  end

  describe '#action' do
    shared_examples 'tracked action' do |key, expected_action|
      context "when the key is #{key}" do
        let(:activity) { create(:activity, key: key) }

        subject(:presenter_model) { described_class.new(activity).action }

        it { is_expected.to eq(expected_action) }
      end
    end

    it_behaves_like 'tracked action', 'anamnesis.viewed',     'ABRIR'
    it_behaves_like 'tracked action', 'anamnesis.created',    'CREAR'
    it_behaves_like 'tracked action', 'anamnesis.updated',    'EDITAR'
    it_behaves_like 'tracked action', 'anamnesis.deleted',    'ELIMINAR'
    it_behaves_like 'tracked action', 'consultation.viewed',  'ABRIR'
    it_behaves_like 'tracked action', 'consultation.created', 'CREAR'
    it_behaves_like 'tracked action', 'consultation.updated', 'EDITAR'
    it_behaves_like 'tracked action', 'consultation.deleted', 'ELIMINAR'
    it_behaves_like 'tracked action', 'patient.viewed',       'ABRIR'
    it_behaves_like 'tracked action', 'patient.created',      'CREAR'
    it_behaves_like 'tracked action', 'patient.updated',      'EDITAR'
    it_behaves_like 'tracked action', 'patient.deleted',      'ELIMINAR'
  end
end
