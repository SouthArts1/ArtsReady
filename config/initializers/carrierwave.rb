CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAIRE5ALCOTXCXK6YQ',
    :aws_secret_access_key  => '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',
    :region                 => 'us-east-1'
  }
  config.fog_directory  = 'artsready-staging'
  config.fog_host       = 'https://assets.example.com'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end