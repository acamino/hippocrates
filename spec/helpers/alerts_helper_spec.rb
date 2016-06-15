require 'rails_helper'

describe '.alerts_for' do
  let(:doc) { Nokogiri::XML(helper.alerts_for(anamnesis)) }

  context 'when anamnesis has only allergies' do
    let(:anamnesis) do
      build(:anamnesis, observations: '', personal_history: '')
    end

    it 'builds a hint for allergies' do
      expect(doc.at_xpath('/div/div[1]/span[2]').content)
        .to eq('Alergias')
      expect(doc.at_xpath('/div/div[1]/@class').content)
        .to eq('col-md-12 col-xs-12 text-center')
    end
  end

  context 'when anamnesis has allergies and observations' do
    let(:anamnesis) { build(:anamnesis, personal_history: '') }

    it 'builds a hint for allergies' do
      expect(doc.at_xpath('/div/div[1]/span[2]').content)
        .to eq('Alergias')
      expect(doc.at_xpath('/div/div[1]/@class').content)
        .to eq('col-md-6 col-xs-6 text-center')
    end

    it 'builds a hint for observations' do
      expect(doc.at_xpath('/div/div[2]/span[2]').content)
        .to eq('Observaciones')
      expect(doc.at_xpath('/div/div[2]/@class').content)
        .to eq('col-md-6 col-xs-6 text-center')
    end
  end
end
