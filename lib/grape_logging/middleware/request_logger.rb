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
        if options[:instrumentation_key]
          @instrumentation_key = options[:instrumentation_key]
        else
          @logger = @options[:logger] || Logger.new(STDOUT)
          @logger.formatter = @options[:formatter] || GrapeLogging::Formatters::Default.new
        end
        @included_loggers = @options[:include] || []
      end

      def before
        reset_db_runtime
        start_time
        @included_loggers.each(&:before)
      end

      def after
        stop_time

        params = parameters
        @included_loggers.each do |included_logger|
          params.merge! included_logger.parameters(request, response) do |key, oldval, newval|
            oldval.respond_to?(:merge) ? oldval.merge(newval) : newval
          end
        end
        if @instrumentation_key
          ActiveSupport::Notifications.instrument @instrumentation_key, params
        else
          @logger.info params
        end
        @included_loggers.each { |included_logger| included_logger.after if included_logger.respond_to?(:after) }
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
          status: response.try(:status),
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

    end
  end
end
