  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJYJHJJFEPIOQZW4A',
      :aws_secret_access_key  => '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',
      :region                 => 'us-east-1'
    }
    config.fog_directory  = "fracturedatlas-artsready-#{Rails.env}"
    # config.fog_host       = 'http://artsready-staging.s3-website-us-east-1.amazonaws.com/'
    # config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  end
# FA credentials https://fracturedatlas.signin.aws.amazon.com/console 
# ashenfelterj/ba12AEy6SjgJ
# AKIAJLDW35SNDYIRVVWA
# bP6EFpiAvXo4eYlyYgaJJLwO/mVXLLDri8TxKcgB
# AKIAIINDW7QVIZS52DNA
# mQidwnxAVVbILq9UkGVg7zErAgbZxQW3u

# fracturedatlas-artsready-dev
# fracturedatlas-artsready


# AKIAI7AKMCQ35E6UT3QQ
# Secret Access Key:
# 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

# TP credentials
# AKIAIRE5ALCOTXCXK6YQ
# e9OaMIFYzNXcLKM5hSOl3PJRL0YVpprY4YA2DYVp
# artsready-staging

# if Rails.env.test? or Rails.env.cucumber?
# 
#   CarrierWave.configure do |config|
#     config.storage = :file
#     config.enable_processing = false
#   end
# 
# elsif Rails.env.production?
# 
#   CarrierWave.configure do |config|
#     config.cache_dir = "#{Rails.root}/tmp"
#     config.fog_credentials = {
#       :provider               => 'AWS',
#       :aws_access_key_id      => 'AKIAJLDW35SNDYIRVVWA',
#       :aws_secret_access_key  => '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',
#       :region                 => 'us-east-1'
#     }
#     config.fog_directory  = 'artsready'
#     config.fog_host       = 'http://artsready-staging.s3-website-us-east-1.amazonaws.com/'
#     config.fog_public     = true
#     config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
#   end
# 
# elsif Rails.env.staging?
# 
#   CarrierWave.configure do |config|
#     config.cache_dir = "#{Rails.root}/tmp"
#     config.fog_credentials = {
#       :provider               => 'AWS',
#       :aws_access_key_id      => 'AKIAJLDW35SNDYIRVVWA',
#       :aws_secret_access_key  => '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',
#       :region                 => 'us-east-1'
#     }
#     config.fog_directory  = 'artsready-staging'
#     config.fog_host       = 'http://artsready-staging.s3-website-us-east-1.amazonaws.com/'
#     config.fog_public     = true
#     config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
#   end
# 
# else
#   
#   CarrierWave.configure do |config|
#     config.fog_credentials = {
#       :provider               => 'AWS',
#       :aws_access_key_id      => 'AKIAJLDW35SNDYIRVVWA',
#       :aws_secret_access_key  => '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',
#       :region                 => 'us-east-1'
#     }
#     config.fog_directory  = 'artsready-dev'
#     config.fog_host       = 'http://artsready-staging.s3-website-us-east-1.amazonaws.com/'
#     config.fog_public     = true
#     config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
#   end
# end