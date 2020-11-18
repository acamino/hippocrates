class Document < ApplicationRecord
  ATTRIBUTE_WHITELIST = [
    :description,
    attachments_attributes: Attachment::ATTRIBUTE_WHITELIST + [:id, :_destroy]
  ].freeze

  belongs_to :consultation

  has_many :attachments, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :description, presence: true

  before_save :normalize

  private

  def normalize
    normalize_fields :description
  end
end
