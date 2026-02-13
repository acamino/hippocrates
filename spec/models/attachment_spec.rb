require 'rails_helper'

RSpec.describe Attachment do
  describe 'associations' do
    it { is_expected.to belong_to(:document) }
  end

  describe '#image?' do
    let(:consultation) { create(:consultation) }
    let(:document) { consultation.documents.create!(description: 'test') }
    let(:attachment) { document.attachments.build }

    it 'returns true for JPEG files' do
      content = instance_double('UploadedFile', mime_type: 'image/jpeg')
      allow(attachment).to receive(:content).and_return(content)

      expect(attachment).to be_image
    end

    it 'returns true for PNG files' do
      content = instance_double('UploadedFile', mime_type: 'image/png')
      allow(attachment).to receive(:content).and_return(content)

      expect(attachment).to be_image
    end

    it 'returns false for PDF files' do
      content = instance_double('UploadedFile', mime_type: 'application/pdf')
      allow(attachment).to receive(:content).and_return(content)

      expect(attachment).not_to be_image
    end
  end
end
