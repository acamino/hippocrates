class AttachmentUploader < Shrine
  plugin :determine_mime_type
  plugin :validation_helpers

  ALLOWED_MIME_TYPES = %w[
    image/jpeg
    image/png
    image/bmp
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    application/zip
    application/octet-stream
  ].freeze

  MAX_FILE_SIZE = 25 * 1024 * 1024 # 25 MB

  Attacher.validate do
    validate_mime_type_inclusion ALLOWED_MIME_TYPES
    validate_max_size MAX_FILE_SIZE
  end
end
