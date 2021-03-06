# frozen_string_literal: true

require 'minfraud/model/error'
require 'minfraud/model/factors'
require 'minfraud/model/insights'
require 'minfraud/model/score'

module Minfraud
  module HTTPService
    # Response class for HTTP requests.
    class Response
      # HTTP response status.
      #
      # @return [Integer, nil]
      attr_reader :status

      # HTTP response model.
      #
      # @return [Minfraud::Model::Score, Minfraud::Model::Insights,
      #   Minfraud::Model::Factors, nil]
      attr_reader :body

      # HTTP response headers.
      #
      # @return [Hash, nil]
      attr_reader :headers

      # @param params [Hash] Hash of parameters. +:status+, +:endpoint+,
      #   +:body+, +:locales+, and +:headers+ are used.
      def initialize(params = {})
        @status  = params[:status]
        @body    = make_body(
          params[:endpoint],
          params[:body],
          params[:locales]
        )
        @headers = params[:headers]
      end

      # Return the minFraud-specific response code.
      #
      # @return [Symbol, nil]
      def code
        return nil if body.nil?

        body.code.intern if body.respond_to?(:code) && body.code
      end

      private

      def make_body(endpoint, body, locales)
        if @status != 200
          # Won't be a Hash when the body is not JSON.
          return nil unless body.is_a?(Hash)

          return Minfraud::Model::Error.new(body)
        end

        ENDPOINT_TO_CLASS[endpoint].new(body, locales)
      end

      ENDPOINT_TO_CLASS = {
        factors:  Minfraud::Model::Factors,
        insights: Minfraud::Model::Insights,
        score:    Minfraud::Model::Score
      }.freeze
    end
  end
end
