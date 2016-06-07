require 'rails_helper'

describe '.alerts_for' do
  context 'when anamnesis has only allergies' do
    let(:anamnesis) { build(:anamnesis, observations: '', personal_history: '') }

    it 'builds a hint for allergies' do
      doc = Nokogiri::XML(helper.alerts_for(anamnesis))
      expect(doc.at_xpath('/div/div[1]/span[2]').content).to eq('Alergias')
      expect(doc.at_xpath('/div/div[1]/@class').content).to eq('col-md-12 text-center')
    end
  end

  context 'when anamnesis has allergies and observations' do
    let(:anamnesis) { build(:anamnesis, personal_history: '') }

    it 'builds a hint for allergies' do
      doc = Nokogiri::XML(helper.alerts_for(anamnesis))
      expect(doc.at_xpath('/div/div[1]/span[2]').content).to eq('Alergias')
      expect(doc.at_xpath('/div/div[1]/@class').content).to eq('col-md-6 text-center')
    end

    it 'builds a hint for observations' do
      doc = Nokogiri::XML(helper.alerts_for(anamnesis))
      expect(doc.at_xpath('/div/div[2]/span[2]').content).to eq('Observaciones')
      expect(doc.at_xpath('/div/div[2]/@class').content).to eq('col-md-6 text-center')
    end
  end
end
