require 'grape/middleware/base'

module GrapeLogging
  module Middleware
    class RequestLogger < Grape::Middleware::Base

      ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        GrapeLogging::Timings.append_db_runtime(event)
      end if defined?(ActiveRecord)

      def initialize(app, options = {})
        super

        @included_loggers = @options[:include] || []
        @reporter = if options[:instrumentation_key]
          Reporters::ActiveSupportReporter.new(@options[:instrumentation_key])
        else
          Reporters::LoggerReporter.new(@options[:logger], @options[:formatter])
        end
      end

      def before
        reset_db_runtime
        start_time

        invoke_included_loggers(:before)
      end

      def after
        stop_time
        @reporter.perform(collect_parameters)
        invoke_included_loggers(:after)
        nil
      end

      def call!(env)
        super
      end

      protected

      def response
        begin
          super
        rescue
          nil
        end
      end

      def parameters
        {
          status: response.nil? ? 'fail' : response.status,
          time: {
            total: total_runtime,
            db: db_runtime,
            view: view_runtime
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

      def view_runtime
        total_runtime - db_runtime
      end

      def db_runtime
        GrapeLogging::Timings.db_runtime.round(2)
      end

      def reset_db_runtime
        GrapeLogging::Timings.reset_db_runtime
      end

      def start_time
        @start_time ||= Time.now
      end

      def stop_time
        @stop_time ||= Time.now
      end

      def collect_parameters
        parameters.tap do |params|
          @included_loggers.each do |logger|
            params.merge! logger.parameters(request, response) do |_, oldval, newval|
              oldval.respond_to?(:merge) ? oldval.merge(newval) : newval
            end
          end
        end
      end

      def invoke_included_loggers(method_name)
        @included_loggers.each do |logger|
          logger.send(method_name) if logger.respond_to?(method_name)
        end
      end
    end
  end
end
