class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:content)

  ATTRIBUTE_WHITELIST = [
    :content
  ].freeze

  belongs_to :document
end
