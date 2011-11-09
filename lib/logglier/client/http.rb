require 'uri'

require File.join(File.dirname(__FILE__), 'http', 'sync')
require File.join(File.dirname(__FILE__), 'http', 'threaded')
require File.join(File.dirname(__FILE__), 'http', 'deferred')

module Logglier
  module Client
    class HTTP
      include Logglier::Client::InstanceMethods

      attr_reader :input_uri, :deliverer

      def initialize(opts={})
        setup_input_uri(opts)
        @format = opts[:format] ? opts[:format].to_sym : nil
        @deliverer = if opts[:threaded] && opts[:deferred]
          Logglier::Client::HTTP::DeferredDeliveryThread.new(@input_uri, opts)
        elsif opts[:threaded]
          Logglier::Client::HTTP::DeliveryThread.new(@input_uri, opts)
        else
          Logglier::Client::HTTP::NetHTTPProxy.new(@input_uri, opts)
        end
      end

      def write(message)
        @deliverer.deliver(message)
      end

      def close
        nil
      end
    end
  end
end

