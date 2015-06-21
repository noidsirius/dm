CarrierWave.configure do |config|
  config.storage = :file
  config.asset_host = "http://acm.ut.ac.ir/dm-test"
      # ActionController::Base.asset_host
end