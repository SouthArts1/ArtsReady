if Rails.env.test? or Rails.env.cucumber?

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

else

  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAIQOM47FHJ7KVTS3Q',
      :aws_secret_access_key  => '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',
      :region                 => 'us-east-1'
    }
    config.fog_directory  = S3_UPLOAD_BUCKET
    # config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  end

end