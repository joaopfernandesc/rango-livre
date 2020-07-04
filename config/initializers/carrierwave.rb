CarrierWave.configure do |config|
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["AWS_MEGA_ID"],
      aws_secret_access_key: ENV["AWS_MEGA_KEY"],
      region: 'sa-east-1'
    }
    config.fog_directory = ENV["S3_BUCKET"]
    config.fog_public = false
    config.fog_authenticated_url_expiration = 3600
  end