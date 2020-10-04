require 'rails_helper'

describe Certificate do
  describe '#build' do
    let(:start_time)             { '' }
    let(:end_time)               { '' }
    let(:rest_time)              { '' }
    let(:surgical_treatment)     { '' }
    let(:surgery_tentative_date) { '' }
    let(:surgery_cost)           { '' }
    let(:consultations)          { [] }
    let(:consultation) do
      create(:consultation, :with_diagnoses, created_at: '2016-01-01', patient: patient)
    end
    let(:other_consultation) do
      create(:consultation, :with_diagnoses, created_at: '2016-01-02', patient: patient)
    end
    let(:patient) do
      create(:patient, identity_card_number: 'icn-101',
                       first_name: 'Rene',
                       last_name: 'Brown',
                       birthdate: Date.new(2011, 12, 8),
                       gender: gender)
    end
    let(:certificate) do
      {
        patient: patient,
        consultation: consultation,
        definite_article: definite_article,
        current_date: '21 de Octubre de 2015',
        start_time: start_time,
        end_time: end_time,
        rest_time: rest_time,
        surgical_treatment: surgical_treatment,
        surgery_tentative_date: surgery_tentative_date,
        surgery_cost: surgery_cost,
        consultations: consultations
      }
    end

    context 'when patient is male' do
      let(:gender)           { 'male' }
      let(:definite_article) { 'el' }

      it 'builds certificate for male' do
        Timecop.freeze('2015-10-21') do
          expect(described_class.for(consultation)).to eq(certificate)
        end
      end
    end

    context 'when patient is female' do
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate for female' do
        Timecop.freeze('2015-10-21') do
          expect(described_class.for(consultation)).to eq(certificate)
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
          expect(described_class.for(consultation, options)).to eq(certificate)
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
          expect(described_class.for(consultation, options)).to eq(certificate)
        end
      end
    end

    context 'when surgery options are given' do
      let(:surgical_treatment)     { 'TREATMENT' }
      let(:surgery_tentative_date) { 'TENTATIVE DATE' }
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

          expect(described_class.for(consultation, options)).to eq(certificate)
        end
      end
    end

    context 'when medical history options are given' do
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate for medical history' do
        Timecop.freeze('2015-10-21') do
          options = { consultations: '' }
          expect(described_class.for(consultation, options)).to eq(certificate)
        end
      end

      context 'when no consultations are selected' do
        it 'returns an empty list' do
          options = { consultations: '' }
          certificate = described_class.for(consultation, options)
          expect(certificate[:consultations]).to eq([])
        end
      end

      context 'when consultations are selected' do
        let(:options)         { { consultations: "#{other_consultation.id}_#{consultation.id}" } }
        subject(:certificate) { described_class.for(consultation, options) }

        it 'returns a sorted list of selected certificates' do
          expect(certificate[:consultations]).to eq([consultation, other_consultation])
        end

        context 'when the first consultation was selected' do
          it 'the first consultation is marked as head' do
            expect(certificate[:consultations].first.head).to be_truthy
          end

          it 'the other consultations are not marked as head' do
            expect(certificate[:consultations].second.head).to be_falsey
          end
        end

        context 'when the first consultation was not selected' do
          let(:options) { { consultations: other_consultation.id.to_s } }

          it 'the first consultation is not marked as head' do
            expect(certificate[:consultations].first.head).to be_falsey
          end
        end
      end
    end
  end
end
