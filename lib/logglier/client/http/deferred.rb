module Logglier
  module Client
    class HTTP

      # Allows the HTTP::DeliveryThread to be lazily loaded the first time it is
      # written to.  This is particularly useful with preforking servers such as
      # Unicorn where threads will be lost after forking.
      class DeferredDeliveryThread
        def initialize(input_uri, opts={})
          $stderr.puts "INITIALIZING DEFERRED DELIVERY THREAD"
          @input_uri, @opts = input_uri, opts
        end

        def deliver(message)
          @delivery_thread ||= DeliveryThread.new(@input_uri, @opts)
          @delivery_thread.deliver(message)
        end
      end
    end
  end
end
