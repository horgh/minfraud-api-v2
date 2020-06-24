# frozen_string_literal: true

module Minfraud
  module Components
    class ShoppingCart < Base
      # @attribute items
      # @return [Array] An array of Minfraud::Components::ShoppingCartItem instances

      attr_accessor :items

      # Creates Minfraud::Components::ShoppingCart instance
      # @param  [Hash] params hash of parameters
      # @return [Minfraud::Components::ShoppingCart] ShoppingCart instance
      def initialize(params = {})
        @items = params.map(&method(:resolve))
      end

      # @return [Array] a JSON representation of Minfraud::Components::ShoppingCart items
      def to_json(*_args)
        @items.map(&:to_json)
      end

      private

      # @param  [Hash] params hash of parameters for Minfraud::Components::ShoppingCartItem
      # or Minfraud::Components::ShoppingCartItem instance
      # @return [Minfraud::Components::ShoppingCart] ShoppingCart instance
      def resolve(params)
        params.is_a?(ShoppingCartItem) ? params : ShoppingCartItem.new(params)
      end
    end
  end
end
