require 'faraday'
require 'faraday_middleware'

module Minfraud
  module HTTPService
    class << self
      # @return [Hash] default HTTPService configuration
      def configuration
        {
          middleware: DEFAULT_MIDDLEWARE,
          server:     DEFAULT_SERVER
        }
      end
    end

    # Minfraud default middleware stack
    DEFAULT_MIDDLEWARE = Proc.new do |builder|
      builder.request    :json

      builder.basic_auth *::Minfraud.configuration
      builder.response   :mashify, content_type: /\bjson$/

      builder.use        :instrumentary
      builder.adapter    Faraday.default_adapter
    end

    # Minfraud default server
    DEFAULT_SERVER = 'https://minfraud.maxmind.com/minfraud/v2.0'
  end
end
