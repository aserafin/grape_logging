require 'grape/middleware/base'

module GrapeLogging
  module Middleware
    class RequestLogger < Grape::Middleware::Base
      def initialize(app, options = {})
        super
        if options[:instrumentation_key]
          @instrumentation_key = options[:instrumentation_key]
        else
          @logger = @options[:logger] || Logger.new(STDOUT)
          @logger.formatter = @options[:formatter] || GrapeLogging::Formatters::Default.new
        end
        @included_loggers = @options[:include] || []
      end

      def before
        start_time
        @included_loggers.each { |included_logger| included_logger.before }
      end

      def after
        stop_time

        parameters = parameters(request, response)
        @included_loggers.each do |included_logger|
          parameters.merge! included_logger.parameters(request, response) do |key, oldval, newval|
            oldval.respond_to?(:merge) ? oldval.merge(newval) : newval
          end
        end
        if @instrumentation_key
          ActiveSupport::Notifications.instrument @instrumentation_key, parameters
        else
          @logger.info parameters
        end
        nil
      end

      def call!(env)
        super
      ensure
        ActiveSupport::Notifications.unsubscribe(@subscription) if @subscription
      end

      protected
      def parameters(request, response)
        {
          status: response.status,
          time: {
            total: total_runtime
          },
          method: request.request_method,
          path: request.path,
          params: request.params
        }
      end

      private
      def request
        @request ||= ::Rack::Request.new(env)
      end

      def total_runtime
        ((stop_time - start_time) * 1000).round(2)
      end

      def start_time
        @start_time ||= Time.now
      end

      def stop_time
        @stop_time ||= Time.now
      end

    end
  end
end
