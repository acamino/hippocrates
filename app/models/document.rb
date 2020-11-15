class Document < ApplicationRecord
  ATTRIBUTE_WHITELIST = [
    :description,
    images_attributes: Image::ATTRIBUTE_WHITELIST + [:id, :_destroy]
  ].freeze

  belongs_to :consultation

  has_many :images, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :description, presence: true

  before_save :normalize

  private

  def normalize
    normalize_fields :description
  end
end
