require 'shrine'
require "shrine/storage/file_system"
require 'shrine/storage/memory'
require 'shrine/storage/s3'

Shrine.storages = if Rails.env.test?
  {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  {
    cache: Shrine::Storage::FileSystem.new('tmp', prefix: 'uploads/cache'),
    store: Shrine::Storage::S3.new(
      prefix:            Rails.env,
      bucket:            ENV.fetch('AWS_BUCKET'),
      access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region:            'us-east-1'
    )
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
