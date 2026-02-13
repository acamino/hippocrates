require 'rails_helper'

RSpec.describe Document do
  describe 'associations' do
    it { is_expected.to belong_to(:consultation) }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'before_save :normalize' do
    it 'strips and upcases the description' do
      consultation = create(:consultation)
      doc = consultation.documents.create!(description: '  lab results  ')

      expect(doc.description).to eq('LAB RESULTS')
    end
  end
end
