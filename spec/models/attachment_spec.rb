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

    it 'returns true for BMP files' do
      content = instance_double('UploadedFile', mime_type: 'image/bmp')
      allow(attachment).to receive(:content).and_return(content)

      expect(attachment).to be_image
    end

    it 'returns false for PDF files' do
      content = instance_double('UploadedFile', mime_type: 'application/pdf')
      allow(attachment).to receive(:content).and_return(content)

      expect(attachment).not_to be_image
    end
  end

  describe 'upload validations' do
    let(:consultation) { create(:consultation) }
    let(:document) { consultation.documents.create!(description: 'test') }
    let(:attachment) { document.attachments.build }

    # File headers that the `file` command recognizes for each MIME type.
    # PNG needs an IHDR chunk, BMP needs a valid DIB header, and OLE
    # (msword) is detected as application/octet-stream by `file`.
    MAGIC_BYTES = {
      'image/jpeg' => "\xFF\xD8\xFF\xE0".b,
      'image/png' => "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00".b,
      'image/bmp' => "BM\x36\x00\x0c\x00\x00\x00\x00\x00\x36\x00\x00\x00\x28\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x18\x00".b,
      'application/pdf' => "%PDF-1.4\n".b,
      'application/octet-stream' => "\xD0\xCF\x11\xE0\xA1\xB1\x1A\xE1".b,
      'application/zip' => "PK\x03\x04".b
    }.freeze

    # OOXML formats (docx, xlsx) are ZIP archives with specific internal structure.
    # The `file` command detects them as application/zip, so we use the
    # application/zip magic bytes for these types too.
    OOXML_TYPES = %w[
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    ].freeze

    def fake_io_for(mime_type, size: nil)
      magic = MAGIC_BYTES[mime_type] || MAGIC_BYTES['application/zip']
      content = if size
                  magic + ("\x00".b * [size - magic.bytesize, 0].max)
                else
                  magic + ("\x00".b * 256)
                end
      StringIO.new(content)
    end

    def attach_file(attachment, mime_type:, size: nil)
      io = fake_io_for(mime_type, size: size)
      attacher = attachment.content_attacher
      attacher.assign(io)
      attacher
    end

    describe 'MIME type validation' do
      %w[
        image/jpeg
        image/png
        image/bmp
        application/pdf
      ].each do |mime_type|
        it "allows #{mime_type}" do
          attacher = attach_file(attachment, mime_type: mime_type)
          expect(attacher.errors).to be_empty
        end
      end

      # OLE files (.doc) are detected as application/octet-stream by `file`
      it 'allows application/msword (OLE format detected as application/octet-stream)' do
        attacher = attach_file(attachment, mime_type: 'application/octet-stream')
        expect(attacher.errors).to be_empty
      end

      # OOXML files (.docx, .xlsx) are ZIP archives internally
      OOXML_TYPES.each do |mime_type|
        it "allows #{mime_type} (detected as application/zip)" do
          attacher = attach_file(attachment, mime_type: mime_type)
          expect(attacher.errors).to be_empty
        end
      end

      it 'rejects text/plain' do
        io = StringIO.new('just some plain text content here')
        attacher = attachment.content_attacher
        attacher.assign(io)
        expect(attacher.errors).not_to be_empty
      end

      it 'rejects text/html' do
        io = StringIO.new('<!DOCTYPE html><html><body>test</body></html>')
        attacher = attachment.content_attacher
        attacher.assign(io)
        expect(attacher.errors).not_to be_empty
      end
    end

    describe 'file size validation' do
      it 'allows files up to 25 MB' do
        attacher = attach_file(attachment, mime_type: 'application/pdf',
                                           size: 25 * 1024 * 1024)
        expect(attacher.errors).to be_empty
      end

      it 'rejects files over 25 MB' do
        attacher = attach_file(attachment, mime_type: 'application/pdf',
                                           size: 25 * 1024 * 1024 + 1)
        expect(attacher.errors).not_to be_empty
      end
    end
  end
end
