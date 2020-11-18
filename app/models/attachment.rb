class Attachment < ApplicationRecord
  include AttachmentUploader::Attachment.new(:content)

  ATTRIBUTE_WHITELIST = [
    :content
  ].freeze

  IMAGE_MIME_TYPES = [
    'image/jpeg',
    'image/png'
  ].freeze

  belongs_to :document

  def image?
    IMAGE_MIME_TYPES.include?(content.mime_type)
  end
end
