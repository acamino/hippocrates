require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Hippocrates
  class Application < Rails::Application
    config.load_defaults 5.1
    config.time_zone = 'America/Guayaquil'
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :es
  end
end
