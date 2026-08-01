class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Zero-width and bidirectional formatting characters: zero-width space/joiners,
  # directional marks, embeddings, overrides, isolates and the byte order mark.
  # They are invisible in the browser, so they survive copy-paste from phone
  # contacts, WhatsApp or Excel unnoticed, and then break PDF generation.
  INVISIBLE_CHARACTER_RANGES = [
    0x200B..0x200F,
    0x202A..0x202E,
    0x2060..0x2064,
    0x2066..0x2069,
    0xFEFF..0xFEFF
  ].freeze

  INVISIBLE_CHARACTERS = Regexp.union(
    INVISIBLE_CHARACTER_RANGES.flat_map { |range| range.map { |code| code.chr(Encoding::UTF_8) } }
  ).freeze

  def normalize_fields(*fields)
    fields.map(&:to_s).each do |field|
      value = attributes[field]
      public_send("#{field}=", normalize_value(value)) if value.present?
    end
  end

  private

  def normalize_value(value)
    value.gsub(INVISIBLE_CHARACTERS, '').strip.upcase
  end
end
