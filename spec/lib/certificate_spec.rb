require 'rails_helper'

describe Certificate do
  describe '#build' do
    let(:start_time)             { '' }
    let(:end_time)               { '' }
    let(:rest_time)              { '' }
    let(:surgical_treatment)     { '' }
    let(:surgery_tentative_date) { '' }
    let(:surgery_cost)           { '' }
    let(:consultation) { build(:consultation, :with_diagnoses, patient: patient) }
    let(:patient) do
      build(:patient, identity_card_number: 'icn-101',
                      first_name: 'Rene',
                      last_name: 'Brown',
                      birthdate: Date.new(2011, 12, 8),
                      gender: gender)
    end
    let(:certificate) do
      {
        patient: patient,
        consultation: consultation,
        diagnosis: consultation.diagnoses.first,
        definite_article: definite_article,
        current_date: '21 de Octubre de 2015',
        start_time: start_time,
        end_time: end_time,
        rest_time: rest_time,
        surgical_treatment: surgical_treatment,
        surgery_tentative_date: surgery_tentative_date,
        surgery_cost: surgery_cost
      }
    end

    context 'when patient is male' do
      let(:gender)           { 'male' }
      let(:definite_article) { 'el' }

      it 'builds certificate for male' do
        Timecop.freeze('2015-10-21') do
          expect(described_class.for(consultation).build).to eq(certificate)
        end
      end
    end

    context 'when patient is female' do
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate for female' do
        Timecop.freeze('2015-10-21') do
          expect(described_class.for(consultation).build).to eq(certificate)
        end
      end
    end

    context 'when time options are given' do
      let(:start_time)       { '10:00 am' }
      let(:end_time)         { '11:30 am' }
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate for attendance' do
        Timecop.freeze('2015-10-21') do
          options = { start_time: '10:00 am', end_time: '11:30 am' }
          expect(described_class.for(consultation, options).build).to eq(certificate)
        end
      end
    end

    context 'when rest options are given' do
      let(:rest_time)        { '48' }
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate for rest' do
        Timecop.freeze('2015-10-21') do
          options = { rest_time: '48' }
          expect(described_class.for(consultation, options).build).to eq(certificate)
        end
      end
    end

    context 'when surgery options are given' do
      let(:surgical_treatment)     { 'treatment' }
      let(:surgery_tentative_date) { 'tentative date' }
      let(:surgery_cost)           { 'cost' }
      let(:gender)                 { 'female' }
      let(:definite_article)       { 'la' }

      it 'builds certificate for surgery' do
        Timecop.freeze('2015-10-21') do
          options = {
            surgical_treatment: 'treatment',
            surgery_tentative_date: 'tentative date',
            surgery_cost: 'cost'
          }

          expect(described_class.for(consultation, options).build).to eq(certificate)
        end
      end
    end
  end
end
