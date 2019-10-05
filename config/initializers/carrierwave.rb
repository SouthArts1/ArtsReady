if Rails.env.test? or Rails.env.cucumber? or Rails.env.development?

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

else
  require 'carrierwave/storage/fog'

  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                 => 'us-east-1'
    }
    config.fog_directory  = S3_UPLOAD_BUCKET
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  end

end
