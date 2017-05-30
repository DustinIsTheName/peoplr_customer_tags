require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PeoplrCustomerTags
  class Application < Rails::Application
    require 'ext/string'
    require 'ext/colorize'
    require 'json'
    require 'openssl'
    require 'base64'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    ShopifyAPI::Base.site = "https://#{ENV["API_KEY"]}:#{ENV["PASSWORD"]}@peoplr.myshopify.com/admin"
  end
end
