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
  aws_secrets = Rails.application.secrets.aws

  {
    cache: Shrine::Storage::FileSystem.new('tmp', prefix: 'uploads/cache'),
    store: Shrine::Storage::S3.new(
      prefix:            Rails.env,
      bucket:            aws_secrets[:bucket],
      access_key_id:     aws_secrets[:access_key_id],
      secret_access_key: aws_secrets[:secret_access_key],
      region:            'us-east-1'
    )
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
