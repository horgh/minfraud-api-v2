# frozen_string_literal: true

module Minfraud
  # ErrorHandler provides a method to raise exceptions on errors.
  module ErrorHandler
    class << self
      # Return the response if the HTTP status code is 2xx. Otherwise raise
      # an error.
      #
      # @param response [Minfraud::HTTPService::Response]
      #
      # @return [Minfraud::HTTPService::Response]
      #
      # @raise [Minfraud::AuthorizationError] If there was an authentication
      #   problem.
      #
      # @raise [Minfraud::ClientError] If there was a critical problem with one
      #   of your inputs.
      #
      # @raise [Minfraud::ServerError] If the server reported an error of some
      #   kind.
      def examine(response)
        return response if response.status > 199 && response.status < 300

        raise(*STATUS_CODES.fetch(response.code, [ServerError, 'Server error']))
      end

      # @!visibility private
      STATUS_CODES = {
        JSON_INVALID:          [
          ClientError, 'JSON body cannot be decoded'
        ],
        MAXMIND_ID_INVALID:    [
          ClientError, 'You have not supplied a valid maxmind_id'
        ],
        MINFRAUD_ID_INVALID:   [
          ClientError, 'You have not supplied a valid minfraud_id'
        ],
        PARAMETER_UNKNOWN:     [
          ClientError, 'You have supplied an unknown parameter'
        ],
        REQUEST_INVALID:       [
          ClientError, 'The request did not contain any valid input values.'
        ],
        TAG_REQUIRED:          [
          ClientError, 'You have not supplied a tag, which is a required field'
        ],
        TAG_INVALID:           [
          ClientError, 'You have not supplied a valid tag'
        ],
        ACCOUNT_ID_REQUIRED:   [
          AuthorizationError, 'You have not supplied a account ID'
        ],
        AUTHORIZATION_INVALID: [
          AuthorizationError, 'Invalid license key and / or account ID'
        ],
        LICENSE_KEY_REQUIRED:  [
          AuthorizationError, 'You have not supplied a license key'
        ],
        USER_ID_REQUIRED:      [
          AuthorizationError, 'You have not supplied a account id'
        ],
        INSUFFICIENT_FUNDS:    [
          ClientError, 'The license key you have provided does not have a sufficient funds to use this service'
        ],
        PERMISSION_REQUIRED:   [
          ClientError, 'You do not have permission to use this service'
        ]
      }.freeze
    end
  end
end
